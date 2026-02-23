DELIMITER //
CREATE PROCEDURE sp_especialidades_create(IN p_idespecialidad VARCHAR(6),IN p_especialidad VARCHAR(45))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear especialidad' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    INSERT INTO especialidades VALUES (p_idespecialidad, p_especialidad);

    COMMIT;

    SELECT 'Especialidad creada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_read(IN p_idespecialidad VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar especialidad' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM especialidades WHERE idespecialidad = p_idespecialidad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('especialidades','02000','Registro no encontrado',NOW());
        SELECT 'Especialidad no encontrada' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM especialidades WHERE idespecialidad = p_idespecialidad;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_update(IN p_idespecialidad VARCHAR(6),IN p_especialidad VARCHAR(45))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar especialidad' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM especialidades WHERE idespecialidad = p_idespecialidad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('especialidades','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Especialidad no encontrada' AS resultado;
        LEAVE proc_update;
    END IF;

    UPDATE especialidades SET especialidad = p_especialidad WHERE idespecialidad = p_idespecialidad;

    COMMIT;

    SELECT 'Especialidad actualizada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_especialidades_delete(IN p_idespecialidad VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('especialidades',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar especialidad' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM especialidades WHERE idespecialidad = p_idespecialidad;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('especialidades','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Especialidad no encontrada' AS resultado;
        LEAVE proc_delete;
    END IF;

    DELETE FROM especialidades WHERE idespecialidad = p_idespecialidad;

    COMMIT;

    SELECT 'Especialidad eliminada correctamente' AS resultado;

END //
DELIMITER ;