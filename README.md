# DBApi01

## Esquema inicial
El proyecto de DB inicia con un esquema inicial de una sola tabla para que a través de Spring se puedan realizar las tareas CRUD básicas desde un front en Angular.

![Alt text](imgs/DB-inicial.jpg?raw=true "Esquema de una sola tabla")

Como se puede observar, se partió de un esquema de una sola tabla para guardar los datos referentes a un conjunto de productos.

## Especificación de requerimientos y nuevo esquema
Una vez completada esta primer meta, se procedió a delimitar más el problema de acuerdo a las operaciones propias de un almacén, es decir; registro de productos, registro histórico de compra-venta de los mismos y registro histórico de precios.

Así, con el objetivo de dar solvencia a estos nuevos requerimientos, se elaboró un nuevo Modelo relacional para el nuevo esquema, el cual contempla aspectos más detallados para la gestión de un almacén que maneja un conjunto de productos con diversas características, pero que pueden ser agrupados en ciertas categorías bien definidas. También se contempla el registro de movimientos para el ingreso-salida (compra-venta) de productos, del almacen. Finalmente también se prevee un historial del precio de cada producto a lo largo del tiempo.

![Alt text](imgs/DB-NV-1.jpg?raw=true "Nuevo modelo")

Si bien el nuevo esquema parece funcional y se adapta a lo requerido en primera instancia, el registro de productos, de movimientos y precios se aprecia limitado a una única entidad, evitando la posibilidad de que el sistema estuviese abierto a otras entidades y por tanto abierto a ser alimentado por un mayor volumen de información. Por tanto, es necesario el manejo de perfiles de usuario considerando las siguientes premisas:

* Todos los usuarios puedan registrar productos.
* Todos los usuarios pueden consultar la lista general de productos registrados.
* Un usuario "normal" puede comprar uno o varios productos registrados o agregarlos al registro general.
* Un usuario “normal” puede tener o no productos en stock (los usuarios tienen productos).
* Un usuario “normal” puede tener o no movimientos registrados (los usuarios realizan movimientos compra/venta).
* Un usuario "normal" no puede editar los detalles de un producto una vez registrado, sólo sus precios de compra/venta al momento de adquirirlo.
* La existencia de un producto tendrá que ver con el usuario que halla accesado.
* El usuario "admin" tendrá acceso completo al sistema, pudiendo; registrar, consultar, editar o eliminar productos y/o usuarios, consultar los movimientos generales del sistema, de un producto o usuario en particular, también tendrá acceso a todas las estadísticas generadas por el sistema; movimientos de capital, productos de mayor/menor demanda, etc.

Así que se agrega e integra la tabla Usuario al modelo ya definido, teniendo en cuenta su relación con los productos y con los movimientos:

![Alt text](imgs/DB-NV-2.jpg?raw=true "Modelo para la gestión de perfiles de usuario")

El esquema anterior no contempla una relación usuario-precio teniendo en cuenta que:

* Un usuario podrá definir el precio de compra/venta de un producto al momento de registrarlo
* Un usuario podrá actualizar el precio de compra/venta de un producto al momento de agregarlo al carrito de compra

Es claro que esta relación existe y por tanto se debe ver reflejada en el esquema por lo que se agrega dicha relación en la tabla Producto_has_Precios:

![Alt text](imgs/DB-NV-3.jpg?raw=true "Modelo para la gestión de perfiles de usuario")


