CREATE SCHEMA IF NOT EXISTS `clinica_universitaria` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`pacientes` (
  `idpaciente` VARCHAR(6) NOT NULL,
  `nombre_paciente` VARCHAR(45) NOT NULL,
  `apellido_paciente` VARCHAR(45) NOT NULL,
  `telefono_paciente` INT(11) NOT NULL,
  PRIMARY KEY (`idpaciente`),
  UNIQUE INDEX `telefono_paciente_UNIQUE` (`telefono_paciente` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`medicos` (
  `idmedico` VARCHAR(6) NOT NULL,
  `nombre_medico` VARCHAR(45) NOT NULL,
  `idfacultad` VARCHAR(6) NOT NULL,
  `idespecialidad` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`idmedico`),
  INDEX `fk_medicos_facultades_idx` (`idfacultad` ASC) VISIBLE,
  INDEX `fk_medicos_especialidades1_idx` (`idespecialidad` ASC) VISIBLE,
  CONSTRAINT `fk_medicos_facultades`
    FOREIGN KEY (`idfacultad`)
    REFERENCES `clinica_universitaria`.`facultades` (`idfacultad`),
  CONSTRAINT `fk_medicos_especialidades1`
    FOREIGN KEY (`idespecialidad`)
    REFERENCES `clinica_universitaria`.`especialidades` (`idespecialidad`));

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`facultades` (
  `idfacultad` VARCHAR(6) NOT NULL,
  `nombre_facultad` VARCHAR(45) NOT NULL,
  `decano_facultad` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idfacultad`),
  UNIQUE INDEX `nombre_facultad_UNIQUE` (`nombre_facultad` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`especialidades` (
  `idespecialidad` VARCHAR(6) NOT NULL,
  `especialidad` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idespecialidad`),
  UNIQUE INDEX `especialidad_UNIQUE` (`especialidad` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`citas` (
  `idcita` VARCHAR(6) NOT NULL,
  `fecha_cita` DATE NULL DEFAULT NULL,
  `diagnostico` VARCHAR(255) NULL DEFAULT NULL,
  `idmedico` VARCHAR(6) NOT NULL,
  `idpaciente` VARCHAR(6) NOT NULL,
  `idhospital` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`idcita`),
  INDEX `fk_citas_medicos1_idx` (`idmedico` ASC) VISIBLE,
  INDEX `fk_citas_pacientes1_idx` (`idpaciente` ASC) VISIBLE,
  INDEX `fk_citas_hospitales1_idx` (`idhospital` ASC) VISIBLE,
  CONSTRAINT `fk_citas_medicos1`
    FOREIGN KEY (`idmedico`)
    REFERENCES `clinica_universitaria`.`medicos` (`idmedico`),
  CONSTRAINT `fk_citas_pacientes1`
    FOREIGN KEY (`idpaciente`)
    REFERENCES `clinica_universitaria`.`pacientes` (`idpaciente`),
  CONSTRAINT `fk_citas_hospitales1`
    FOREIGN KEY (`idhospital`)
    REFERENCES `clinica_universitaria`.`hospitales` (`idhospital`));

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`hospitales` (
  `idhospital` VARCHAR(6) NOT NULL,
  `hospital` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idhospital`),
  UNIQUE INDEX `direccion_UNIQUE` (`direccion` ASC) VISIBLE,
  UNIQUE INDEX `hospital_UNIQUE` (`hospital` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`medicamentos` (
  `idmedicamento` VARCHAR(6) NOT NULL,
  `medicamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idmedicamento`),
  UNIQUE INDEX `medicamento_UNIQUE` (`medicamento` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `clinica_universitaria`.`recetas` (
  `idreceta` VARCHAR(6) NOT NULL,
  `dosis` VARCHAR(45) NOT NULL,
  `idmedicamento` VARCHAR(6) NOT NULL,
  `idcita` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`idreceta`),
  INDEX `fk_recetas_medicamentos1_idx` (`idmedicamento` ASC) VISIBLE,
  INDEX `fk_recetas_citas1_idx` (`idcita` ASC) VISIBLE,
  CONSTRAINT `fk_recetas_medicamentos1`
    FOREIGN KEY (`idmedicamento`)
    REFERENCES `clinica_universitaria`.`medicamentos` (`idmedicamento`),
  CONSTRAINT `fk_recetas_citas1`
    FOREIGN KEY (`idcita`)
    REFERENCES `clinica_universitaria`.`citas` (`idcita`));

CREATE TABLE IF NOT EXISTS log_errores (
    id_error INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tabla VARCHAR(50),
    codigo_error VARCHAR(10),
    mensaje_error TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS informe_diario (
    id_informe INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    hospital VARCHAR(45),
    medico VARCHAR(45),
    pacientes_atendidos INT
);