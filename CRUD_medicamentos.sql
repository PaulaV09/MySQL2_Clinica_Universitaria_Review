DELIMITER //
CREATE PROCEDURE sp_medicamentos_create(IN p_idmedicamento VARCHAR(6),IN p_medicamento VARCHAR(45))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear medicamento' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    INSERT INTO medicamentos VALUES (p_idmedicamento,p_medicamento);

    COMMIT;

    SELECT 'Medicamento creado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_read(IN p_idmedicamento VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar medicamento' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM medicamentos WHERE idmedicamento = p_idmedicamento;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicamentos','02000','Registro no encontrado',NOW());
        SELECT 'Medicamento no encontrado' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM medicamentos WHERE idmedicamento = p_idmedicamento;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_update(IN p_idmedicamento VARCHAR(6),IN p_medicamento VARCHAR(45))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar medicamento' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM medicamentos WHERE idmedicamento = p_idmedicamento;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicamentos','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Medicamento no encontrado' AS resultado;
        LEAVE proc_update;
    END IF;

    UPDATE medicamentos SET medicamento = p_medicamento WHERE idmedicamento = p_idmedicamento;

    COMMIT;

    SELECT 'Medicamento actualizado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_delete(IN p_idmedicamento VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('medicamentos',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar medicamento' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM medicamentos WHERE idmedicamento = p_idmedicamento;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('medicamentos','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Medicamento no encontrado' AS resultado;
        LEAVE proc_delete;
    END IF;

    DELETE FROM medicamentos WHERE idmedicamento = p_idmedicamento;

    COMMIT;

    SELECT 'Medicamento eliminado correctamente' AS resultado;

END //
DELIMITER ;

