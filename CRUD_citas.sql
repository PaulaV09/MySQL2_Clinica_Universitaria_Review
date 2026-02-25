DELIMITER //
CREATE PROCEDURE sp_citas_create(IN p_idcita VARCHAR(6),IN p_fecha_cita DATE,IN p_diagnostico VARCHAR(255),IN p_idmedico VARCHAR(6),IN p_idpaciente VARCHAR(6),IN p_idhospital VARCHAR(6))
proc_create: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('citas', v_codigo, v_mensaje);
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('citas', v_codigo, v_mensaje);

        ROLLBACK;
        SELECT 'Error al crear cita' AS resultado;
        LEAVE proc_create;
    END;

    START TRANSACTION;

    SET @sql = '
        INSERT INTO citas
        (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital)
        VALUES (?, ?, ?, ?, ?, ?)
    ';

    SET @id = p_idcita;
    SET @fecha = p_fecha_cita;
    SET @diag = p_diagnostico;
    SET @idmed = p_idmedico;
    SET @idpac = p_idpaciente;
    SET @idhos = p_idhospital;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id, @fecha, @diag, @idmed, @idpac, @idhos;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Cita creada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_read(IN p_idcita VARCHAR(6))
proc_read: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());

        SELECT 'Error al consultar cita' AS resultado;
        LEAVE proc_read;
    END;

    SELECT COUNT(*) INTO v_existe FROM citas WHERE idcita = p_idcita;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('citas','02000','Registro no encontrado',NOW());
        SELECT 'Cita no encontrada' AS resultado;
        LEAVE proc_read;
    END IF;

    SELECT * FROM citas WHERE idcita = p_idcita;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_update(IN p_idcita VARCHAR(6),IN p_fecha_cita DATE,IN p_diagnostico VARCHAR(255),IN p_idmedico VARCHAR(6),IN p_idpaciente VARCHAR(6),IN p_idhospital VARCHAR(6))
proc_update: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al actualizar cita' AS resultado;
        LEAVE proc_update;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM citas WHERE idcita = p_idcita;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('citas','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Cita no encontrada' AS resultado;
        LEAVE proc_update;
    END IF;

    SET @sql = '
        UPDATE citas
        SET fecha_cita=?,
            diagnostico=?,
            idmedico=?,
            idpaciente=?,
            idhospital=?
        WHERE idcita=?
        ';

    SET @id = p_idcita;
    SET @fecha = p_fecha_cita;
    SET @diag = p_diagnostico;
    SET @idmed = p_idmedico;
    SET @idpac = p_idpaciente;
    SET @idhos = p_idhospital;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @fecha, @diag, @idmed, @idpac, @idhos, @id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Cita actualizada correctamente' AS resultado;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_delete(IN p_idcita VARCHAR(6))
proc_delete: BEGIN

    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    DECLARE v_existe INT;

    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores VALUES ('citas',v_codigo,v_mensaje,NOW());

        ROLLBACK;
        SELECT 'Error al eliminar cita' AS resultado;
        LEAVE proc_delete;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe FROM citas WHERE idcita = p_idcita;

    IF v_existe = 0 THEN
        INSERT INTO log_errores VALUES ('citas','02000','Registro no encontrado',NOW());
        ROLLBACK;
        SELECT 'Cita no encontrada' AS resultado;
        LEAVE proc_delete;
    END IF;

    SET @sql = 'DELETE FROM citas WHERE idcita=?';

    SET @id = p_idcita;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id;
    DEALLOCATE PREPARE stmt;

    COMMIT;

    SELECT 'Cita eliminada correctamente' AS resultado;

END //
DELIMITER ;