DELIMITER //
CREATE PROCEDURE sp_pacientes_create(IN p_idpaciente VARCHAR(6),IN p_nombre VARCHAR(45),IN p_apellido VARCHAR(45),IN p_telefono INT)
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear paciente' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    SET @sql = '
        INSERT INTO pacientes
        (idpaciente, nombre_paciente, apellido_paciente, telefono_paciente)
        VALUES (?, ?, ?, ?)
    ';

    SET @id = p_idpaciente;
    SET @nom = p_nombre;
    SET @ape = p_apellido;
    SET @tel = p_telefono;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id, @nom, @ape, @tel;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Paciente creado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_read(IN p_idpaciente VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar paciente' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM pacientes WHERE idpaciente = p_idpaciente;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('pacientes','02000','Registro no encontrado',NOW());
        SELECT 'Paciente no encontrado' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM pacientes WHERE idpaciente = p_idpaciente;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_update(IN p_idpaciente VARCHAR(6),IN p_nombre VARCHAR(45),IN p_apellido VARCHAR(45),IN p_telefono INT)
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar paciente' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM pacientes WHERE idpaciente = p_idpaciente;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('pacientes','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Paciente no encontrado' AS resultado;
        LEAVE proc_update;
    END IF;

    SET @sql = '
        UPDATE pacientes
        SET nombre_paciente=?,
            apellido_paciente=?,
            telefono_paciente=?
        WHERE idpaciente=?
        ';

    SET @nom = p_nombre;
    SET @ape = p_apellido;
    SET @tel = p_telefono;
    SET @id  = p_idpaciente;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @nom,@ape,@tel,@id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Paciente actualizado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_pacientes_delete(IN p_idpaciente VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('pacientes',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar paciente' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM pacientes WHERE idpaciente = p_idpaciente;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('pacientes','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Paciente no encontrado' AS resultado;
        LEAVE proc_delete;
    END IF;

    SET @sql = 'DELETE FROM pacientes WHERE idpaciente=?';

    SET @id = p_idpaciente;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Paciente eliminado correctamente' AS resultado;

END //
DELIMITER ;