DELIMITER //
CREATE FUNCTION fn_doctores_por_especialidad(p_idespecialidad VARCHAR(6))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('medicos',v_codigo,v_mensaje);
        RETURN -1;
    END;

    SELECT COUNT(*) INTO total FROM medicos WHERE idespecialidad = p_idespecialidad;
    RETURN total;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_pacientes_por_medico(p_idmedico VARCHAR(6))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('citas',v_codigo,v_mensaje);
        RETURN -1;
    END;

    SELECT COUNT(DISTINCT idpaciente) INTO total FROM citas WHERE idmedico = p_idmedico;
    RETURN total;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_pacientes_por_sede(p_idhospital VARCHAR(6))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_mensaje TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = RETURNED_SQLSTATE,
            v_mensaje = MESSAGE_TEXT;

        INSERT INTO log_errores(nombre_tabla,codigo_error,mensaje_error) VALUES ('citas',v_codigo,v_mensaje);
        RETURN -1;
    END;

    SELECT COUNT(DISTINCT idpaciente) INTO total FROM citas WHERE idhospital = p_idhospital;
    RETURN total;
END//
DELIMITER ;