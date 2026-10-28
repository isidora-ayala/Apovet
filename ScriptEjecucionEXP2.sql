SET SERVEROUTPUT ON SIZE UNLIMITED;

-- PRUEBA 1: FUNCION fnc_calcular_total_factura
SELECT id_factura, total, fnc_calcular_total_factura(id_factura) AS total_calculado
FROM Facturas
ORDER BY id_factura;
---------------------------------------------------------
-- PRUEBA 2: FUNCION fnc_validar_disponibilidad_vet
SELECT fnc_validar_disponibilidad_vet(1, TO_DATE('2026-03-02 09:00','YYYY-MM-DD HH24:MI')) AS ocupado,
       fnc_validar_disponibilidad_vet(1, TO_DATE('2026-11-02 10:00','YYYY-MM-DD HH24:MI')) AS libre
FROM dual;
---------------------------------------------------------
-- PRUEBA 3A: PROCEDIMIENTO prc_agendar_cita
BEGIN
    prc_agendar_cita(1, 1, TO_DATE('2026-10-30 10:00','YYYY-MM-DD HH24:MI'), 'Control de prueba');
END;
/
SELECT * FROM Citas WHERE motivo = 'Control de prueba';
-- Borrar la cita creada prueba 3A
DELETE FROM Citas WHERE motivo = 'Control de prueba';
COMMIT;
---------------------------------------------------------
-- PRUEBA 3B: PROCEDIMIENTO prc_agendar_cita (horario OCUPADO)
---------------------------------------------------------
BEGIN
    prc_agendar_cita(2, 1, TO_DATE('2026-03-02 09:00','YYYY-MM-DD HH24:MI'), 'Hora ocupada');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);   -- muestra el error en pantalla
END;
/
---------------------------------------------------------
-- PRUEBA 4A: PROCEDIMIENTO prc_generar_reporte_stock_critico
BEGIN
    prc_generar_reporte_stock_critico;
END;
/
---------------------------------------------------------
-- PRUEBA 4B: PROCEDIMIENTO prc_generar_reporte_stock_critico con parametro
BEGIN
    prc_generar_reporte_stock_critico(22);
END;
/


