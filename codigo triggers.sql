CREATE OR REPLACE FUNCTION fnc_validar_disponibilidad_vet (
    p_id_empleado IN NUMBER,
    p_fecha_hora  IN DATE
) RETURN NUMBER IS
    v_conteo NUMBER := 0;
BEGIN
    -- Contar citas activas para el empleado en la fecha y hora indicadas
    SELECT COUNT(*)
    INTO v_conteo
    FROM Citas
    WHERE id_empleado = p_id_empleado
      AND fecha_hora = p_fecha_hora;

    IF v_conteo > 0 THEN
        RETURN 0; -- No disponible
    ELSE
        RETURN 1; -- Disponible
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fnc_validar_disponibilidad_vet;
/

--segunda funcion
CREATE OR REPLACE FUNCTION fnc_calcular_total_factura (
    p_id_factura IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER(10,2) := 0;
BEGIN
    -- Sumar subtotales del detalle de cobro
    SELECT NVL(SUM(subtotal), 0)
    INTO v_total
    FROM Detalle_Factura
    WHERE id_factura = p_id_factura;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN 0;
END fnc_calcular_total_factura;
/

--procedure
CREATE OR REPLACE PROCEDURE prc_agendar_cita (
    p_id_mascota  IN NUMBER,
    p_id_empleado IN NUMBER,
    p_fecha_hora  IN DATE,
    p_motivo      IN VARCHAR2
) IS
    v_disponible NUMBER;
BEGIN
    -- Validar disponibilidad mediante la función almacenada
    v_disponible := fnc_validar_disponibilidad_vet(p_id_empleado, p_fecha_hora);

    IF v_disponible = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El profesional asignado ya posee una cita agendada para el horario seleccionado.');
    ELSE
        INSERT INTO Citas (id_mascota, id_empleado, fecha_hora, motivo)
        VALUES (p_id_mascota, p_id_empleado, p_fecha_hora, p_motivo);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cita agendada exitosamente para la fecha: ' || TO_CHAR(p_fecha_hora, 'DD/MM/YYYY HH24:MI'));
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END prc_agendar_cita;
/

--segundo procedure

CREATE OR REPLACE PROCEDURE prc_generar_reporte_stock_critico (
    p_limite_stock IN NUMBER DEFAULT 30
) IS
    -- Cursor explícito para obtener fármacos bajo el stock límite
    CURSOR c_stock_bajo IS
        SELECT id_medicamento, nombre, stock, precio
        FROM Medicamentos
        WHERE stock <= p_limite_stock
        ORDER BY stock ASC;

    v_reg c_stock_bajo%ROWTYPE;
    v_contador NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('==================================================');
    DBMS_OUTPUT.PUT_LINE('   REPORTE DE MEDICAMENTOS EN STOCK CRITICO');
    DBMS_OUTPUT.PUT_LINE('   UMBRAL EVALUADO: <= ' || p_limite_stock || ' UNIDADES');
    DBMS_OUTPUT.PUT_LINE('==================================================');

    OPEN c_stock_bajo;
    LOOP
        FETCH c_stock_bajo INTO v_reg;
        EXIT WHEN c_stock_bajo%NOTFOUND;

        v_contador := v_contador + 1;
        DBMS_OUTPUT.PUT_LINE('ID: ' || RPAD(v_reg.id_medicamento, 4) ||
                             ' | Fármaco: ' || RPAD(v_reg.nombre, 30) ||
                             ' | Stock Actual: ' || RPAD(v_reg.stock, 5) ||
                             ' | Precio: $' || v_reg.precio);
    END LOOP;
    CLOSE c_stock_bajo;

    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron medicamentos con stock crítico.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END prc_generar_reporte_stock_critico;
/

--triggers

CREATE OR REPLACE TRIGGER trg_evitar_cita_duplicada
BEFORE INSERT OR UPDATE ON Citas
FOR EACH ROW
DECLARE
    v_existe NUMBER := 0;
BEGIN
    -- Buscar si el empleado ya atiende a esa misma fecha y hora
    SELECT COUNT(*)
    INTO v_existe
    FROM Citas
    WHERE id_empleado = :NEW.id_empleado
      AND fecha_hora = :NEW.fecha_hora
      AND id_cita <> NVL(:NEW.id_cita, -1);

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'VALIDACION EN TRIGGER: El empleado ' || :NEW.id_empleado || 
                                ' ya tiene asignada una cita en la fecha/hora: ' || 
                                TO_CHAR(:NEW.fecha_hora, 'DD/MM/YYYY HH24:MI'));
    END IF;
END trg_evitar_cita_duplicada;
/

CREATE OR REPLACE TRIGGER trg_descontar_stock_med
AFTER INSERT ON Tratamiento_Medicamento
FOR EACH ROW
DECLARE
    v_stock_actual NUMBER;
    v_nombre_med   VARCHAR2(100);
BEGIN
    -- Consultar el stock actual y nombre del medicamento
    SELECT stock, nombre
    INTO v_stock_actual, v_nombre_med
    FROM Medicamentos
    WHERE id_medicamento = :NEW.id_medicamento;

    -- Validar si hay stock suficiente
    IF v_stock_actual < :NEW.cantidad THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOCK INSUFICIENTE: Se requieren ' || :NEW.cantidad || 
                                ' unidades de ' || v_nombre_med || ' pero solo existen ' || v_stock_actual);
    ELSE
        -- Actualizar descuentando el stock
        UPDATE Medicamentos
        SET stock = stock - :NEW.cantidad
        WHERE id_medicamento = :NEW.id_medicamento;
    END IF;
END trg_descontar_stock_med;
/

--PACKAGE

CREATE OR REPLACE PACKAGE pkg_gestion_veterinaria IS

    -- Funciones del módulo
    FUNCTION fnc_validar_disponibilidad_vet (
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE
    ) RETURN NUMBER;

    FUNCTION fnc_calcular_total_factura (
        p_id_factura IN NUMBER
    ) RETURN NUMBER;

    -- Procedimientos del módulo
    PROCEDURE prc_agendar_cita (
        p_id_mascota  IN NUMBER,
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE,
        p_motivo      IN VARCHAR2
    );

    PROCEDURE prc_generar_reporte_stock_critico (
        p_limite_stock IN NUMBER DEFAULT 30
    );

END pkg_gestion_veterinaria;
/
--PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_gestion_veterinaria IS

    ------------------------------------------------------------------
    -- FUNCION 1: Validar disponibilidad de un profesional
    ------------------------------------------------------------------
    FUNCTION fnc_validar_disponibilidad_vet (
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE
    ) RETURN NUMBER IS
        v_conteo NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_conteo
        FROM Citas
        WHERE id_empleado = p_id_empleado
          AND fecha_hora = p_fecha_hora;

        IF v_conteo > 0 THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END fnc_validar_disponibilidad_vet;

    ------------------------------------------------------------------
    -- FUNCION 2: Calcular total acumulado de una factura
    ------------------------------------------------------------------
    FUNCTION fnc_calcular_total_factura (
        p_id_factura IN NUMBER
    ) RETURN NUMBER IS
        v_total NUMBER(10,2) := 0;
    BEGIN
        SELECT NVL(SUM(subtotal), 0)
        INTO v_total
        FROM Detalle_Factura
        WHERE id_factura = p_id_factura;

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END fnc_calcular_total_factura;

    ------------------------------------------------------------------
    -- PROCEDIMIENTO 1: Agendar cita médica con validaciones
    ------------------------------------------------------------------
    PROCEDURE prc_agendar_cita (
        p_id_mascota  IN NUMBER,
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE,
        p_motivo      IN VARCHAR2
    ) IS
        v_disponible NUMBER;
    BEGIN
        v_disponible := fnc_validar_disponibilidad_vet(p_id_empleado, p_fecha_hora);

        IF v_disponible = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'PKG ERROR: El profesional asignado ya posee una cita agendada en ese horario.');
        ELSE
            INSERT INTO Citas (id_mascota, id_empleado, fecha_hora, motivo)
            VALUES (p_id_mascota, p_id_empleado, p_fecha_hora, p_motivo);
            
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('PKG: Cita agendada correctamente para la fecha ' || TO_CHAR(p_fecha_hora, 'DD/MM/YYYY HH24:MI'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END prc_agendar_cita;

    ------------------------------------------------------------------
    -- PROCEDIMIENTO 2: Generar reporte de medicamentos en stock crítico
    ------------------------------------------------------------------
    PROCEDURE prc_generar_reporte_stock_critico (
        p_limite_stock IN NUMBER DEFAULT 30
    ) IS
        CURSOR c_stock_bajo IS
            SELECT id_medicamento, nombre, stock, precio
            FROM Medicamentos
            WHERE stock <= p_limite_stock
            ORDER BY stock ASC;

        v_reg c_stock_bajo%ROWTYPE;
        v_contador NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('==================================================');
        DBMS_OUTPUT.PUT_LINE('   PKG REPORTE DE MEDICAMENTOS EN STOCK CRITICO');
        DBMS_OUTPUT.PUT_LINE('   UMBRAL EVALUADO: <= ' || p_limite_stock || ' UNIDADES');
        DBMS_OUTPUT.PUT_LINE('==================================================');

        OPEN c_stock_bajo;
        LOOP
            FETCH c_stock_bajo INTO v_reg;
            EXIT WHEN c_stock_bajo%NOTFOUND;

            v_contador := v_contador + 1;
            DBMS_OUTPUT.PUT_LINE('ID: ' || RPAD(v_reg.id_medicamento, 4) ||
                                 ' | Fármaco: ' || RPAD(v_reg.nombre, 30) ||
                                 ' | Stock Actual: ' || RPAD(v_reg.stock, 5) ||
                                 ' | Precio: $' || v_reg.precio);
        END LOOP;
        CLOSE c_stock_bajo;

        IF v_contador = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No se encontraron medicamentos con stock crítico.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    END prc_generar_reporte_stock_critico;

END pkg_gestion_veterinaria;
/