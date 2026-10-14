CREATE OR REPLACE PACKAGE pkg_gestion_veterinaria IS
  FUNCTION fnc_validar_disponibilidad_vet (
    p_id_empleado IN Citas.id_empleado%TYPE,
    p_fecha_hora IN Citas.fecha_hora%TYPE
  ) RETURN NUMBER;
  FUNCTION fnc_calcular_total_factura (
    p_id_factura IN Facturas.id_factura%TYPE
  ) RETURN NUMBER;
  PROCEDURE prc_agendar_cita (
    p_id_mascota IN Citas.id_mascota%TYPE,
    p_id_empleado IN Citas.id_empleado%TYPE,
    p_fecha_hora IN Citas.fecha_hora%TYPE,
    p_motivo   IN Citas.motivo%TYPE
  );
  PROCEDURE prc_generar_reporte_stock_critico (
    p_limite_stock IN Medicamentos.stock%TYPE DEFAULT 30
  );

END pkg_gestion_veterinaria;

/