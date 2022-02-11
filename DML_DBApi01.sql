USE api01;

-- ------------------------------------------------------------
-- INSERCIÓN DE DATOS PERSISTENTES
-- ------------------------------------------------------------
INSERT INTO api01.Tipo_Producto(tipo) VALUES
('comestible'), ('golosina y botana'), ('aseo y limpieza'),
('higiene y cuidado'), ('bebida'), ('perecedero'), ('mascota');

INSERT INTO api01.Presenta_Producto(presenta) VALUES
('caja'), ('bolsa'), ('botella'), ('lata'), ('paquete'), ('bote'),
('frasco'), ('tetrapack');

INSERT INTO api01.Concepto(Concepto) VALUES
('ENTRADA'), ('SALIDA');

INSERT INTO api01.Tipo_Usuario (tipoUser) VALUES
('admin'), ('normal');

-- QUERY PARA LA INSERCIÓN DE USUARIOS - SOLO EL USUARIO ADMINISTRADOR (admin) TENDRÁ ACCESO AL CRUD SOBRE LOS USUARIOS
INSERT INTO api01.Usuario (userName, pass, tipoUser_fk) VALUES
('Vogel', '123456', 1), ('Conejito', '12345678', 2), ('Conejita', '12345678', 2);

-- QUERY PARA MOSTRAR LA LISTA COMPLETA DE USUARIOS (SOLO EL USUARIO admin)
SELECT * FROM api01.Usuario;

-- QUERY PARA LA ACTUALIZACIÓN DE USUARIOS (SOLO EL USUARIO admin)
UPDATE api01.Usuario SET userName = 'Marmota' WHERE idUsuario = 1003;

-- QUERY PARA BORRAR A UN USUARIO (SOLO EL USUARIO admin)
DELETE FROM api01.Usuario WHERE idUsuario = 1003;

-- ----------------------------------------------------
-- REGISTRO DE PRODUCTOS (CUALQUIER USUARIO)
-- ----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_RegProds;
DELIMITER |
CREATE PROCEDURE sp_RegProds
(IN usr INT, IN nom VARCHAR(45), IN marc VARCHAR(45), IN con INT, IN tip INT, IN pres INT, IN priceIn DECIMAL(10,2), IN priceOut DECIMAL(10,2))
COMMENT 'Procedimiento para el registro de productos junto con su respectivo precio'
BEGIN
	/* VARIABLES LOCALES */
    /* Para guardar el índice del último producto registrado */
	DECLARE lastProdIndex INT;
    /* Para guardar el índice del precio de entrada que coincida con el ingresado como parámetro */
    DECLARE lastPriceIn INT;
    /* Para guardar el índice del precio de salida que coincida con el ingresado como parámetro */
    DECLARE lastPriceOut INT;
    /* Se inserta el nombre, marca, contenido, índice del tipo e índice de presentación del producto */
	INSERT INTO api01.Producto (nombre, marca, cont, idTipo_fk, idPresenta_fk) VALUES
    (nom, marc, con, tip, pres);
    /* Se obtiene el índice de este último registro y se le asigna a la variable */
    SELECT MAX(idProducto) INTO lastProdIndex FROM api01.Producto;
    /* Se insertan los precios de entrada y salida en caso de no existir, de otra manera no se insertan */
    INSERT INTO api01.Precio (precio)
    SELECT priceIn FROM dual
    WHERE NOT EXISTS(
		SELECT NULL FROM api01.Precio
        WHERE precio = priceIn);
    INSERT INTO api01.Precio (precio)
    SELECT priceOut FROM dual
    WHERE NOT EXISTS(
		SELECT NULL FROM api01.Precio
        WHERE precio = priceOut);
    /* Se recupera el índice del precio de entrada (insertado o no) y se asigna a la variable */
    SELECT idPrecio INTO lastPriceIn FROM api01.Precio WHERE precio = priceIn;
    /* Se recupera el índice del precio de salida (insertado o no) y se asigna a la variable */
    SELECT idPrecio INTO lastPriceout FROM api01.Precio WHERE precio = priceOut;
    /* Se realiza la inserción por duplicado en la tabla Producto_has_Precios, teniendo en cuenta que un registro es para el precio
	* de entrada y otro para el precio de salida */
    INSERT INTO api01.Producto_has_Precios (idProducto_fk, idPrecio_fk, fechPrecio, idConcepto_fk, idUser_fk) VALUES
    (lastProdIndex, lastPriceIn, CURDATE(), 1, usr), (lastProdIndex, lastPriceOut, CURDATE(), 2, usr);
END |
DELIMITER ;

/* Llamadas al store procedure para insertar productos */
CALL sp_RegProds(1001, 'frijoles', 'La Costeña', 490, 1, 4, 28.00, 29.50);
CALL sp_RegProds(1001, 'arroz', 'Verde Valle', 1000, 1, 2, 42.50, 48.00);
CALL sp_RegProds(1002, 'aceite', 'Nutrioli', 1000, 1, 3, 22.00, 24.50);
CALL sp_RegProds(1002, 'detergente en polvo', 'Blanca Nieves', 500, 3, 2, 15.00, 17.50);
CALL sp_RegProds(1002, 'shampoo', 'Sedal', 380, 4, 3, 24.50, 32.50);
CALL sp_RegProds(1002, 'jugo de mango', 'Jumex', 500, 5, 8, 17.50, 21.50);

/* PARA REGISTRAR UN MOVIMIENTO PRIMERO SE DEBE REGISTRAR EL MOVIMIENTO EN LA TABLA api01.Movimiento,
* DESPUÉS SE REGISTRA LA RELACIÓN ENTRE EL MOVIMIENTO Y EL USUARIO EN api01.User_has_Movimiento,
* LUEGO SE DEBEN REGISTRAR LOS PRODUCTOS COMPRADOS EN EL MOVIMIENTO EN api01.Movimiento_has_Producto
* Y FINALMENTE REGISTRAR EL INCREMENTO DE EXISTENCIAS EN LA TABLA api01.Usuario_has_Producto */

-- ----------------------------------------------------
-- REGISTRO DE MOVIMIENTOS (CUALQUIER USUARIO)
-- ----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_RegMov;
DELIMITER |
CREATE PROCEDURE sp_RegMov
(IN usr INT, IN typeMov INT)
COMMENT 'Procedimiento para el registro del movimiento de entrada (compra)'
BEGIN
	DECLARE lastMov INT;
    INSERT INTO api01.Movimiento (fechaMov, idConcepto_fk) VALUES
	(CURDATE(), typeMov);
    /* Se obtiene el índice de este último registro y se le asigna a la variable */
    SELECT MAX(idMov) INTO lastMov FROM api01.Movimiento;
    /* Se inserta la relación entre el movimiento y el usuario */
    INSERT INTO api01.Usuario_has_Movimiento (idUsuario_fk, idMov_fk) VALUES
	(usr, lastMov);
    IF typeMov = 1 THEN
    /* ESTA PARTE DEBE SER OPTIMIZADA PARA QUE LAS INSERCIONES SE REALICEN DE UNA TABLA DINÁMICA
    * La idea es que desde el FRONT se establezca un objeto "carrito" que sea un arrayList de objetos
    * "item", este último que tenga como atributos id y cantidad, así esos serán los datos que se 
    * recibirán para la inserción en este último rubro */
		CALL sp_RegMovIn(usr, lastMov, 2005, 1);
		CALL sp_RegMovIn(usr, lastMov, 2002, 1);
		CALL sp_RegMovIn(usr, lastMov, 2006, 1);
		CALL sp_RegMovIn(usr, lastMov, 2001, 1);
		CALL sp_RegMovIn(usr, lastMov, 2004, 1);
		CALL sp_RegMovIn(usr, lastMov, 2003, 1);
	ELSE
		CALL sp_RegMovOut(usr, lastMov, 2006, 4);
	END IF;
   
END |
DELIMITER ;

/* Llamadas al store procedure para insertar movimientos */
-- Un movimiento de entrada (compra)
CALL sp_RegMov(1002, 1);
-- Un movimiento de salida (venta)
CALL sp_RegMov(1002, 2);

DROP PROCEDURE IF EXISTS sp_RegMovIn;
DELIMITER |
CREATE PROCEDURE sp_RegMovIn
(IN usr INT, IN mov INT, IN prod INT, IN cant INT)
COMMENT 'Procedimiento para el registro de productos en relación al movimiento de entrada (compra) y al usuario'
BEGIN
	/* Se inserta el registro de relación movimiento-producto-cantidad */
	INSERT INTO api01.Movimiento_has_Productos (idMov_fk, idProducto_fk, cant) VALUES
	(mov,  prod, cant);
    /* Se verifica que no exista el registro de relación entre usuario y producto, si en efecto no existe, 
    * se insserta el registro, si por el contrario ya existe, solo se actualiza la cantidad en stock del
    * producto para ese usuario */
    IF NOT EXISTS (SELECT * FROM api01.Usuario_has_Productos WHERE idUsuario_fk = usr AND idProducto_fk = prod) THEN
		INSERT INTO api01.Usuario_has_Productos (idUsuario_fk, idProducto_fk, existencia) VALUES
		(usr, prod, cant);
        ELSE UPDATE api01.Usuario_has_Productos SET existencia = existencia + cant WHERE idUsuario_fk = usr AND idProducto_fk = prod;
	END IF;
   
END |
DELIMITER ;

/* PARA LOS MOVIMIENTOS DE SALIDA, PRIMERO SE DEBE VERIFICAR QUE EL USUARIO TENGA RELACIÓN CON EL PRODUCTO, 
* DESPUÉS SE VERIFICA LA CONDICIÓN DE EXISTENCIA DEL PRODUCTO, ES DECIR; SI cant > 0 & cant < cantSal
* EN CASO DE VALIDACIÓN ENTONCES SE REALIZA EL REGISTRO DEL MOVIMIENTO Y LA ACTUALIZACIÓN DE LA CANTIDAD */

DROP PROCEDURE IF EXISTS sp_RegMovOut;
DELIMITER |
CREATE PROCEDURE sp_RegMovOut
(IN usr INT, IN mov INT, IN prod INT, IN cant INT)
COMMENT 'Procedimiento para el registro de productos en relación al movimiento de salida (venta) y al usuario'
BEGIN
	DECLARE stock INT;
	IF EXISTS (SELECT * FROM api01.Usuario_has_Productos WHERE idUsuario_fk = usr AND idProducto_fk = prod) THEN
		SELECT existencia INTO stock FROM api01.Usuario_has_Productos WHERE idUsuario_fk = usr AND idProducto_fk = prod;
		IF stock > 0 AND stock >= cant THEN
			UPDATE api01.Usuario_has_Productos SET existencia = existencia - cant WHERE idUsuario_fk = usr AND idProducto_fk = prod;
		END IF;
	END IF;
	/* Se inserta el registro de relación movimiento-producto-cantidad */
	INSERT INTO api01.Movimiento_has_Productos (idMov_fk, idProducto_fk, cant) VALUES
	(mov,  prod, cant);
   
END |
DELIMITER ;

-- CONSULTAS PARA LOS DATOS INSERTADOS
SELECT * FROM Tipo_Producto;
SELECT * FROM Presenta_Producto;
SELECT * FROM Concepto;
SELECT * FROM Tipo_Usuario;
SELECT * FROM Usuario;
SELECT * FROM Precio ORDER BY idPrecio;
SELECT * FROM api01.Movimiento;
SELECT * FROM api01.Usuario_has_Movimiento;
SELECT * FROM api01.Movimiento_has_Productos;
 SELECT * FROM api01.Usuario_has_Productos;

-- QUERY PARA LISTAR LOS PRODUCTOS REGISTRADOS
SELECT (t1.idProducto)id, (t1.nombre)Descripcion, (t1.marca)Marca, (t1.cont)Contenido, (t2.tipo)Tipo, (t3.presenta)Presentacion
FROM api01.Producto AS t1
LEFT JOIN api01.Tipo_Producto AS t2 ON t2.idTipo = t1.idTipo_fk
LEFT JOIN api01.Presenta_Producto AS t3 ON t3.idPresenta = t1.idPresenta_fk;

-- QUERY PARA LISTAR LOS PRODUCTOS EN RELACIÓN A SU PRECIO Y USUARIO
SELECT (t1.idProducto_fk)id, (t2.nombre)Descripcion, (t3.precio)Precio, (t1.fechPrecio)Fecha, (t4.concepto)Concepto, (t5.userName)Usuario
FROM api01.Producto_has_Precios AS t1
LEFT JOIN api01.Producto AS t2 ON t2.idProducto = t1.idProducto_fk
LEFT JOIN api01.Precio AS t3 ON t3.idPrecio = t1.idPrecio_fk
LEFT JOIN api01.Concepto AS t4 ON t4.idConcepto = t1.idConcepto_fk
LEFT JOIN api01.Usuario AS t5 ON t5.idUsuario = t1.idUser_fk;