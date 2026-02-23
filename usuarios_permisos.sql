CREATE USER IF NOT EXISTS 'admin_clinica'@'localhost' IDENTIFIED BY 'Admin123!';
CREATE USER IF NOT EXISTS 'recepcion'@'localhost' IDENTIFIED BY 'Recepcion123!';
CREATE USER IF NOT EXISTS 'medico_user'@'localhost' IDENTIFIED BY 'Medico123!';
CREATE USER IF NOT EXISTS 'farmacia_user'@'localhost' IDENTIFIED BY 'Farmacia123!';
CREATE USER IF NOT EXISTS 'direccion_user'@'localhost' IDENTIFIED BY 'Direccion123!';
CREATE USER IF NOT EXISTS 'auditor_user'@'localhost' IDENTIFIED BY 'Auditor123!';
CREATE USER IF NOT EXISTS 'app_backend'@'localhost' IDENTIFIED BY 'App123!';

REVOKE ALL PRIVILEGES, GRANT OPTION 
FROM 'admin_clinica'@'localhost',
     'recepcion'@'localhost',
     'medico_user'@'localhost',
     'farmacia_user'@'localhost',
     'direccion_user'@'localhost',
     'auditor_user'@'localhost',
     'app_backend'@'localhost';

GRANT ALL PRIVILEGES 
ON clinica_universitaria.* 
TO 'admin_clinica'@'localhost';

GRANT SELECT, INSERT, UPDATE 
ON clinica_universitaria.pacientes 
TO 'recepcion'@'localhost';

GRANT SELECT, INSERT, UPDATE 
ON clinica_universitaria.citas 
TO 'recepcion'@'localhost';

GRANT SELECT 
ON clinica_universitaria.medicos 
TO 'recepcion'@'localhost';

GRANT SELECT 
ON clinica_universitaria.hospitales 
TO 'recepcion'@'localhost';

GRANT SELECT 
ON clinica_universitaria.pacientes 
TO 'medico_user'@'localhost';

GRANT SELECT, UPDATE 
ON clinica_universitaria.citas 
TO 'medico_user'@'localhost';

GRANT SELECT 
ON clinica_universitaria.medicamentos 
TO 'medico_user'@'localhost';

GRANT SELECT, INSERT 
ON clinica_universitaria.recetas 
TO 'medico_user'@'localhost';

GRANT SELECT 
ON clinica_universitaria.recetas 
TO 'farmacia_user'@'localhost';

GRANT SELECT, INSERT, UPDATE 
ON clinica_universitaria.medicamentos 
TO 'farmacia_user'@'localhost';

GRANT SELECT 
ON clinica_universitaria.* 
TO 'direccion_user'@'localhost';

GRANT SELECT 
ON clinica_universitaria.log_errores 
TO 'auditor_user'@'localhost';

GRANT EXECUTE 
ON clinica_universitaria.* 
TO 'app_backend'@'localhost';

FLUSH PRIVILEGES;
