DELIMITER //
CREATE PROCEDURE sp_facultades_create(IN p_idfacultad VARCHAR(6),IN p_nombre VARCHAR(45),IN p_decano VARCHAR(45))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear facultad' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    INSERT INTO facultades VALUES (p_idfacultad, p_nombre, p_decano);

    COMMIT;

    SELECT 'Facultad creada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_facultades_read(IN p_idfacultad VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar facultad' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM facultades WHERE idfacultad = p_idfacultad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('facultades','02000','Registro no encontrado',NOW());
        SELECT 'Facultad no encontrada' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM facultades WHERE idfacultad = p_idfacultad;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_facultades_update(IN p_idfacultad VARCHAR(6),IN p_nombre VARCHAR(45),IN p_decano VARCHAR(45))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar facultad' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM facultades WHERE idfacultad = p_idfacultad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('facultades','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Facultad no encontrada' AS resultado;
        LEAVE proc_update;
    END IF;

    UPDATE facultades
    SET nombre_facultad = p_nombre,
        decano_facultad = p_decano
    WHERE idfacultad = p_idfacultad;

    COMMIT;

    SELECT 'Facultad actualizada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_facultades_delete(IN p_idfacultad VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('facultades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar facultad' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM facultades WHERE idfacultad = p_idfacultad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('facultades','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Facultad no encontrada' AS resultado;
        LEAVE proc_delete;
    END IF;

    DELETE FROM facultades WHERE idfacultad = p_idfacultad;

    COMMIT;

    SELECT 'Facultad eliminada correctamente' AS resultado;

END //
DELIMITER ;

