# Review: Clinica Universitaria

##### Paula Andrea Viviescas Jaimes

El presente proyecto tiene como objetivo aplicar el proceso de normalización de bases de datos hasta la **Cuarta Forma Normal (4FN)** a partir de un conjunto de datos suministrado en un archivo Excel correspondiente a la gestión de una clínica universitaria. Durante el desarrollo se realizó el análisis de la información, la identificación de dependencias y la descomposición de las tablas con el fin de eliminar redundancias y garantizar la integridad de los datos.

Como resultado, se diseñó e implementó el modelo físico de la base de datos en MySQL, estableciendo las relaciones entre entidades, restricciones de integridad y tipos de datos adecuados. Además, se desarrollaron procedimientos almacenados para las operaciones CRUD de cada tabla y funciones adicionales orientadas a la consulta y análisis de información clínica.

El sistema incorpora también un mecanismo de manejo de errores que permite registrar automáticamente las excepciones generadas durante la ejecución de procedimientos y funciones, almacenando información relevante para el control y seguimiento de fallos.

Este proyecto integra conceptos de normalización avanzada, modelado relacional y programación en bases de datos, aplicando buenas prácticas en el diseño e implementación de sistemas de información.

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

```
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

```
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

```
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

```
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

```
COUNT(DISTINCT idpaciente)
```

para evitar contar varias veces al mismo paciente cuando posee múltiples citas.

**Ejemplo de uso:**

```
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

```
COUNT(DISTINCT idpaciente)
```

**Ejemplo de uso:**

```
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

---

#### 🧠 Principios aplicados

Durante la definición de permisos se tuvieron en cuenta los siguientes criterios:

- **Separación de responsabilidades:** cada tipo de usuario representa un rol funcional dentro de la clínica.
- **Integridad de datos:** evitar eliminaciones o modificaciones accidentales.
- **Seguridad operativa:** restringir accesos directos innecesarios a tablas críticas.
- **Escalabilidad:** permitir que el sistema pueda crecer manteniendo control de accesos claro.
- **Auditoría:** garantizar acceso controlado a registros de errores.

---

## 👥 Usuarios del sistema y justificación de permisos

---

#### 🧠 Administrador (`admin_clinica`)

El usuario administrador posee control total sobre la base de datos, ya que es responsable del mantenimiento, configuración y gestión general del sistema.

**Permisos otorgados:**
- `ALL PRIVILEGES` sobre toda la base de datos.

**Justificación:**
Este usuario debe poder crear estructuras, modificar tablas, gestionar usuarios y solucionar incidencias técnicas del sistema.

---

#### 🧾 Recepción (`recepcion`)

Representa al personal encargado del registro y gestión administrativa de pacientes y citas médicas.

**Permisos otorgados:**
- `SELECT`, `INSERT`, `UPDATE` sobre `pacientes` y `citas`.
- `SELECT` sobre `medicos` y `hospitales`.

**Justificación:**
El personal de recepción necesita registrar pacientes y programar citas, pero **no debe eliminar información**, ya que esto podría causar pérdida histórica de registros clínicos.

---

#### 👨‍⚕️ Médico (`medico_user`)

Corresponde a los profesionales de salud que atienden consultas médicas.

**Permisos otorgados:**
- `SELECT` sobre `pacientes`.
- `SELECT`, `UPDATE` sobre `citas`.
- `SELECT` sobre `medicamentos`.
- `SELECT`, `INSERT` sobre `recetas`.

**Justificación:**
El médico debe consultar información del paciente y registrar diagnósticos o tratamientos, pero no modificar datos administrativos ni eliminar registros clínicos.

---

#### 💊 Farmacia (`farmacia_user`)

Usuario encargado de la gestión de medicamentos y verificación de recetas.

**Permisos otorgados:**
- `SELECT` sobre `recetas`.
- `SELECT`, `INSERT`, `UPDATE` sobre `medicamentos`.

**Justificación:**
La farmacia requiere consultar las recetas emitidas y mantener actualizado el catálogo de medicamentos disponibles, sin acceso a información clínica completa.

---

#### 📊 Dirección (`direccion_user`)

Usuario destinado a análisis y toma de decisiones administrativas.

**Permisos otorgados:**
- `SELECT` sobre toda la base de datos.

**Justificación:**
La dirección únicamente necesita consultar información estadística y operativa, sin capacidad de modificar datos del sistema.

---

#### 🔎 Auditor (`auditor_user`)

Encargado del seguimiento de errores y control del sistema.

**Permisos otorgados:**
- `SELECT` sobre `log_errores`.

**Justificación:**
Permite revisar fallos registrados sin riesgo de alterar evidencia o modificar información del sistema.

---

#### 🤖 Aplicación (`app_backend`)

Usuario utilizado por la aplicación backend.

**Permisos otorgados:**
- `EXECUTE` sobre procedimientos y funciones almacenadas.

**Justificación:**
La aplicación interactúa únicamente mediante procedimientos almacenados, evitando acceso directo a las tablas y aumentando la seguridad del sistema.

---

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

---

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

```
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