DELIMITER //
CREATE PROCEDURE sp_citas_create(IN p_idcita VARCHAR(6), IN p_fecha_cita VARCHAR(45), IN p_diagnostico VARCHAR(45), IN p_idmedico VARCHAR(6), IN p_idpaciente VARCHAR(6), IN p_idhospital VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('citas', v_codigo, v_mensaje);
        SELECT 'Error al crear cita' AS resultado;
    END;
    INSERT INTO citas (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital) VALUES (p_idcita,p_fecha_cita,p_diagnostico,p_idmedico,p_idpaciente,p_idhospital);
	SELECT 'Cita creado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_read(IN p_idcita VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('citas', v_codigo, v_mensaje);
        SELECT 'Error al consultar cita' AS resultado;
    END;

    SELECT * FROM citas WHERE idcita = p_idcita;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_update(IN p_idcita VARCHAR(6), IN p_fecha_cita VARCHAR(45), IN p_diagnostico VARCHAR(45), IN p_idmedico VARCHAR(6), IN p_idpaciente VARCHAR(6), IN p_idhospital VARCHAR(6))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('citas', v_codigo, v_mensaje);
        SELECT 'Error al actualizar cita' AS resultado;
    END;

    UPDATE citas SET fecha_cita = p_fecha_cita, diagnostico = p_diagnostico, idmedico = p_idmedico, idpaciente = p_idpaciente, idhospital = p_idhospital WHERE idcita = p_idcita;
    SELECT 'Cita actualizado correctamente' AS resultado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_citas_delete( IN p_idcita VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla, codigo_error, mensaje_error) VALUES ('citas', v_codigo, v_mensaje);
        SELECT 'Error al eliminar cita' AS resultado;
    END;

    DELETE FROM citas WHERE idcita = p_idcita;
    SELECT 'Cita eliminado correctamente' AS resultado;
END//
DELIMITER ;