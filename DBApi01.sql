-- -----------------------------------------------------
-- Schema api01
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS api01;
CREATE SCHEMA IF NOT EXISTS api01 DEFAULT CHARACTER SET utf8 ;
USE api01;
-- 1
-- -----------------------------------------------------
-- Table  api01.Tipo_Producto
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Tipo_Producto;
CREATE TABLE IF NOT EXISTS  api01.Tipo_Producto (
	idTipo INT NOT NULL AUTO_INCREMENT,
	tipo VARCHAR(60) NULL,
	PRIMARY KEY (idTipo))
ENGINE = InnoDB;

-- 2
-- -----------------------------------------------------
-- Table  api01.Presenta_Producto
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Presenta_Producto;
CREATE TABLE IF NOT EXISTS  api01.Presenta_Producto (
	idPresenta INT NOT NULL AUTO_INCREMENT,
	presenta VARCHAR(60) NULL,
	PRIMARY KEY (idPresenta))
ENGINE = InnoDB;

-- 3
-- -----------------------------------------------------
-- Table  api01.Precio
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Precio;
CREATE TABLE IF NOT EXISTS  api01.Precio (
	idPrecio INT NOT NULL AUTO_INCREMENT,
	precio DECIMAL(10,2) NULL,
	PRIMARY KEY (idPrecio))
ENGINE = InnoDB;

-- 4
-- -----------------------------------------------------
-- Table  api01.Producto 
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Producto;
CREATE TABLE IF NOT EXISTS  api01.Producto (
	idProducto INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(60) NULL,
    marca VARCHAR(60) NULL,
    cont INT NULL,
    exist INT NOT NULL DEFAULT 0,
    idTipo_fk INT NOT NULL,
    idPresenta_fk INT NOT NULL,
	PRIMARY KEY (idProducto),
    INDEX fk_Producto_Tipo1 (idTipo_fk ASC),
    INDEX fk_Producto_Presenta1 (idPresenta_fk ASC),
    CONSTRAINT fk_Producto_Tipo1
		FOREIGN KEY (idTipo_fk)
        REFERENCES api01.Tipo_Producto (idTipo)
        ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT fk_Producto_Presenta1
		FOREIGN KEY (idPresenta_fk)
        REFERENCES api01.Presenta_Producto (idPresenta)
        ON DELETE RESTRICT
		ON UPDATE CASCADE)
ENGINE = InnoDB;

ALTER TABLE api01.Producto AUTO_INCREMENT=1001;

-- 5
-- -----------------------------------------------------
-- Table  api01.Producto_has_Precios
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Producto_has_Precios;
CREATE TABLE IF NOT EXISTS  api01.Producto_has_Precios (
	idProducto_fk INT NOT NULL,
	idPrecio_fk INT NOT NULL,
    fechPrecio DATE NOT NULL,
	FOREIGN KEY (idProducto_fk)
    REFERENCES api01.producto (idProducto)
    ON DELETE RESTRICT
	ON UPDATE CASCADE,
    FOREIGN KEY (idPrecio_fk)
    REFERENCES api01.precio (idPrecio)
    ON DELETE RESTRICT
	ON UPDATE CASCADE)
ENGINE = InnoDB;

-- 6
-- -----------------------------------------------------
-- Table  api01.Tipo_Mov
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Tipo_Mov;
CREATE TABLE IF NOT EXISTS  api01.Tipo_Mov (
	idTipoMov INT NOT NULL AUTO_INCREMENT,
	tipoMov VARCHAR(60) NULL,
	PRIMARY KEY (idTipoMov))
ENGINE = InnoDB;

-- 7
-- -----------------------------------------------------
-- Table  api01.Movimiento
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Movimiento;
CREATE TABLE IF NOT EXISTS api01.Movimiento (
	idMov INT NOT NULL AUTO_INCREMENT,
    fechaMov DATE NOT NULL,
    tipoMov_fk INT,
    PRIMARY KEY (idMov),
    INDEX fk_Mov_Tipo_idx (tipoMov_fk ASC),
    CONSTRAINT fk_Mov_Tipo
		FOREIGN KEY (tipoMov_fk)
        REFERENCES api01.Tipo_Mov (idTipoMov)
        ON DELETE RESTRICT
		ON UPDATE CASCADE)
ENGINE = InnoDB;

ALTER TABLE api01.Movimiento AUTO_INCREMENT=2001;
    
-- 8
-- -----------------------------------------------------
-- Table  api01.Movimiento_has_Productos
-- -----------------------------------------------------
DROP TABLE IF EXISTS api01.Movimiento_has_Productos;
CREATE TABLE IF NOT EXISTS  api01.Movimiento_has_Productos (
	idMov_fk INT NOT NULL,
    idProducto_fk INT NOT NULL,
    FOREIGN KEY (idMov_fk)
    REFERENCES api01.Movimiento (idMov)
    ON DELETE RESTRICT
	ON UPDATE CASCADE,    
	FOREIGN KEY (idProducto_fk)
    REFERENCES api01.producto (idProducto)
    ON DELETE RESTRICT
	ON UPDATE CASCADE)
ENGINE = InnoDB;
