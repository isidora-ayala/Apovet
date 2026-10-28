CREATE OR REPLACE PACKAGE pkg_gestion_veterinaria IS
    FUNCTION fnc_validar_disponibilidad_vet (
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE
    ) RETURN NUMBER;
    FUNCTION fnc_calcular_total_factura (
        p_id_factura IN NUMBER
    ) RETURN NUMBER;
    PROCEDURE prc_agendar_cita (
        p_id_mascota  IN NUMBER,
        p_id_empleado IN NUMBER,
        p_fecha_hora  IN DATE,
        p_motivo      IN VARCHAR2);
    PROCEDURE prc_generar_reporte_stock_critico (
        p_limite_stock IN NUMBER DEFAULT 30);
END pkg_gestion_veterinaria;
/
SELECT object_name, object_type, status FROM user_objects
WHERE object_name = 'PKG_GESTION_VETERINARIA';
 
 -----------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkg_gestion_veterinaria IS
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
                                 ' | Farmaco: ' || RPAD(v_reg.nombre, 30) ||
                                 ' | Stock Actual: ' || RPAD(v_reg.stock, 5) ||
                                 ' | Precio: $' || v_reg.precio);
        END LOOP;
        CLOSE c_stock_bajo;
        IF v_contador = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No se encontraron medicamentos con stock critico.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    END prc_generar_reporte_stock_critico;
END pkg_gestion_veterinaria;
/
SELECT object_name, object_type, status FROM user_objects
WHERE object_name = 'PKG_GESTION_VETERINARIA';