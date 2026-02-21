INSERT INTO pacientes (idpaciente, nombre_paciente, apellido_paciente, telefono_paciente) VALUES ('P-501', 'Juan', 'Rivas', 600111);
INSERT INTO pacientes (idpaciente, nombre_paciente, apellido_paciente, telefono_paciente) VALUES ('P-502', 'Ana', 'Soto', 600222);
INSERT INTO pacientes (idpaciente, nombre_paciente, apellido_paciente, telefono_paciente) VALUES ('P-503', 'Luis', 'Paz', 600333);

INSERT INTO facultades (idfacultad, nombre_facultad, decano_facultad) VALUES ('F01', 'Medicina', 'Dr. Wilson');
INSERT INTO facultades (idfacultad, nombre_facultad, decano_facultad) VALUES ('F02', 'Ciencias', 'Dr. Palmer');

INSERT INTO especialidades (idespecialidad, especialidad) VALUES ('E01', 'Infectología');
INSERT INTO especialidades (idespecialidad, especialidad) VALUES ('E02', 'Cardiología');
INSERT INTO especialidades (idespecialidad, especialidad) VALUES ('E03', 'Neurología');

INSERT INTO medicos (idmedico, nombre_medico, idfacultad, idespecialidad) VALUES ('M-10', 'Dr. House', 'F01', 'E01');
INSERT INTO medicos (idmedico, nombre_medico, idfacultad, idespecialidad) VALUES ('M-22', 'Dr. Gray', 'F01', 'E02');
INSERT INTO medicos (idmedico, nombre_medico, idfacultad, idespecialidad) VALUES ('M-30', 'Dr. Strange', 'F02', 'E03');

INSERT INTO hospitales (idhospital, hospital, direccion) VALUES ('HS01', 'Centro Médico', 'Calle 5 #10');
INSERT INTO hospitales (idhospital, hospital, direccion) VALUES ('HS02', 'Clínica Norte', 'Av. Libertador');

INSERT INTO citas (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital) VALUES ('C-001','2024-05-10','Gripe Fuerte','M-10','P-501','HS01');
INSERT INTO citas (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital) VALUES ('C-002','2024-05-11','Infección','M-10','P-502','HS01');
INSERT INTO citas (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital) VALUES ('C-003','2024-05-12','Arritmia','M-22','P-501','HS02');
INSERT INTO citas (idcita, fecha_cita, diagnostico, idmedico, idpaciente, idhospital) VALUES ('C-004','2024-05-15','Migraña','M-30','P-503','HS02');

INSERT INTO medicamentos (idmedicamento, medicamento) VALUES ('M01','Ibuprofeno');
INSERT INTO medicamentos (idmedicamento, medicamento) VALUES ('M02','Paracetamol');
INSERT INTO medicamentos (idmedicamento, medicamento) VALUES ('M03','Amoxicilina');
INSERT INTO medicamentos (idmedicamento, medicamento) VALUES ('M04','Aspirina');
INSERT INTO medicamentos (idmedicamento, medicamento) VALUES ('M05','Ergotamina');

INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES ('R01', '400mg', 'M01', 'C-001');
INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES ('R02', '500mg', 'M02', 'C-001');
INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES ('R03', '875mg', 'M03', 'C-002');
INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES ('R04', '100mg', 'M04', 'C-003');
INSERT INTO recetas (idreceta, dosis, idmedicamento, idcita) VALUES ('R05', '1mg', 'M05', 'C-004');