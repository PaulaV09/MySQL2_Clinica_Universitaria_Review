DELIMITER //
CREATE PROCEDURE sp_facultades_create( IN p_idfacultad VARCHAR(6), IN p_nombre VARCHAR(45), IN p_decano VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('facultades',v_codigo,v_mensaje);
        SELECT 'Error al crear facultad' AS resultado;
    END;

    INSERT INTO facultades (idfacultad, nombre_facultad, decano_facultad) VALUES (p_idfacultad,p_nombre,p_decano);
    SELECT 'Facultad creada correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_facultades_read( IN p_idfacultad VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('facultades',v_codigo,v_mensaje);
        SELECT 'Error al consultar facultad' AS resultado;
    END;

    SELECT * FROM facultades WHERE idfacultad = p_idfacultad;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_facultades_update( IN p_idfacultad VARCHAR(6), IN p_nombre VARCHAR(45), IN p_decano VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('facultades',v_codigo,v_mensaje);
        SELECT 'Error al actualizar facultad' AS resultado;
    END;

    UPDATE facultades SET nombre_facultad = p_nombre, decano_facultad = p_decano WHERE idfacultad = p_idfacultad;
    SELECT 'Facultad actualizada correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_facultades_delete( IN p_idfacultad VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('facultades',v_codigo,v_mensaje);
        SELECT 'Error al eliminar facultad' AS resultado;
    END;

    DELETE FROM facultades WHERE idfacultad = p_idfacultad;
    SELECT 'Facultad eliminada correctamente' AS resultado;

END//
DELIMITER ;