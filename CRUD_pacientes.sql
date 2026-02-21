DELIMITER //
CREATE PROCEDURE sp_pacientes_create(IN p_idpaciente VARCHAR(6), IN p_nombre VARCHAR(45), IN p_apellido VARCHAR(45), IN p_telefono INT)
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('pacientes', v_codigo, v_mensaje);
        SELECT 'Error al crear paciente' AS resultado;
    END;
    INSERT INTO pacientes (idpaciente, nombre_paciente, apellido_paciente, telefono_paciente) VALUES (p_idpaciente,p_nombre,p_apellido,p_telefono);
	SELECT 'Paciente creado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_read(IN p_idpaciente VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('pacientes', v_codigo, v_mensaje);
        SELECT 'Error al consultar paciente' AS resultado;
    END;

    SELECT * FROM pacientes WHERE idpaciente = p_idpaciente;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_update(IN p_idpaciente VARCHAR(6), IN p_nombre VARCHAR(45), IN p_apellido VARCHAR(45), IN p_telefono INT)
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('pacientes', v_codigo, v_mensaje);
        SELECT 'Error al actualizar paciente' AS resultado;
    END;

    UPDATE pacientes SET nombre_paciente = p_nombre, apellido_paciente = p_apellido, telefono_paciente = p_telefono WHERE idpaciente = p_idpaciente;
    SELECT 'Paciente actualizado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_delete( IN p_idpaciente VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('pacientes', v_codigo, v_mensaje);
        SELECT 'Error al eliminar paciente' AS resultado;
    END;

    DELETE FROM pacientes WHERE idpaciente = p_idpaciente;
    SELECT 'Paciente eliminado correctamente' AS resultado;
END//
DELIMITER ;