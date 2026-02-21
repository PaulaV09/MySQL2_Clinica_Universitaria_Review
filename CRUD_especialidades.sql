DELIMITER //
CREATE PROCEDURE sp_especialidades_create( IN p_idespecialidad VARCHAR(6), IN p_especialidad VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('especialidades',v_codigo,v_mensaje);
        SELECT 'Error al crear especialidad' AS resultado;
    END;

    INSERT INTO especialidades (idespecialidad, especialidad) VALUES (p_idespecialidad,p_especialidad);
    SELECT 'especialidad creado correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_read( IN p_idespecialidad VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('especialidades',v_codigo,v_mensaje);
        SELECT 'Error al consultar especialidad' AS resultado;
    END;

    SELECT * FROM especialidades WHERE idespecialidad = p_idespecialidad;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_update( IN p_idespecialidad VARCHAR(6), IN p_especialidad VARCHAR(45))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('especialidades',v_codigo,v_mensaje);
        SELECT 'Error al actualizar especialidad' AS resultado;
    END;

    UPDATE especialidades SET especialidad = p_especialidad WHERE idespecialidad = p_idespecialidad;
    SELECT 'especialidad actualizado correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_delete( IN p_idespecialidad VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('especialidades',v_codigo,v_mensaje);
        SELECT 'Error al eliminar especialidad' AS resultado;
    END;

    DELETE FROM especialidades WHERE idespecialidad = p_idespecialidad;
    SELECT 'especialidad eliminado correctamente' AS resultado;

END//
DELIMITER ;