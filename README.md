# Review: Clinica Universitaria

##### Paula Andrea Viviescas Jaimes

El presente proyecto tiene como objetivo aplicar el proceso de normalización de bases de datos hasta la **Cuarta Forma Normal (4FN)** tomando como base un archivo Excel suministrado por el docente, el cual contiene información correspondiente a una clínica universitaria. Como resultado final se debe obtener:

- Modelo de datos normalizado hasta 4FN.
- Modelo físico de la base de datos con todas sus relaciones.
- Definición de tipos de datos y restricciones de integridad.
- Procedimientos almacenados para operaciones CRUD de cada entidad.
- Funciones y procedimientos adicionales que permitan:
-  Obtener el número de doctores dada una especialidad.
-  Calcular el total de pacientes atendidos por un médico.
-  Obtener la cantidad de pacientes atendidos en una sede específica.
- Manejo de errores mediante procedimientos o funciones que registren: Nombre de la tabla, Código de error, Mensaje descriptivo, Fecha y hora del evento

### Parte 1: Normalización

A continuación se describe el proceso de normalización aplicado a la información proporcionada. Se adjunta el archivo Excel donde se evidencia paso a paso la transformación de los datos.

#### Forma Normal 1

La **Primera Forma Normal** establece que todos los atributos deben contener valores atómicos, es decir, cada campo debe almacenar un único valor y no deben existir grupos repetitivos ni campos multivaluados. Para cumplir con esta forma normal se realizaron las siguientes acciones:

\- Se separaron los campos **nombre** y **apellido** del paciente para garantizar la atomicidad de los datos.

\- Se eliminaron campos multivalorados relacionados con medicamentos recetados.

\- Se reorganizó la información de medicamentos y dosis en registros independientes, evitando listas dentro de una misma celda.

Con esto se garantizó que cada fila representara una única instancia de información y cada atributo contuviera un solo valor.

#### Forma Normal 2

La **Segunda Forma Normal** requiere que todos los atributos no clave dependan completamente de la clave primaria, eliminando dependencias parciales. Durante esta etapa:

\- Se separaron las entidades principales según sus dependencias funcionales, dando origen a las tablas:

 \- Pacientes

 \- Médicos

 \- Citas

 \- Recetas

\- Se identificó que la **dosis** de un medicamento no depende únicamente del medicamento ni únicamente de la cita, sino de la combinación de ambos.

Por esta razón se creó la tabla **Recetas**, cuya clave relaciona la cita con el medicamento, garantizando la dependencia total respecto a la clave primaria compuesta.

#### Forma Normal 3

La **Tercera Forma Normal** elimina dependencias transitivas, es decir, atributos que no dependen directamente de la clave primaria sino de otros atributos no clave.Para cumplir esta forma normal se realizaron los siguientes cambios:

\- Se crearon tablas catálogo:

 \- **Especialidades**

 \- **Medicamentos**

 (Esto permite evitar redundancia, mantener uniformidad en los datos y facilitar futuras ampliaciones del sistema.)

\- Se separó la información de **Facultad** y **Decano** de la tabla Médicos, ya que el decano depende de la facultad y no del médico directamente.

\- Se creó la tabla **Hospitales**, debido a que la dirección depende de la sede hospitalaria y no del identificador de la cita.

 Por lo tanto:

 \- La sede hospitalaria se almacena en la tabla Hospitales.

 \- La tabla Citas contiene una llave foránea hacia Hospitales.

Con estas modificaciones se eliminaron las dependencias transitivas presentes en el modelo inicial.

#### Forma Normal 4

La **Cuarta Forma Normal** busca eliminar dependencias multivaluadas independientes y relaciones muchos a muchos innecesarias. Inicialmente se había planteado la entidad **Medico_Paciente**, considerando que:

\- Un médico puede atender múltiples pacientes.

\- Un paciente puede ser atendido por múltiples médicos.

Sin embargo, se identificó que esta relación ya estaba representada naturalmente mediante la entidad **Citas**, la cual describe el evento de atención médica. Además, se observó que mantener el identificador de cita dentro de la tabla Pacientes generaba repetición de registros debido a que un paciente puede tener múltiples citas. La solución consistió en:

\- Incorporar las llaves foráneas **id_medico** e **id_paciente** dentro de la tabla **Citas**.

\- Eliminar tablas intermedias innecesarias.

\- Centralizar la relación médico–paciente a través de la entidad Citas.

De esta manera se eliminaron redundancias y dependencias multivaluadas, alcanzando la **Cuarta Forma Normal (4FN)**.

### Modelo Relacional y Físico

<a href="https://ibb.co/1GH6wM50"><img src="https://i.ibb.co/YBvZqXMN/Modelo-relacional-final.png" alt="Modelo-relacional-final" border="0"></a>



Para la representación gráfica del modelo relacional normalizado se utilizó la herramienta **MySQL Workbench**, la cual permitió diseñar visualmente las entidades, sus atributos y las relaciones definidas durante el proceso de normalización. Una vez validado el modelo relacional, se empleó la funcionalidad **Forward Engineering** de MySQL Workbench para generar automáticamente el **modelo físico** de la base de datos. Este proceso permitió:



\- Crear las tablas correspondientes al modelo normalizado.

\- Definir llaves primarias y llaves foráneas.

\- Establecer restricciones de integridad referencial.

\- Asignar tipos de datos adecuados a cada atributo.

\- Generar el script SQL completo de creación de la base de datos.



Como resultado, se adjunta el archivo `.sql` que contiene el modelo físico generado, el cual permite recrear la estructura completa de la base de datos en cualquier instancia de MySQL compatible.

### **Parte 2: Procedimientos Almacenados (CRUD y Manejo de Errores)**

Con el objetivo de garantizar la integridad, reutilización y seguridad en la manipulación de los datos del sistema de la clínica universitaria, se implementaron **procedimientos almacenados (Stored Procedures)** para realizar las operaciones CRUD (Create, Read, Update y Delete) sobre cada una de las entidades del modelo relacional normalizado.

El uso de procedimientos almacenados permite:

- Centralizar la lógica de acceso a datos.
- Evitar manipulaciones directas sobre las tablas.
- Controlar errores de ejecución.
- Mantener consistencia en las operaciones del sistema.
- Facilitar la reutilización desde aplicaciones externas.

Cada entidad del sistema cuenta con su propio conjunto de procedimientos CRUD.

### **Estructura General de los Procedimientos**

Para mantener uniformidad en todo el sistema, todos los procedimientos siguen la misma estructura lógica:

1. **Recepción de parámetros de entrada**
2. **Declaración de variables para manejo de errores**
3. **Definición de manejador de excepciones (****EXIT HANDLER****)**
4. **Ejecución de la operación SQL**
5. **Mensaje de confirmación o error**

### **Operaciones Implementadas**

Para cada tabla se crearon cuatro procedimientos:

| **Operación** | **Procedimiento** | **Descripción**                 |
| ------------- | ----------------- | ------------------------------- |
| CREATE        | sp_tabla_create   | Inserta un nuevo registro       |
| READ          | sp_tabla_read     | Consulta un registro por ID     |
| UPDATE        | sp_tabla_update   | Actualiza un registro existente |
| DELETE        | sp_tabla_delete   | Elimina un registro             |

### **Tablas con CRUD Implementado**

Se desarrollaron procedimientos almacenados para las siguientes entidades:

- Pacientes
- Facultades
- Hospitales
- Médicos
- Especialidades
- Medicamentos
- Citas
- Recetas

Cada conjunto de procedimientos permite administrar completamente la información asociada a la clínica universitaria.

### **Manejo de Errores**

Siguiendo las indicaciones del proyecto, todos los procedimientos incluyen un sistema de captura de errores utilizando:

```
DECLARE EXIT HANDLER FOR SQLEXCEPTION
```

Cuando ocurre un error durante la ejecución:

1. Se captura el código SQLSTATE y el mensaje del sistema.
2. El error se registra automáticamente en la tabla log_errores.
3. Se devuelve un mensaje controlado al usuario.

### **Tabla de Registro de Errores**

Los errores se almacenan con la siguiente información:

| **Campo**     | **Descripción**              |
| ------------- | ---------------------------- |
| nombre_tabla  | Tabla donde ocurrió el error |
| codigo_error  | Código SQL del error         |
| mensaje_error | Descripción del error        |
| fecha_hora    | Momento del evento           |

Esto permite llevar trazabilidad y auditoría de fallos del sistema.

### **Ejemplo de Flujo de Manejo de Error**

Si se intenta:

- insertar un registro duplicado,
- eliminar un registro con dependencias (FK),
- o violar una restricción,

el sistema:

1. Cancela la operación.
2. Guarda el error en log_errores.
3. Retorna un mensaje informativo sin detener la ejecución del servidor.

### **Beneficios del Enfoque Implementado**

La implementación realizada aporta:

✅ Encapsulamiento de la lógica de datos

✅ Control centralizado de errores

✅ Integridad referencial protegida

✅ Código reutilizable

✅ Estandarización de operaciones CRUD

✅ Preparación para integración con aplicaciones externas

### **Convención de Nombres**

Se utilizó una nomenclatura estándar:

```
sp_<tabla>_<operacion>
```

Ejemplos:

- sp_pacientes_create
- sp_medicos_update
- sp_citas_delete

Esto facilita mantenimiento y escalabilidad del sistema.

### **Conclusión**

La implementación de procedimientos almacenados junto con el manejo estructurado de errores permite que el modelo físico desarrollado cumpla buenas prácticas de diseño de bases de datos, garantizando confiabilidad, control y organización en la gestión de la información de la clínica universitaria.

Todos los procedimientos fueron probados mediante ejecuciones controladas desde MySQL Workbench, verificando inserciones correctas, actualizaciones, eliminaciones y registro adecuado de errores en la tabla de auditoría.

