last_order_id(1).

stock(beer, estrella, 8).
stock(beer, mahou, 4).
stock(comida, tortilla, 2).
stock(comida, empanada, 1).

dinero(0).

!generacionPreciosAleatorios.
!enviar.


// Funcionalidad de generar precios aleatorios
+!generacionPreciosAleatorios : true
    <-  .println("El proveedor genera precios aleatorios");
        .random([1,2,3,4,5,6,7,8,9,10], PBE);
        +price(beer, estrella, PBE);
        .random([1,2,3,4,5,6,7,8,9,10], PBM);
        +price(beer, mahou, PBM);
        .random([1,2,3,4,5,6,7,8,9,10], PCT);
        +price(comida, tortilla, PCT);
        .random([1,2,3,4,5,6,7,8,9,10], PCE);
        +price(comida, empanada, PCE).
// --------------------------------------------

// FUncionalidad de enviar dinero al supermercado ----------------------------------
+!enviarPrecio(Producto, Tipo) [source(Supermercado)] : price(Producto, Tipo, Precio)
    <-  .send(Supermercado, tell, price(Producto, Tipo, Precio));
        .println("El proveedor envió el precio de ", Producto, " - ", Tipo, " a ", Supermercado).
// ---------------------------------------------------------------------------------

// FUncionalidad de enviar productos a los supermercados ---------------------------
+!enviar : enviar(OrderIdSuper, Producto, Tipo, Cantidad)[source(Supermercado)]
    <-  !realizarEnvio(OrderIdSuper, Producto, Tipo, Cantidad, Supermercado);
        -enviar(OrderIdSuper, Producto, Tipo, Cantidad)[source(Supermercado)];
        !enviar.
+!enviar : true
    <-  .wait(1000);
        !enviar.

+!realizarEnvio(OrderIdSuper, Producto, Tipo, 0, Supermercado)
    <-  .concat("Nos hemos quedado sin existencia para el producto: ", Producto, " - ", Tipo, M);
        .println("El proveedor se ha quedado sin existencias de ", Producto, " - ", Tipo);
        .send(Supermercado, tell, msg(M));
        .send(Supermercado, tell, sinStock(proveedor, Producto, Tipo)).

+!realizarEnvio(OrderIdSuper, Producto, Tipo, Cantidad, Supermercado)
    :   stock(Producto, Tipo, CantAlmacenada) &
        Cantidad <= CantAlmacenada
    <-  ?last_order_id(N);
        OrderId = N + 1;
        -+last_order_id(OrderId);
        ?price(Producto, Tipo, Precio);
        .println("El proveedor realiza la entrega de ", Producto, "(",Cantidad,") - ", Tipo, " a ", Supermercado);
        .send(Supermercado, tell, entrega(OrderId, OrderIdSuper, Producto, Tipo, Cantidad, Cantidad*Precio));
        -stock(Producto, Tipo, _);
        +stock(Producto, Tipo, CantAlmacenada-Cantidad).

+!realizarEnvio(OrderIdSuper, Producto, Tipo, Cantidad, Supermercado) : true
    <- !realizarEnvio(OrderIdSuper, Producto, Tipo, Cantidad-1, Supermercado).
// ------------------------------------------------------------------------------------------------------------

// Gestión de recibimiendo del pago por los productos ---------
+pagoRealizado(Producto, Tipo, Cantidad, Total, Id) [source(Supermercado)] : true
    <-  .println("El proveedor ha recivido el pago ", Total," de ", Producto,"-",Tipo, " de ", Supermercado);
        ?dinero(X);
        -+dinero(X+Total);
        ?price(Producto, Tipo, Precio);
        -price(Producto, Tipo, _);
        +price(Producto, Tipo, Precio+5).
// ------------------------------------------------------------
