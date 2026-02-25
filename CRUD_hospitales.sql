DELIMITER //
CREATE PROCEDURE sp_hospitales_create(IN p_idhospital VARCHAR(6),IN p_hospital VARCHAR(45),IN p_direccion VARCHAR(45))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al crear hospital' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    SET @sql = '
        INSERT INTO hospitales
        (idhospital, hospital, direccion)
        VALUES (?, ?, ?)
    ';

    SET @id = p_idhospital;
    SET @hosp = p_hospital;
    SET @dir = p_direccion;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id, @hosp, @dir;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Hospital creado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_read(IN p_idhospital VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar hospital' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM hospitales WHERE idhospital = p_idhospital;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('hospitales','02000','Registro no encontrado',NOW());
        SELECT 'Hospital no encontrado' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM hospitales WHERE idhospital = p_idhospital;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_update(IN p_idhospital VARCHAR(6),IN p_hospital VARCHAR(45),IN p_direccion VARCHAR(45))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar hospital' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM hospitales WHERE idhospital = p_idhospital;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('hospitales','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Hospital no encontrado' AS resultado;
        LEAVE proc_update;
    END IF;

    SET @sql = '
        UPDATE hospitales
        SET hospital=?,
            direccion=?
        WHERE idhospital=?
        ';

    SET @hosp = p_hospital;
    SET @dir = p_direccion;
    SET @id  = p_idhospital;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @hosp,@dir,@id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Hospital actualizado correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_hospitales_delete(IN p_idhospital VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('hospitales',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar hospital' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM hospitales WHERE idhospital = p_idhospital;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('hospitales','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Hospital no encontrado' AS resultado;
        LEAVE proc_delete;
    END IF;

    SET @sql = 'DELETE FROM hospitales WHERE idhospital=?';

    SET @id = p_idhospital;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Hospital eliminado correctamente' AS resultado;

END //
DELIMITER ;