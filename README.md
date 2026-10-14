# Guía de Ejecución y Pruebas del Sistema PL/SQL (APOVET)
### **Paso 1: Inicialización de la Base de Datos (DDL y DML)**
Ejecuta el script principal de inicialización (`script_db_apovet.sql`), el cual realiza el borrado de tablas previas (si existen), crea la estructura completa de tablas y efectúa la carga inicial de datos de prueba.

---

### **Paso 2: Compilación de Triggers de Negocio**
Ejecuta el archivo `triggers.sql` para compilar los disparadores encargados del control automático de inventario y validación de citas.

---

### **Paso 3: Compilación del Paquete (Package)**
Ejecuta los archivos del paquete PL/SQL en el siguiente orden:
1. `package.sql` (Especificación del paquete `pkg_gestion_veterinaria`)
2. `bodypackage.sql` (Cuerpo del paquete `pkg_gestion_veterinaria`)

---

## 2. Casos de Prueba (Bloques Anónimos PL/SQL)

A continuación, se presentan los bloques anónimos para verificar el correcto funcionamiento de cada componente:

### **Caso de Prueba 1: Agendar Cita Exitosamente mediante Paquete**
Valida el agendamiento correcto de una cita disponible llamando al procedimiento del paquete.

```sql
BEGIN
    pkg_gestion_veterinaria.prc_agendar_cita(
        p_id_mascota  => 1,
        p_id_empleado => 1,
        p_fecha_hora  => TO_DATE('2026-06-01 10:00', 'YYYY-MM-DD HH24:MI'),
        p_motivo      => 'Chequeo preventivo de rutina'
    );
END;
/
```
Caso de Prueba 2: Validar Rechazo de Cita Duplicada
Al intentar agendar al mismo veterinario en un horario que ya se encuentra ocupado, el procedimiento debe lanzar un error controlado e interrumpe la operación:
```sql
BEGIN
    -- Intentar agendar en un horario que ya está ocupado en la base de datos
    pkg_gestion_veterinaria.prc_agendar_cita(
        p_id_mascota  => 2,
        p_id_empleado => 1,
        p_fecha_hora  => TO_DATE('2026-03-02 09:00', 'YYYY-MM-DD HH24:MI'),
        p_motivo      => 'Consulta duplicada'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Prueba superada. Error capturado: ' || SQLERRM);
END;
/
```
Caso de Prueba 3: Probar Descuento Automático de Stock (Trigger)
Verifica que al registrar la aplicación de un medicamento en un tratamiento, el trigger trg_descontar_stock_med descuente automáticamente las unidades del inventario en la tabla Medicamentos.
```
DECLARE
    v_stock_antes   NUMBER;
    v_stock_despues NUMBER;
BEGIN
    -- Consultar stock inicial del medicamento ID 1 (Amoxicilina)
    SELECT stock 
    INTO v_stock_antes 
    FROM Medicamentos 
    WHERE id_medicamento = 1;

    DBMS_OUTPUT.PUT_LINE('Stock antes de recetar: ' || v_stock_antes);

    -- Asignar medicamento a un tratamiento (recetar 5 unidades)
    INSERT INTO Tratamiento_Medicamento (id_tratamiento, id_medicamento, dosis, cantidad)
    VALUES (1, 1, '1 comprimido cada 12h', 5);

    -- Consultar stock final tras la ejecución del trigger
    SELECT stock 
    INTO v_stock_despues 
    FROM Medicamentos 
    WHERE id_medicamento = 1;

    DBMS_OUTPUT.PUT_LINE('Stock después de recetar: ' || v_stock_despues);
END;
/
```
