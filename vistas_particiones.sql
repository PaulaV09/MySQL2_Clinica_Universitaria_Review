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

ALTER TABLE citas
PARTITION BY RANGE (YEAR(fecha_cita)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);

ALTER TABLE recetas
PARTITION BY HASH(idcita)
PARTITIONS 4;

ALTER TABLE log_errores
PARTITION BY RANGE (YEAR(fecha_hora)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);