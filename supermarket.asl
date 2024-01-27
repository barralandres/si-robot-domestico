// Creencias iniciales ----------------------------------------------------
last_order_id(1). // Creencia inicial de ID de pedido
stock(beer, estrella, 4).
stock(beer, mahou, 2).
stock(comida, tortilla, 1).
stock(comida, empanada, 0).
// ------------------------------------------------------------------------

// Objetivos iniciales -------------------------------------------------
!generacionDineroAleatoria.
!enviarPrecio(beer, estrella).
!enviarPrecio(beer, mahou).
!enviarPrecio(comida, tortilla).
!enviarPrecio(comida, empanada).
// ---------------------------------------------------------------------

// Funcionalidad de gestion de precios -----------
+!enviarPrecio(Producto, Tipo) : price(Producto, Tipo, Precio)
  <-  .println("Envío de precio al robot mayordomo");
      .send(rmayordomo, tell, price(Producto, Tipo, Precio)).
+!enviarPrecio(Producto, Tipo) : true
   <- .println("No hay datos sobre los precios de ", Producto, " - ", Tipo).

+!actualizarPrecio(Solicitante, Producto, Tipo) : price(Producto, Tipo, Precio)
   <- .send(Solicitante, untell, price(Producto, Tipo, Precio));
      .send(Solicitante, tell, price(Producto, Tipo, Precio));
      .println("Actualizacion del precio de ", Producto, "-", Tipo, " para ", Solicitante).

+!solicitarPrecio(Producto, Tipo)
   <- .send(proveedor, achieve, enviarPrecio(Producto, Tipo));
      .print("Solicito el precio de ", Producto, "-", Tipo, " al proveedor").
// ---------------------------------------------------------------

+!order(Producto, Tipo, Qtd) [source(rmayordomo)]
   <- ?last_order_id(N);
      OrderId = N + 1;
      -+last_order_id(OrderId);
      .println("Ha llegado una orden de ", Producto,"-", Tipo, " de ", Qtd, " unidades");
      !gestionarEnvio(OrderId, Producto, Tipo, Qtd, rmayordomo).

+!gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante) : stock(Product, Tipo, P) & P >= Qtd
   <- -stock(Producto, Tipo, _);
     +stock(Producto, Tipo, P-Qtd);
     deliver(Producto, Tipo, Qtd);
     .send(Solicitante, tell, delivered(Producto, Tipo, Qtd,OrderId));
     .println("Se ha realizado la entrega de ", Producto,"-", Tipo, " de ", Qtd, " unidades");
     ?price(Producto, Tipo, PrecioAnterior);
     -price(Producto, Tipo, _);
     +price(Producto, Tipo, PrecioAnterior+5);
     !actualizarPrecio(Solicitante, Producto, Tipo).

+!gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante)
   :  stock(Producto, Tipo, Cant) & Cant < Qtd &
      not sinStock(proveedor, Producto, Tipo) &
      not envioSolicitado(OrderId) &
      not dineroInsuficiente
   <- !solicitarPrecio(Producto, Tipo);
      !realizarPedido(OrderId, Producto, Tipo, Qtd+2);
      !gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante).

+!gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante) 
      :  sinStock(proveedor, Producto, Tipo)
         | dineroInsuficiente 
         | entrega(_, OrderId, Producto, Tipo, _, _)
  <-  .println("No queda stock de ", Producto, "-", Tipo);
      ?stock(Producto, Tipo, Cant);
     .send(Solicitante, tell, not_enough_stock(Producto, Tipo, Qtd, Cant));
     .println("Se comunica la ausencia de stock ",Producto, "-", Tipo," al robot mayordomo");
     !comprobarReservado(OrderId).

+!gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante) : true
   <- .wait(100);
      !gestionarEnvio(OrderId, Producto, Tipo, Qtd, Solicitante).

+!realizarPedido(OrderId, Producto, Tipo, 0)
   <- +dineroInsuficiente;
      .println("No tengo dinero suficiente para comprar existencias").
+!realizarPedido(OrderId, Producto, Tipo, Qtd) 
   :  dinero(M) & price(Producto, Tipo, Precio)[source(proveedor)] & M >= Qtd*Precio
   <- .send(proveedor, tell, enviar(OrderId, Producto, Tipo, Qtd));
      -+dinero(M-Qtd*Precio);
      +dineroReservado(OrderId, Qtd*Precio);
      +envioSolicitado(OrderId);
      .println("Se ha solicitado un envio al proveedor").
+!realizarPedido(OrderId, Producto, Tipo, Qtd) : true
   <- !realizarPedido(OrderId, Producto, Tipo, Qtd-1).

+entrega(OrderIdProveedor, OrderIdSuper, Producto, Tipo, Cantidad, Precio)
   <- -stock(Producto, Tipo, _);
      +stock(Producto, Tipo, Cantidad);
      ?dineroReservado(OrderIdSuper, DReservado);
      -dineroReservado(OrderIdSuper, _);
      +dineroReservado(OrderIdSuper, DReservado-Precio);
      !comprobarReservado(OrderIdSuper);
      .println("Se ha realizado una entrega de ",Producto, "-", Tipo, " por parte del proveedor");
      .send(proveedor, tell, pagoRealizado(Producto, Tipo, Cantidad, Precio, OrderIdProveedor));
      .println("Se ha realizado el pago de", Producto, "-", Tipo).

+!comprobarReservado(OrderId)
   : dineroReservado(OrderId, Dinero) & Dinero > 0
   <- ?dinero(Cantidad);
      -+dinero(Cantidad+Dinero);
      -dineroReservado(OrderId, _).
+!comprobarReservado(OrderId).

// -----------------------------------------------------------

// Funcionalidad de gestion de dinero --------------------------------
+!generacionDineroAleatoria
   <- .random([20,25,30,35,40,45,50], Dinero);
      +dinero(Dinero);
      .println("Generación de dinero aleatoriamente").

+dinero(_) : true
   <- -dineroInsuficiente.
// -------------------------------------------------

// Mensajes ----------------------------
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// -------------------------------------