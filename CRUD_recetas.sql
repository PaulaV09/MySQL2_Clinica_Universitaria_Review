DELIMITER //
CREATE PROCEDURE sp_recetas_create(IN p_idreceta VARCHAR(6), IN p_dosis VARCHAR(45), IN p_idmedicamento VARCHAR(45), IN p_idcita VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('recetas', v_codigo, v_mensaje);
        SELECT 'Error al crear receta' AS resultado;
    END;
    INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES (p_idreceta,p_dosis,p_idmedicamento,p_idcita);
	SELECT 'Receta creado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_read(IN p_idreceta VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('recetas', v_codigo, v_mensaje);
        SELECT 'Error al consultar receta' AS resultado;
    END;

    SELECT * FROM recetas WHERE idreceta = p_idreceta;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_update(IN p_idreceta VARCHAR(6), IN p_dosis VARCHAR(45), IN p_idmedicamento VARCHAR(45), IN p_idcita VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('recetas', v_codigo, v_mensaje);
        SELECT 'Error al actualizar recetas' AS resultado;
    END;

    UPDATE recetas SET dosis = p_dosis, idmedicamento = p_idmedicamento, idcita = p_idcita WHERE idreceta = p_idreceta;
    SELECT 'Receta actualizado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_delete( IN p_idreceta VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('recetas', v_codigo, v_mensaje);
        SELECT 'Error al eliminar receta' AS resultado;
    END;

    DELETE FROM recetas WHERE idreceta = p_idreceta;
    SELECT 'Receta eliminado correctamente' AS resultado;
END//
DELIMITER ;