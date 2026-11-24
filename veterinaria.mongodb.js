//Insertar datos de ejemplo inicial
use('clinica_veterinaria');
db.atenciones.insertMany([
  {
    codigo_cita: "VET-001", fecha_hora: new Date("2026-11-03T09:00:00Z"), estado: "completada",
    motivo: "Control anual y vacunación",
    mascota: { nombre: "Firulais", especie: "perro", raza: "Labrador", edad_anios: 5, peso_kg: 28.5, alergias: ["penicilina"] },
    dueno: { nombre: "María Soto", telefono: "+56911110001", email: "maria.soto@mail.cl", comuna: "Santiago" },
    veterinario: { nombre: "Dr. Andrés Rojas", especialidad: "Medicina General" },
    servicios: [ { nombre: "Consulta general", precio: 25000 }, { nombre: "Vacuna antirrábica", precio: 15000 } ],
    medicamentos: [ { nombre: "Antiparasitario", cantidad: 1, precio_unitario: 8500 } ],
    etiquetas: ["vacunacion", "control"],
    pago: { total: 48500, abonado: 48500, metodo: "tarjeta" }
  },
  {
    codigo_cita: "VET-002", fecha_hora: new Date("2026-11-27T11:30:00Z"), estado: "agendada",
    motivo: "Caída de pelo",
    mascota: { nombre: "Misu", especie: "gato", raza: "Siamés", edad_anios: 3, peso_kg: 4.2, alergias: [] },
    dueno: { nombre: "Carlos Pérez", telefono: "+56911110002", email: "carlos.perez@mail.cl", comuna: "Valparaíso" },
    veterinario: { nombre: "Dra. Camila Fuentes", especialidad: "Dermatología" },
    servicios: [ { nombre: "Consulta de especialidad", precio: 35000 } ],
    medicamentos: [],
    etiquetas: ["dermatologia"],
    pago: { total: 35000, abonado: 0, metodo: "efectivo" }
  },
  {
    codigo_cita: "VET-003", fecha_hora: new Date("2026-11-10T16:00:00Z"), estado: "completada",
    motivo: "Cojera en pata trasera",
    mascota: { nombre: "Rocky", especie: "perro", raza: "Pastor Alemán", edad_anios: 8, peso_kg: 36, alergias: ["pollo", "polen"] },
    dueno: { nombre: "Ana Muñoz", telefono: "+56911110003", email: "ana.munoz@mail.cl", comuna: "Concepción" },
    veterinario: { nombre: "Dr. Andrés Rojas", especialidad: "Medicina General" },
    servicios: [ { nombre: "Consulta general", precio: 25000 }, { nombre: "Radiografía", precio: 30000 } ],
    medicamentos: [ { nombre: "Meloxicam", cantidad: 10, precio_unitario: 1200 } ],
    etiquetas: ["traumatologia", "urgencia"],
    pago: { total: 67000, abonado: 40000, metodo: "transferencia" }
  },
  {
    codigo_cita: "VET-004", fecha_hora: new Date("2026-11-20T10:00:00Z"), estado: "cancelada",
    motivo: "Esterilización",
    mascota: { nombre: "Luna", especie: "gato", raza: "Angora", edad_anios: 2, peso_kg: 3.8, alergias: [] },
    dueno: { nombre: "Pedro Vidal", telefono: "+56911110004", email: "pedro.vidal@mail.cl", comuna: "Santiago" },
    veterinario: { nombre: "Dra. Camila Fuentes", especialidad: "Dermatología" },
    servicios: [ { nombre: "Esterilización felina", precio: 60000 } ],
    medicamentos: [],
    etiquetas: ["cirugia"],
    pago: { total: 60000, abonado: 20000, metodo: "tarjeta" }
  },
  {
    codigo_cita: "VET-005", fecha_hora: new Date("2026-11-12T15:00:00Z"), estado: "completada",
    motivo: "Tos y fatiga",
    mascota: { nombre: "Toby", especie: "perro", raza: "Poodle", edad_anios: 11, peso_kg: 6.1, alergias: ["sulfas"] },
    dueno: { nombre: "Rosa Díaz", telefono: "+56911110005", email: "rosa.diaz@mail.cl", comuna: "Puerto Montt" },
    veterinario: { nombre: "Dr. Matías Silva", especialidad: "Cardiología" },
    servicios: [ { nombre: "Consulta de especialidad", precio: 35000 }, { nombre: "Electrocardiograma", precio: 28000 } ],
    medicamentos: [ { nombre: "Enalapril", cantidad: 30, precio_unitario: 450 } ],
    etiquetas: ["cardiologia", "geriatrico"],
    pago: { total: 76500, abonado: 76500, metodo: "tarjeta" }
  },
  {
    codigo_cita: "VET-006", fecha_hora: new Date("2026-12-01T12:00:00Z"), estado: "agendada",
    motivo: "Revisión de plumaje",
    mascota: { nombre: "Kiwi", especie: "ave", raza: "Cacatúa", edad_anios: 6, peso_kg: 0.35, alergias: [] },
    dueno: { nombre: "Javier Lagos", telefono: "+56911110006", email: "javier.lagos@mail.cl", comuna: "Valparaíso" },
    veterinario: { nombre: "Dra. Valentina Mora", especialidad: "Animales Exóticos" },
    servicios: [ { nombre: "Consulta de exóticos", precio: 30000 } ],
    medicamentos: [],
    etiquetas: ["exoticos"],
    pago: { total: 30000, abonado: 0, metodo: "efectivo" }
  },
  {
    codigo_cita: "VET-007", fecha_hora: new Date("2026-11-15T20:00:00Z"), estado: "completada",
    motivo: "Vómitos y diarrea",
    mascota: { nombre: "Bruno", especie: "perro", raza: "Bulldog", edad_anios: 4, peso_kg: 24, alergias: [] },
    dueno: { nombre: "Camila Reyes", telefono: "+56911110007", email: "camila.reyes@mail.cl", comuna: "Santiago" },
    veterinario: { nombre: "Dr. Andrés Rojas", especialidad: "Medicina General" },
    servicios: [ { nombre: "Consulta general", precio: 25000 }, { nombre: "Suero subcutáneo", precio: 12000 } ],
    medicamentos: [ { nombre: "Metronidazol", cantidad: 14, precio_unitario: 600 }, { nombre: "Probiótico", cantidad: 1, precio_unitario: 9500 } ],
    etiquetas: ["gastro", "urgencia"],
    pago: { total: 54900, abonado: 54900, metodo: "efectivo" }
  },
  {
    codigo_cita: "VET-008", fecha_hora: new Date("2026-11-01T08:00:00Z"), estado: "prueba",
    motivo: "Registro de prueba",
    mascota: { nombre: "Mascota Prueba", especie: "perro", raza: "Mestizo", edad_anios: 1, peso_kg: 10, alergias: [] },
    dueno: { nombre: "Usuario Prueba", telefono: "+56900000000", email: "prueba@mail.cl", comuna: "Santiago" },
    veterinario: { nombre: "Dra. Camila Fuentes", especialidad: "Dermatología" },
    servicios: [],
    medicamentos: [],
    etiquetas: ["prueba"],
    pago: { total: 0, abonado: 0, metodo: "ninguno" }
  },
  {
    codigo_cita: "VET-009", fecha_hora: new Date("2026-11-30T09:30:00Z"), estado: "agendada",
    motivo: "Primera vacuna triple felina",
    mascota: { nombre: "Nala", especie: "gato", raza: "Mestiza", edad_anios: 1, peso_kg: 3.1, alergias: ["lactosa"] },
    dueno: { nombre: "Fernanda Cortés", telefono: "+56911110009", email: "fernanda.cortes@mail.cl", comuna: "Concepción" },
    veterinario: { nombre: "Dr. Andrés Rojas", especialidad: "Medicina General" },
    servicios: [ { nombre: "Consulta general", precio: 25000 }, { nombre: "Vacuna triple felina", precio: 18000 } ],
    medicamentos: [],
    etiquetas: ["vacunacion", "cachorro"],
    pago: { total: 43000, abonado: 10000, metodo: "transferencia" }
  },
  {
    codigo_cita: "VET-010", fecha_hora: new Date("2026-11-18T14:00:00Z"), estado: "completada",
    motivo: "Control cardiológico",
    mascota: { nombre: "Zeus", especie: "perro", raza: "Golden Retriever", edad_anios: 6, peso_kg: 32, alergias: ["penicilina"] },
    dueno: { nombre: "Luis Herrera", telefono: "+56911110010", email: "luis.herrera@mail.cl", comuna: "Puerto Montt" },
    veterinario: { nombre: "Dr. Matías Silva", especialidad: "Cardiología" },
    servicios: [ { nombre: "Consulta de especialidad", precio: 35000 } ],
    medicamentos: [ { nombre: "Enalapril", cantidad: 30, precio_unitario: 450 } ],
    etiquetas: ["cardiologia", "control"],
    pago: { total: 48500, abonado: 48500, metodo: "tarjeta" }
  }
]);
//Consultar los datos insertados
db.atenciones.find();
db.atenciones.countDocuments();   // debería dar 11
//Filtra por la especie de mascota 
db.atenciones.find({ "mascota.especie": "perro" });

//Filtra por edad de mascota mayor o igual a 8 años
db.atenciones.find({ "mascota.edad_anios": { $gte: 8 } });

//atenciones con pago total entre 40000 y 70000
db.atenciones.find({ "pago.total": { $gte: 40000, $lte: 70000 } });

//debe contener gato o ave
db.atenciones.find({ "mascota.especie": { $in: ["gato", "ave"] } });

//atencion que sea cardiologia y contrl
db.atenciones.find({ etiquetas: { $all: ["cardiologia", "control"] } });

//atenciones que NO son ni cancelada ni de prueba
db.atenciones.find({ estado: { $nin: ["cancelada", "prueba"] } });

//mascotas alergicas a penicilina
db.atenciones.find({ "mascota.alergias": "penicilina" });

// Urgencias O con total mayor a $60.000
db.atenciones.find({
  $or: [ { etiquetas: "urgencia" }, { "pago.total": { $gt: 60000 } } ]
});
//Mostar solo ciertos campos y ocultar el _id
db.atenciones.find(
  { estado: "completada" },
  { _id: 0, codigo_cita: 1, "mascota.nombre": 1, "veterinario.nombre": 1, "pago.total": 1 }
);

//Buscas las 3 atenciones mas caras
db.atenciones
  .find({}, { _id: 0, codigo_cita: 1, "mascota.nombre": 1, "pago.total": 1 })
  .sort({ "pago.total": -1 })   // -1 = descendente, 1 = ascendente
  .limit(3);

//uso de distinct para obtener valores únicos de un campo
db.atenciones.distinct("mascota.especie");        // especies atendidas
db.atenciones.distinct("veterinario.nombre");     // veterinarios que atienden
db.atenciones.distinct("dueno.comuna");           // comunas de los clientes


//cambiar un estado por ejemplo la cita 2 se completo
db.atenciones.updateOne(
  { codigo_cita: "VET-002" },
  { $set: { estado: "completada" } }
);

// $inc para poder agregar un nuevo abono por ejemplo rocky pago el saldo pendiente de 27000
db.atenciones.updateOne(
  { codigo_cita: "VET-003" },
  { $inc: { "pago.abonado": 27000 } }
);
//si un abono fue mal realizado hacer asi 
db.atenciones.updateOne(
  { codigo_cita: "VET-009" },
  { $inc: { "pago.abonado": -5000 } }
);

// Marcar recordatorio enviado a todas las vacunaciones agendadas (en caso de tener como mandar recordatorio)
db.atenciones.updateMany(
  { estado: "agendada", etiquetas: "vacunacion" },
  { $set: { recordatorio_enviado: true } }
);
// Quitar el campo recordatorio_enviado
db.atenciones.updateMany(
  { recordatorio_enviado: true },
  { $unset: { recordatorio_enviado: "" } }
);
//borra dsolo el registro de prueba
db.atenciones.deleteOne({ codigo_cita: "VET-008" });