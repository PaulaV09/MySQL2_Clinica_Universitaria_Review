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

    SET @sql = '
        INSERT INTO medicos
        (idmedico, nombre_medico, idfacultad, idespecialidad)
        VALUES (?, ?, ?, ?)
    ';

    SET @id = p_idmedico;
    SET @nom = p_nombre_medico;
    SET @idfacu = p_idfacultad;
    SET @idesp = p_idespecialidad;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id, @nom, @idfacu, @idesp;
    DEALLOCATE PREPARE stmt;

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

     SET @sql = '
        UPDATE medicos
        SET nombre_medico=?,
            idfacultad=?,
            idespecialidad=?
        WHERE idmedico=?
        ';

    SET @nom = p_nombre_medico;
    SET @idfacu = p_idfacultad;
    SET @idesp = p_idespecialidad;
    SET @id  = p_idmedico;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @nom,@idfacu,@idesp,@id;
    DEALLOCATE PREPARE stmt;

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

    SET @sql = 'DELETE FROM medicos WHERE idmedico=?';

    SET @id = p_idmedico;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Medico eliminado correctamente' AS resultado;

END //
DELIMITER ;

