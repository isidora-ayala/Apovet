CREATE OR REPLACE TRIGGER trg_evitar_cita_duplicada
BEFORE INSERT OR UPDATE ON Citas
FOR EACH ROW
DECLARE
    v_existe NUMBER := 0;
BEGIN
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
------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_descontar_stock_med
AFTER INSERT ON Tratamiento_Medicamento
FOR EACH ROW
DECLARE
    v_stock_actual NUMBER;
    v_nombre_med   VARCHAR2(100);
BEGIN
    SELECT stock, nombre
    INTO v_stock_actual, v_nombre_med
    FROM Medicamentos
    WHERE id_medicamento = :NEW.id_medicamento;
    IF v_stock_actual < :NEW.cantidad THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOCK INSUFICIENTE: Se requieren ' || :NEW.cantidad || 
                                ' unidades de ' || v_nombre_med || ' pero solo existen ' || v_stock_actual);
    ELSE
        UPDATE Medicamentos
        SET stock = stock - :NEW.cantidad
        WHERE id_medicamento = :NEW.id_medicamento;
    END IF;
END trg_descontar_stock_med;
/
 
--Resultado
SELECT object_name, object_type, status FROM user_objects
WHERE object_type = 'TRIGGER'
  AND object_name IN ('TRG_EVITAR_CITA_DUPLICADA','TRG_DESCONTAR_STOCK_MED');