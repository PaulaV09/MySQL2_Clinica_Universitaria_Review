DELIMITER //
CREATE PROCEDURE sp_hospitales_create( IN p_idhospital VARCHAR(6), IN p_hospital VARCHAR(45), IN p_direccion VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('hospitales',v_codigo,v_mensaje);
        SELECT 'Error al crear hospital' AS resultado;
    END;

    INSERT INTO hospitales (idhospital, hospital, direccion) VALUES (p_idhospital,p_hospital,p_direccion);
    SELECT 'Hospital creada correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_read( IN p_idhospital VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('hospitales',v_codigo,v_mensaje);
        SELECT 'Error al consultar hospital' AS resultado;
    END;

    SELECT * FROM hospitales WHERE idhospital = p_idhospital;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_update( IN p_idhospital VARCHAR(6), IN p_hospital VARCHAR(45), IN p_direccion VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('hospitales',v_codigo,v_mensaje);
        SELECT 'Error al actualizar hospital' AS resultado;
    END;

    UPDATE hospitales SET hospital = p_hospital, direccion = p_direccion WHERE idhospital = p_idhospital;
    SELECT 'Hospital actualizada correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_delete( IN p_idhospital VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('hospitales',v_codigo,v_mensaje);
        SELECT 'Error al eliminar hospital' AS resultado;
    END;

    DELETE FROM hospitales WHERE idhospital = p_idhospital;
    SELECT 'Hospital eliminada correctamente' AS resultado;

END//
DELIMITER ;