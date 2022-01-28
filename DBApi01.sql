-- -----------------------------------------------------
-- Schema api01
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS api01;
CREATE SCHEMA IF NOT EXISTS api01 DEFAULT CHARACTER SET utf8 ;
USE api01;
-- 1
-- -----------------------------------------------------
-- Table  api01.producto 
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.producto;
CREATE TABLE IF NOT EXISTS  api01.producto (
	id INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(60) NULL,
    marca VARCHAR(60) NULL,
    presenta VARCHAR(60) NULL,
    cant INT NULL,
	PRIMARY KEY (id))
ENGINE = InnoDB;

ALTER TABLE api01.producto AUTO_INCREMENT=1001;
