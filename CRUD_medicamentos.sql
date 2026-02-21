DELIMITER //
CREATE PROCEDURE sp_medicamentos_create( IN p_idmedicamento VARCHAR(6), IN p_medicamento VARCHAR(45) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('medicamentos',v_codigo,v_mensaje);
        SELECT 'Error al crear medicamento' AS resultado;
    END;

    INSERT INTO medicamentos (idmedicamento, medicamento) VALUES (p_idmedicamento,p_medicamento);
    SELECT 'Medicamento creado correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_read( IN p_idmedicamento VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('medicamentos',v_codigo,v_mensaje);
        SELECT 'Error al consultar medicamento' AS resultado;
    END;

    SELECT * FROM medicamentos WHERE idmedicamento = p_idmedicamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_update( IN p_idmedicamento VARCHAR(6), IN p_medicamento VARCHAR(45))
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('medicamentos',v_codigo,v_mensaje);
        SELECT 'Error al actualizar medicamento' AS resultado;
    END;

    UPDATE medicamentos SET medicamento = p_medicamento WHERE idmedicamento = p_idmedicamento;
    SELECT 'Medicamento actualizado correctamente' AS resultado;

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_medicamentos_delete( IN p_idmedicamento VARCHAR(6) )
BEGIN
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('medicamentos',v_codigo,v_mensaje);
        SELECT 'Error al eliminar medicamento' AS resultado;
    END;

    DELETE FROM medicamentos WHERE idmedicamento = p_idmedicamento;
    SELECT 'Medicamento eliminado correctamente' AS resultado;

END//
DELIMITER ;