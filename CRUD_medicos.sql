DELIMITER //
CREATE PROCEDURE sp_medicos_create(IN p_idmedico VARCHAR(6),IN p_nombre_medico VARCHAR(45),IN p_idfacultad VARCHAR(45),IN p_idespecialidad VARCHAR(6))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear medico' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    INSERT INTO medicos VALUES (p_idmedico,p_nombre_medico,p_idfacultad,p_idespecialidad);

    COMMIT;

    SELECT 'Medico creado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_read(IN p_idmedico VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar medico' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM medicos WHERE idmedico = p_idmedico;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicos','02000','Registro no encontrado',NOW());
        SELECT 'Medico no encontrado' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM medicos WHERE idmedico = p_idmedico;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_update(IN p_idmedico VARCHAR(6),IN p_nombre_medico VARCHAR(45),IN p_idfacultad VARCHAR(45),IN p_idespecialidad VARCHAR(6))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar medicos' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM medicos WHERE idmedico = p_idmedico;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicos','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Medico no encontrado' AS resultado;
        LEAVE proc_update;
    END IF;

    UPDATE medicos
    SET nombre_medico = p_nombre_medico,
        idfacultad = p_idfacultad,
        idespecialidad = p_idespecialidad
    WHERE idmedico = p_idmedico;

    COMMIT;

    SELECT 'Medico actualizado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicos_delete(IN p_idmedico VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar medico' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM medicos WHERE idmedico = p_idmedico;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicos','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Medico no encontrado' AS resultado;
        LEAVE proc_delete;
    END IF;

    DELETE FROM medicos WHERE idmedico = p_idmedico;

    COMMIT;

    SELECT 'Medico eliminado correctamente' AS resultado;

END //
DELIMITER ;

