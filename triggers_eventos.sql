DELIMITER //
CREATE TRIGGER trg_pacientes_validacion_insert
BEFORE INSERT ON pacientes
FOR EACH ROW
BEGIN

    IF NEW.nombre_paciente IS NULL OR NEW.nombre_paciente = '' THEN
        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error)
        VALUES ('pacientes','45000','El nombre del paciente no puede estar vacío');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nombre del paciente obligatorio';
    END IF;

    IF NEW.telefono_paciente IS NULL OR NEW.telefono_paciente <= 0 THEN
        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error)
        VALUES ('pacientes','45000','Telefono invalido');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Telefono invalido';
    END IF;

END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_pacientes_validacion_update
BEFORE UPDATE ON pacientes
FOR EACH ROW
BEGIN

    IF NEW.nombre_paciente IS NULL OR NEW.nombre_paciente = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nombre del paciente obligatorio';
    END IF;

    IF NEW.telefono_paciente IS NULL OR NEW.telefono_paciente <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Telefono invalido';
    END IF;

END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_citas_fecha_insert
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN

    IF NEW.fecha_cita > CURDATE() THEN

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error)
        VALUES ('citas','45000','Fecha de cita futura no permitida');

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la cita no puede ser futura';
    END IF;

END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_citas_fecha_update
BEFORE UPDATE ON citas
FOR EACH ROW
BEGIN

    IF NEW.fecha_cita > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la cita no puede ser futura';
    END IF;

END //
DELIMITER ;

SET GLOBAL event_scheduler = ON;

DELIMITER //
CREATE EVENT ev_generar_informe_diario
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN

    INSERT INTO informe_diario (fecha, hospital, medico, pacientes_atendidos)

    SELECT 
        CURDATE() - INTERVAL 1 DAY AS fecha,
        h.hospital,
        m.nombre_medico,
        COUNT(c.idpaciente) AS pacientes_atendidos
    FROM citas c
    JOIN hospitales h ON c.idhospital = h.idhospital
    JOIN medicos m ON c.idmedico = m.idmedico
    WHERE c.fecha_cita = CURDATE() - INTERVAL 1 DAY
    GROUP BY h.hospital, m.nombre_medico;

END //
DELIMITER ;