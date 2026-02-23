DELIMITER //
CREATE PROCEDURE sp_recetas_create(IN p_idreceta VARCHAR(6),IN p_dosis VARCHAR(45),IN p_idmedicamento VARCHAR(45),IN p_idcita VARCHAR(6))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear receta' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    INSERT INTO recetas VALUES (p_idreceta,p_dosis,p_idmedicamento,p_idcita);

    COMMIT;

    SELECT 'Receta creada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_read(IN p_idreceta VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar receta' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM recetas WHERE idreceta = p_idreceta;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('recetas','02000','Registro no encontrado',NOW());
        SELECT 'Receta no encontrada' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM recetas WHERE idreceta = p_idreceta;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_update(IN p_idreceta VARCHAR(6),IN p_dosis VARCHAR(45),IN p_idmedicamento VARCHAR(45),IN p_idcita VARCHAR(6))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar receta' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM recetas WHERE idreceta = p_idreceta;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('recetas','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Receta no encontrada' AS resultado;
        LEAVE proc_update;
    END IF;

    UPDATE recetas
    SET dosis = p_dosis,
        idmedicamento = p_idmedicamento,
        idcita = p_idcita
    WHERE idreceta = p_idreceta;

    COMMIT;

    SELECT 'Receta actualizada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_recetas_delete(IN p_idreceta VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('recetas',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar receta' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM recetas WHERE idreceta = p_idreceta;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('recetas','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Receta no encontrada' AS resultado;
        LEAVE proc_delete;
    END IF;

    DELETE FROM recetas WHERE idreceta = p_idreceta;

    COMMIT;

    SELECT 'Receta eliminada correctamente' AS resultado;

END //
DELIMITER ;