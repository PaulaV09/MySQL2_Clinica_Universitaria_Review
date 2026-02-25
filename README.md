# Review: Clinica Universitaria

##### Paula Andrea Viviescas Jaimes

Este repositorio contiene el diseño e implementación de la base de datos para un **sistema de gestión clínica**, desarrollado con el objetivo de simular un entorno real de administración hospitalaria mediante el uso de buenas prácticas de modelado, seguridad y optimización en MySQL.

El proyecto integra diferentes componentes propios de sistemas empresariales, incluyendo control de usuarios y permisos, procedimientos almacenados, mecanismos de protección contra inyección SQL, triggers de validación, automatización mediante eventos programados, vistas para análisis de información y estrategias de particionamiento orientadas al rendimiento y la escalabilidad.

La arquitectura fue diseñada considerando escenarios reales de una clínica, donde interactúan múltiples roles (administración, médicos, recepción, farmacia y dirección), garantizando la **integridad de los datos**, la **seguridad del acceso**, la **automatización de procesos** y la **eficiencia en consultas sobre grandes volúmenes de información**.

Este README documenta las decisiones técnicas adoptadas, las justificaciones de diseño y las soluciones implementadas para construir una base de datos robusta, segura y escalable, alineada con prácticas utilizadas en sistemas clínicos reales.

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

#### Modelo Relacional y Físico

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

#### **Estructura General de los Procedimientos**

Para mantener uniformidad en todo el sistema, todos los procedimientos siguen la misma estructura lógica:

1. **Recepción de parámetros de entrada**
2. **Declaración de variables para manejo de errores**
3. **Definición de manejador de excepciones (****EXIT HANDLER****)**
4. **Ejecución de la operación SQL**
5. **Mensaje de confirmación o error**

#### **Operaciones Implementadas**

Para cada tabla se crearon cuatro procedimientos:

| **Operación** | **Procedimiento** | **Descripción**                 |
| ------------- | ----------------- | ------------------------------- |
| CREATE        | sp_tabla_create   | Inserta un nuevo registro       |
| READ          | sp_tabla_read     | Consulta un registro por ID     |
| UPDATE        | sp_tabla_update   | Actualiza un registro existente |
| DELETE        | sp_tabla_delete   | Elimina un registro             |

#### **Tablas con CRUD Implementado**

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

#### **Manejo de Errores**

Siguiendo las indicaciones del proyecto, todos los procedimientos incluyen un sistema de captura de errores utilizando:

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
```

Cuando ocurre un error durante la ejecución:

1. Se captura el código SQLSTATE y el mensaje del sistema.
2. El error se registra automáticamente en la tabla log_errores.
3. Se devuelve un mensaje controlado al usuario.

#### **Tabla de Registro de Errores**

Los errores se almacenan con la siguiente información:

| **Campo**     | **Descripción**              |
| ------------- | ---------------------------- |
| nombre_tabla  | Tabla donde ocurrió el error |
| codigo_error  | Código SQL del error         |
| mensaje_error | Descripción del error        |
| fecha_hora    | Momento del evento           |

Esto permite llevar trazabilidad y auditoría de fallos del sistema.

#### **Ejemplo de Flujo de Manejo de Error**

Si se intenta:

- insertar un registro duplicado,
- eliminar un registro con dependencias (FK),
- o violar una restricción,

el sistema:

1. Cancela la operación.
2. Guarda el error en log_errores.
3. Retorna un mensaje informativo sin detener la ejecución del servidor.

#### **Beneficios del Enfoque Implementado**

La implementación realizada aporta:

✅ Encapsulamiento de la lógica de datos

✅ Control centralizado de errores

✅ Integridad referencial protegida

✅ Código reutilizable

✅ Estandarización de operaciones CRUD

✅ Preparación para integración con aplicaciones externas

#### **Convención de Nombres**

Se utilizó una nomenclatura estándar:

```sql
sp_<tabla>_<operacion>
```

Ejemplos:

- sp_pacientes_create
- sp_medicos_update
- sp_citas_delete

Esto facilita mantenimiento y escalabilidad del sistema.

#### **Conclusión**

La implementación de procedimientos almacenados junto con el manejo estructurado de errores permite que el modelo físico desarrollado cumpla buenas prácticas de diseño de bases de datos, garantizando confiabilidad, control y organización en la gestión de la información de la clínica universitaria.

Todos los procedimientos fueron probados mediante ejecuciones controladas desde MySQL Workbench, verificando inserciones correctas, actualizaciones, eliminaciones y registro adecuado de errores en la tabla de auditoría.

### **Parte 3: Funciones Implementadas**

Como parte final del desarrollo del sistema de base de datos de la clínica universitaria, se implementaron **funciones almacenadas (Stored Functions)** en MySQL con el objetivo de obtener información estadística relevante a partir de los datos registrados. Estas funciones permiten realizar cálculos automáticos directamente desde la base de datos, evitando consultas complejas repetitivas y garantizando reutilización de la lógica.

Cada función:

- Recibe parámetros de entrada.
- Realiza cálculos sobre las tablas normalizadas.
- Retorna un valor numérico como resultado.
- Implementa manejo de errores.
- Registra fallos en la tabla log_errores.

#### **Manejo de Errores en Funciones**

Todas las funciones incluyen un manejador de excepciones mediante:

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
```

Cuando ocurre un error:

1. Se captura el código y mensaje del sistema.
2. Se registra el evento en la tabla log_errores.
3. La función retorna el valor **-1** indicando fallo controlado.

Esto permite mantener trazabilidad y auditoría del sistema.

### **Funciones Desarrolladas**

#### **1️⃣ Número de doctores dada una especialidad**

**Nombre:** fn_doctores_por_especialidad

**Descripción:** Retorna la cantidad total de médicos asociados a una especialidad específica.

**Tabla utilizada:** medicos

**Parámetro de entrada:**

| **Parámetro**  | **Tipo**   | **Descripción**                  |
| -------------- | ---------- | -------------------------------- |
| idespecialidad | VARCHAR(6) | Identificador de la especialidad |

**Valor retornado:**

- Número total de médicos pertenecientes a la especialidad.
- Retorna **-1** en caso de error.

**Lógica aplicada:**

Se realiza un conteo (COUNT) de los médicos cuyo idespecialidad coincida con el parámetro recibido.

**Ejemplo de uso:**

```sql
SELECT fn_doctores_por_especialidad('E01');
```

#### **2️⃣ Total de pacientes atendidos por un médico**

**Nombre:** fn_pacientes_por_medico

**Descripción:** Calcula la cantidad de pacientes únicos atendidos por un médico determinado.

**Tabla utilizada:** citas

**Parámetro de entrada:**

| **Parámetro** | **Tipo**   | **Descripción**          |
| ------------- | ---------- | ------------------------ |
| idmedico      | VARCHAR(6) | Identificador del médico |

**Valor retornado:**

- Cantidad de pacientes distintos atendidos.
- Retorna **-1** si ocurre un error.

**Lógica aplicada:**

Se utiliza:

```sql
COUNT(DISTINCT idpaciente)
```

para evitar contar varias veces al mismo paciente cuando posee múltiples citas.

**Ejemplo de uso:**

```sql
SELECT fn_pacientes_por_medico('M-10');
```

#### **3️⃣ Cantidad de pacientes atendidos dada una sede**

**Nombre:** fn_pacientes_por_sede

**Descripción:** Retorna la cantidad de pacientes únicos atendidos en una sede hospitalaria específica.

**Tabla utilizada:** citas

**Parámetro de entrada:**

| **Parámetro** | **Tipo**   | **Descripción**                   |
| ------------- | ---------- | --------------------------------- |
| idhospital    | VARCHAR(6) | Identificador del hospital o sede |

**Valor retornado:**

- Número de pacientes distintos atendidos en la sede.
- Retorna **-1** en caso de error.

**Lógica aplicada:**

Se cuentan pacientes únicos asociados a citas realizadas en un hospital determinado mediante:

```sql
COUNT(DISTINCT idpaciente)
```

**Ejemplo de uso:**

```sql
SELECT fn_pacientes_por_sede('HS01');
```

#### **Beneficios de las Funciones Implementadas**

La implementación de funciones almacenadas permite:

✅ Consultas estadísticas reutilizables

✅ Reducción de complejidad en consultas externas

✅ Encapsulamiento de lógica de negocio

✅ Mejor rendimiento en consultas frecuentes

✅ Control centralizado de errores

✅ Auditoría mediante registro en log_errores

#### **Conclusión**

Las funciones desarrolladas complementan el modelo normalizado y los procedimientos CRUD implementados, proporcionando herramientas de análisis directamente desde la base de datos. Esto permite obtener métricas relevantes sobre médicos, pacientes y sedes hospitalarias de forma eficiente y controlada, cumpliendo completamente con los requerimientos planteados en la actividad.

### 🔐 Gestión de Usuarios y Control de Acceso

Con el fin de garantizar la seguridad y correcta administración de la información dentro del sistema de la clínica universitaria, se implementó un esquema de control de acceso basado en usuarios y privilegios propios de MySQL.

Para ello se utilizaron las instrucciones:

- `CREATE USER` → creación de usuarios del sistema.
- `REVOKE` → eliminación de privilegios por defecto.
- `GRANT` → asignación controlada de permisos específicos.

El diseño de permisos se realizó aplicando el **principio de menor privilegio**, el cual establece que cada usuario debe poseer únicamente los permisos estrictamente necesarios para cumplir sus funciones dentro del sistema, reduciendo riesgos de modificación indebida, pérdida de información o accesos no autorizados.

#### 🧠 Principios aplicados

Durante la definición de permisos se tuvieron en cuenta los siguientes criterios:

- **Separación de responsabilidades:** cada tipo de usuario representa un rol funcional dentro de la clínica.
- **Integridad de datos:** evitar eliminaciones o modificaciones accidentales.
- **Seguridad operativa:** restringir accesos directos innecesarios a tablas críticas.
- **Escalabilidad:** permitir que el sistema pueda crecer manteniendo control de accesos claro.
- **Auditoría:** garantizar acceso controlado a registros de errores.

## 👥 Usuarios del sistema y justificación de permisos

#### 🧠 Administrador (`admin_clinica`)

El usuario administrador posee control total sobre la base de datos, ya que es responsable del mantenimiento, configuración y gestión general del sistema.

**Permisos otorgados:**
- `ALL PRIVILEGES` sobre toda la base de datos.

**Justificación:**
Este usuario debe poder crear estructuras, modificar tablas, gestionar usuarios y solucionar incidencias técnicas del sistema.

#### 🧾 Recepción (`recepcion`)

Representa al personal encargado del registro y gestión administrativa de pacientes y citas médicas.

**Permisos otorgados:**
- `SELECT`, `INSERT`, `UPDATE` sobre `pacientes` y `citas`.
- `SELECT` sobre `medicos` y `hospitales`.

**Justificación:**
El personal de recepción necesita registrar pacientes y programar citas, pero **no debe eliminar información**, ya que esto podría causar pérdida histórica de registros clínicos.

#### 👨‍⚕️ Médico (`medico_user`)

Corresponde a los profesionales de salud que atienden consultas médicas.

**Permisos otorgados:**
- `SELECT` sobre `pacientes`.
- `SELECT`, `UPDATE` sobre `citas`.
- `SELECT` sobre `medicamentos`.
- `SELECT`, `INSERT` sobre `recetas`.

**Justificación:**
El médico debe consultar información del paciente y registrar diagnósticos o tratamientos, pero no modificar datos administrativos ni eliminar registros clínicos.

#### 💊 Farmacia (`farmacia_user`)

Usuario encargado de la gestión de medicamentos y verificación de recetas.

**Permisos otorgados:**
- `SELECT` sobre `recetas`.
- `SELECT`, `INSERT`, `UPDATE` sobre `medicamentos`.

**Justificación:**
La farmacia requiere consultar las recetas emitidas y mantener actualizado el catálogo de medicamentos disponibles, sin acceso a información clínica completa.

#### 📊 Dirección (`direccion_user`)

Usuario destinado a análisis y toma de decisiones administrativas.

**Permisos otorgados:**
- `SELECT` sobre toda la base de datos.

**Justificación:**
La dirección únicamente necesita consultar información estadística y operativa, sin capacidad de modificar datos del sistema.

#### 🔎 Auditor (`auditor_user`)

Encargado del seguimiento de errores y control del sistema.

**Permisos otorgados:**
- `SELECT` sobre `log_errores`.

**Justificación:**
Permite revisar fallos registrados sin riesgo de alterar evidencia o modificar información del sistema.

#### 🤖 Aplicación (`app_backend`)

Usuario utilizado por la aplicación backend.

**Permisos otorgados:**
- `EXECUTE` sobre procedimientos y funciones almacenadas.

**Justificación:**
La aplicación interactúa únicamente mediante procedimientos almacenados, evitando acceso directo a las tablas y aumentando la seguridad del sistema.

### 📊 Tabla resumen de permisos

| Usuario        | Pacientes              | Citas                  | Médicos | Hospitales | Medicamentos           | Recetas        | Logs   | Procedimientos |
| -------------- | ---------------------- | ---------------------- | ------- | ---------- | ---------------------- | -------------- | ------ | -------------- |
| admin_clinica  | ALL                    | ALL                    | ALL     | ALL        | ALL                    | ALL            | ALL    | ALL            |
| recepcion      | SELECT, INSERT, UPDATE | SELECT, INSERT, UPDATE | SELECT  | SELECT     | ❌                      | ❌              | ❌      | ❌              |
| medico_user    | SELECT                 | SELECT, UPDATE         | ❌       | ❌          | SELECT                 | SELECT, INSERT | ❌      | ❌              |
| farmacia_user  | ❌                      | ❌                      | ❌       | ❌          | SELECT, INSERT, UPDATE | SELECT         | ❌      | ❌              |
| direccion_user | SELECT                 | SELECT                 | SELECT  | SELECT     | SELECT                 | SELECT         | SELECT | ❌              |
| auditor_user   | ❌                      | ❌                      | ❌       | ❌          | ❌                      | ❌              | SELECT | ❌              |
| app_backend    | ❌                      | ❌                      | ❌       | ❌          | ❌                      | ❌              | ❌      | EXECUTE        |

---

#### ✅ Resultado

La implementación de usuarios y permisos permite:

- Proteger la integridad de la información clínica.
- Evitar modificaciones accidentales.
- Controlar accesos según responsabilidades reales.
- Mejorar la seguridad general del sistema.
- Simular un entorno real de gestión hospitalaria.

Perfecto 👍 — ya revisé tu base de datos completa y te doy primero el **veredicto técnico** (esto es importante para tu README y para que el profe vea criterio profesional), y luego te entrego la **documentación en Markdown lista para pegar**.

### 🔐 Protección contra Inyección SQL

#### 📌 Objetivo

Se implementaron mecanismos de protección contra ataques de **SQL Injection** mediante el uso de procedimientos almacenados y consultas parametrizadas, con el fin de garantizar la integridad y seguridad de la información del sistema clínico.

La inyección SQL ocurre cuando datos ingresados por el usuario son interpretados como código SQL ejecutable. Para evitar esto, todas las operaciones críticas del sistema fueron encapsuladas dentro de *Stored Procedures*.

#### 🧠 Estrategia de Seguridad Implementada

El sistema evita la ejecución directa de consultas SQL desde el cliente.  
Todas las operaciones CRUD se realizan únicamente mediante procedimientos almacenados.

Las principales medidas aplicadas fueron:

- Uso de **Prepared Statements**.
- Parámetros tipados dentro de procedimientos almacenados.
- Eliminación de concatenación dinámica de strings SQL.
- Validación de existencia de registros antes de operaciones UPDATE y DELETE.
- Manejo centralizado de errores mediante `log_errores`.
- Uso de transacciones (`START TRANSACTION`, `COMMIT`, `ROLLBACK`).

---

#### ⚙️ Uso de Prepared Statements

En operaciones críticas se utilizaron consultas parametrizadas:

```sql
SET @sql = '
    INSERT INTO citas
    (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital)
    VALUES (?, ?, ?, ?, ?, ?)
';

PREPARE stmt FROM @sql;
EXECUTE stmt USING @id, @fecha, @diag, @idmed, @idpac, @idhos;
DEALLOCATE PREPARE stmt;
```

Los símbolos ? actúan como placeholders, evitando que los valores ingresados sean interpretados como instrucciones SQL. Esto impide ataques como:

```sql
' OR '1'='1
```

ya que el motor de base de datos trata el contenido únicamente como un valor.

#### **🗂️ Tablas consideradas críticas**

Las medidas de protección se enfocaron principalmente en las tablas que contienen información sensible y relacional del sistema:

| **Tabla**  | **Justificación**                                            |
| ---------- | ------------------------------------------------------------ |
| pacientes  | Contiene datos personales sensibles.                         |
| medicos    | Representa actores principales del sistema clínico.          |
| hospitales | Información institucional asociada a citas médicas.          |
| citas      | Tabla central que relaciona pacientes, médicos y hospitales. |

Estas tablas fueron priorizadas debido a que un ataque exitoso sobre ellas tendría mayor impacto operativo y de confidencialidad.

#### **🧪 Prevención de ataques comunes**

Los procedimientos almacenados previenen:

- Bypass de autenticación (OR 1=1)
- Extracción de datos mediante UNION SELECT
- Ejecución de múltiples sentencias (; DELETE FROM)
- Manipulación de condiciones WHERE

Esto se logra gracias a la parametrización de consultas y al control interno de ejecución.

#### **✅ Conclusión**

La arquitectura basada en procedimientos almacenados y consultas parametrizadas elimina la posibilidad de inyección SQL al separar completamente los datos del código ejecutable, garantizando así un acceso seguro y controlado a la base de datos.

### Triggers y Evento Automático Implementados

Con el objetivo de fortalecer la integridad de los datos, automatizar procesos y simular comportamientos propios de un sistema clínico real, se implementaron triggers de validación y un evento programado dentro de la base de datos.

Estas funcionalidades permiten trasladar parte de la lógica del negocio al motor de MySQL, evitando inconsistencias incluso cuando los datos se insertan desde diferentes aplicaciones o usuarios.

#### 1. Triggers de Validación en Pacientes

Se crearon triggers `BEFORE INSERT` y `BEFORE UPDATE` sobre la tabla **pacientes** con el propósito de garantizar la calidad de la información almacenada.

##### Validaciones realizadas
- El nombre del paciente no puede ser nulo ni vacío.
- El teléfono debe existir y ser un valor positivo válido.
- En caso de error, se registra automáticamente el evento en la tabla `log_errores`.

##### Justificación
Estas validaciones se implementan a nivel de base de datos para asegurar que ningún usuario o sistema externo pueda almacenar registros inválidos, incluso si se omiten validaciones en la aplicación cliente.

Esto permite:
- Mantener consistencia de datos.
- Evitar registros incompletos.
- Centralizar reglas críticas del sistema.

#### 2. Trigger de Validación de Fecha en Citas

Se implementaron triggers sobre la tabla **citas** para impedir el registro o modificación de citas con fechas futuras.

##### Regla aplicada
Una cita médica no puede tener una fecha mayor a la fecha actual del sistema (`CURDATE()`).

##### Justificación
El sistema modela citas ya realizadas o registradas administrativamente, por lo que permitir fechas futuras podría generar:

- Informes incorrectos.
- Estadísticas alteradas.
- Inconsistencias en reportes clínicos.

El trigger garantiza que la restricción se cumpla independientemente del origen de los datos.

#### 3. Evento Automático de Informe Diario

Se creó un **EVENT de MySQL** encargado de generar automáticamente un informe diario de atención médica.

##### Funcionamiento
El evento se ejecuta cada día utilizando el `event_scheduler` del motor MySQL y realiza las siguientes acciones:

1. Consulta las citas registradas el día anterior.
2. Relaciona la información con:
   - Hospital (sede)
   - Médico responsable
3. Calcula el número de pacientes atendidos.
4. Inserta el resultado en la tabla `informe_diario`.

##### Información almacenada
- Fecha del informe
- Hospital
- Médico
- Cantidad de pacientes atendidos

##### Justificación
Este enfoque permite:

- Generar reportes históricos automáticamente.
- Evitar cálculos pesados en tiempo real.
- Simular procesos ETL básicos dentro de la base de datos.
- Facilitar análisis estadísticos posteriores.

Además, el almacenamiento diario crea un historial permanente que puede utilizarse para métricas de rendimiento médico o análisis institucional.

#### Beneficios Generales de la Implementación

La combinación de triggers y eventos aporta características propias de sistemas empresariales:

- ✔ Validación automática de datos.
- ✔ Auditoría mediante registro de errores.
- ✔ Automatización sin intervención humana.
- ✔ Separación entre lógica de aplicación y lógica de datos.
- ✔ Mayor confiabilidad del sistema.

Estas prácticas reflejan un diseño orientado a la integridad, automatización y mantenimiento escalable de la información clínica.

### Vistas (Views)

Las vistas fueron implementadas con el objetivo de **simplificar consultas complejas**, mejorar la reutilización del código SQL y facilitar la generación de reportes administrativos y académicos dentro del sistema clínico.

Una vista permite encapsular consultas frecuentes evitando la repetición constante de operaciones JOIN, reduciendo errores y mejorando la mantenibilidad del sistema.

#### **🔹 Vista 1 — Información General de Médicos**

##### **Nombre**

```sql
vw_medicos_info
```

##### Objetivo

Centralizar en una sola consulta la información profesional y académica de los médicos, integrando datos provenientes de múltiples tablas relacionadas.

Esta vista permite obtener fácilmente:

- Identificación del médico
- Nombre del médico
- Facultad a la que pertenece
- Decano de la facultad
- Especialidad médica

##### **Tablas involucradas**

- medicos
- facultades
- especialidades

##### **Implementación**

```sql
CREATE VIEW vw_medicos_info AS
SELECT 
    m.idmedico,
    m.nombre_medico,
    f.nombre_facultad,
    f.decano_facultad,
    e.especialidad
FROM medicos m
INNER JOIN facultades f 
    ON m.idfacultad = f.idfacultad
INNER JOIN especialidades e 
    ON m.idespecialidad = e.idespecialidad;
```

##### **Justificación técnica**

En una clínica universitaria es frecuente necesitar un **directorio médico completo**, ya sea para:

- asignación de citas
- consultas administrativas
- reportes académicos
- visualización institucional del personal médico

Sin esta vista, cada consulta requeriría múltiples JOIN, aumentando la complejidad y duplicación de código.

La vista encapsula esta lógica permitiendo consultas simples como:

```sql
SELECT * FROM vw_medicos_info;
```

##### **Beneficios**

- Reduce complejidad de consultas
- Evita repetición de JOIN
- Mejora legibilidad del código
- Facilita generación de reportes

#### **🔹 Vista 2 — Pacientes Atendidos por Medicamento**

##### **Nombre**

```sql
vw_pacientes_por_medicamento
```

##### **Objetivo**

Permitir el análisis estadístico del uso de medicamentos dentro del sistema clínico, mostrando cuántos pacientes han recibido cada medicamento.

##### **Relación de datos**

Un medicamento no está directamente relacionado con pacientes, por lo que la consulta sigue la cadena relacional:

```sql
medicamentos → recetas → citas → pacientes
```

##### **Implementación**

```sql
CREATE VIEW vw_pacientes_por_medicamento AS
SELECT 
    m.idmedicamento,
    m.medicamento,
    COUNT(DISTINCT c.idpaciente) AS total_pacientes
FROM medicamentos m
INNER JOIN recetas r 
    ON m.idmedicamento = r.idmedicamento
INNER JOIN citas c 
    ON r.idcita = c.idcita
GROUP BY m.idmedicamento, m.medicamento;
```

##### **Decisión técnica importante**

Se utilizó:

```sql
COUNT(DISTINCT c.idpaciente)
```

para evitar contar múltiples recetas del mismo paciente como registros independientes.

Ejemplo:

- Un paciente recibe el mismo medicamento en tres citas distintas.
- El sistema lo contabiliza como **un solo paciente**, no tres.

Esto permite obtener estadísticas reales de alcance del medicamento.

##### **Casos de uso**

- análisis farmacológico
- control de consumo médico
- apoyo a decisiones administrativas
- estudios académicos

##### **Beneficios**

- Facilita análisis estadístico
- Reduce consultas complejas
- Mejora interpretación de datos clínicos

### **Particionamiento de Tablas**

#### **Concepto**

El particionamiento divide físicamente una tabla en múltiples secciones llamadas **particiones**, permitiendo que el motor de base de datos consulte únicamente una parte del conjunto de datos en lugar de la tabla completa.

#### Criterio Profesional Aplicado

La decisión de particionar **no se basa únicamente en el tamaño de la tabla**, sino en:

✅ crecimiento continuo de datos

✅ patrones frecuentes de consulta

✅ filtrado por rangos (especialmente fechas)

✅ optimización de consultas históricas

#### **Clasificación de Tablas del Sistema**

| **Tipo**                   | **Tablas**                                                   |
| -------------------------- | ------------------------------------------------------------ |
| Tablas maestras (catálogo) | pacientes, medicos, facultades, especialidades, medicamentos |
| Tablas transaccionales     | citas, recetas                                               |
| Tablas de auditoría        | log_errores                                                  |

#### **✅ Tablas Seleccionadas para Particionamiento**

##### **🔹 Tabla** **citas**

###### **Justificación**

La tabla citas representa el núcleo transaccional del sistema:

- crece diariamente
- almacena histórico médico
- consultas frecuentes por fecha
- generación constante de reportes

Ejemplos típicos:

```sql
WHERE fecha_cita BETWEEN '2025-01-01' AND '2025-12-31'
```

Este patrón hace ideal el particionamiento por rango temporal.

###### **Implementación**

```sql
ALTER TABLE citas
PARTITION BY RANGE (YEAR(fecha_cita)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);
```

###### **Beneficios**

- Reduce escaneo completo de tabla
- Mejora reportes históricos
- Escalabilidad a largo plazo

##### **🔹 Tabla** recetas

###### **Justificación**

La tabla recetas crece proporcionalmente al número de citas médicas. Cada nueva cita puede generar múltiples recetas, produciendo alto volumen de registros. Las consultas suelen realizarse mediante la relación con idcita.

###### **Implementación**

```sql
ALTER TABLE recetas
PARTITION BY HASH(idcita)
PARTITIONS 4;
```

###### **Beneficios**

- Distribución uniforme de datos
- Mejora rendimiento en JOIN
- Balance de carga en almacenamiento

##### **🔹 Tabla** **log_errores**

###### **Justificación**

Es una tabla de auditoría que crece continuamente y se consulta principalmente por fecha.

Permite:

- análisis de fallos
- monitoreo del sistema
- mantenimiento histórico

###### **Implementación**

```sql
ALTER TABLE log_errores
PARTITION BY RANGE (YEAR(fecha_hora)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);
```

###### **Beneficios**

- mantenimiento sencillo de logs
- eliminación rápida de datos antiguos
- consultas más eficientes

#### **❌ Tablas NO Particionadas (Justificación)**

##### **🔹 Tabla** **pacientes**

Aunque puede crecer considerablemente, las consultas se realizan principalmente mediante:

- clave primaria (idpaciente)
- campos indexados únicos

Las búsquedas por índice ya son altamente eficientes, por lo que la partición no aporta mejoras reales y aumentaría la complejidad administrativa.

##### **🔹 Tabla** **medicamentos**

Funciona como catálogo maestro:

- crecimiento moderado
- consultas por identificador
- sin filtrado por rangos

El acceso mediante índices hace innecesario el particionamiento.

##### **🔹 Tabla** **medicos**

El número de médicos es limitado en comparación con tablas transaccionales. Las consultas se realizan mediante claves indexadas y no existen consultas por rangos que justifiquen particiones.

##### **🔹 Tablas** facultades **y** **especialidades**

Son tablas estáticas de referencia con bajo volumen de registros y cambios poco frecuentes. El particionamiento no generaría beneficios de rendimiento.

#### **3️⃣ Conclusión**

El diseño de particionamiento se realizó siguiendo principios profesionales de optimización basados en **patrones de acceso a los datos y naturaleza transaccional**, en lugar de únicamente el tamaño potencial de las tablas.

Se decidió:

✅ particionar tablas transaccionales y de auditoría

❌ evitar particionar tablas maestras o de catálogo

Esto permite:

- mejor rendimiento en consultas históricas
- mayor escalabilidad del sistema
- mantenimiento eficiente de datos
- diseño alineado con prácticas reales de sistemas clínicos