DELIMITER //
CREATE PROCEDURE sp_medicos_create(IN p_idmedico VARCHAR(6), IN p_nombre_medico VARCHAR(45), IN p_idfacultad VARCHAR(45), IN p_idespecialidad VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('medicos', v_codigo, v_mensaje);
        SELECT 'Error al crear medico' AS resultado;
    END;
    INSERT INTO medicos (idmedico, nombre_medico, idfacultad, idespecialidad) VALUES (p_idmedico,p_nombre_medico,p_idfacultad,p_idespecialidad);
	SELECT 'Medico creado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_read(IN p_idmedico VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('medicos', v_codigo, v_mensaje);
        SELECT 'Error al consultar medico' AS resultado;
    END;

    SELECT * FROM medicos WHERE idmedico = p_idmedico;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_update(IN p_idmedico VARCHAR(6), IN p_nombre_medico VARCHAR(45), IN p_idfacultad VARCHAR(45), IN p_idespecialidad VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('medicos', v_codigo, v_mensaje);
        SELECT 'Error al actualizar medicos' AS resultado;
    END;

    UPDATE medicos SET nombre_medico = p_nombre_medico, idfacultad = p_idfacultad, idespecialidad = p_idespecialidad WHERE idmedico = p_idmedico;
    SELECT 'Medico actualizado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_delete( IN p_idmedico VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('medicos', v_codigo, v_mensaje);
        SELECT 'Error al eliminar medico' AS resultado;
    END;

    DELETE FROM medicos WHERE idmedico = p_idmedico;
    SELECT 'Medico eliminado correctamente' AS resultado;
END//
DELIMITER ;