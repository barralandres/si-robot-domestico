pos(fridge, 0, 0).
pos(delivery, 0, 10).
pos(baseRPedidos, 3, 10).

!reponerNevera.

// Funcionalidad de comprar más cervezas -----------------------------
+!reponerNevera : delivered(Producto, Tipo, Qtd, OrderId, Supermercado)[source(rmayordomo)]
   <- !mover(delivery);
      !recogerPedidos;
      .println("El robot de pedidos recoge los pedidos en la zona de entrega");
      !mover(fridge);
      !reponerPedidos;
      .println("El robot de pedidos repone las existencias de la nevera");
      !mover(baseRPedidos);
      !reponerNevera.

+!recogerPedidos : delivered(Producto, Tipo, Qtd, OrderId, Supermercado)[source(rmayordomo)]
   <- .println("El robot de pedidos va a pagar");
      ?dinero(OrderId, Supermercado, Total);
      .send(Supermercado, tell, pagoRealizado(Producto, Tipo, Qtd, Total, OrderId));
      .concat("the order has been delivered: ", Qtd, " ",  Producto, " - ", Tipo, Ms);
	   .send(Supermercado, tell, msg(Ms));
      -dinero(OrderId, Supermercado, _)[source(rmayordomo)];
      .println("El robot de pedidos va a coger el pedido");
      getDeliver(Producto, Tipo, Qtd);
      .abolish(delivered(Producto, Tipo,Qtd, OrderId, Supermercado));
      !recogerPedidos.
+!recogerPedidos.

+!reponerPedidos : posesion(Producto, Tipo, Cant)
  <-  reponer(Producto, Tipo, Cant);
      .send(rmayordomo, tell, available(Producto, Tipo, Cant));
      !reponerPedidos.
+!reponerPedidos. 

+!reponerNevera : true
   <- .wait(1000);
      !reponerNevera.
// ------------------------------------------------------------------

// Movimiento --------------------------------
+!mover(Loc) : true
  <-  ?pos(Loc, X, Y);
      !mover(Loc, X, Y).

+!mover(Loc, X, Y) : at(Loc).

+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX < X & AY < Y
   <- !moverDerecha(X, Y);
      !moverAbajo(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX < X & AY > Y
   <- !moverDerecha(X, Y);
      !moverArriba(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX > X & AY < Y
   <- !moverIzquierda(X, Y);
      !moverAbajo(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX > X & AY > Y
   <- !moverIzquierda(X, Y);
      !moverArriba(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX < X & AY == Y
   <- !moverDerecha(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX == X & AY > Y
   <- !moverArriba(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX > X & AY == Y
   <- !moverIzquierda(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   :  posActual(AX, AY) & AX == X & AY < Y
   <- !moverAbajo(X, Y);
      !mover(Loc, X, Y).
+!mover(Loc, X, Y)
   <- .wait(100);
      !mover(Loc, X, Y).

+!moverDerecha(X, Y)
   :  posActual(AX, AY) & not obstaculo(AX+1, AY)
   <- mover(Loc, AX+1, AY).
+!moverDerecha(X, Y)
   :  posActual(AX, AY) & AX < X & AY == Y & not obstaculo(AX, AY-1)
   <- !moverArriba(X, Y);
      !moverDerecha(X, Y).
+!moverDerecha(X, Y)
   :  posActual(AX, AY) & AX < X & AY == Y & not obstaculo(AX, AY+1)
   <- !moverAbajo(X, Y);
      !moverDerecha(X, Y).
+!moverDerecha(X, Y).

+!moverIzquierda(X, Y)
   :  posActual(AX, AY) & not obstaculo(AX-1, AY)
   <- mover(Loc, AX-1, AY).
+!moverIzquierda(X, Y)
   :  posActual(AX, AY) & AX > X & AY == Y & not obstaculo(AX, AY-1)
   <- !moverArriba(X, Y);
      !moverIzquierda(X, Y).
+!moverIzquierda(X, Y)
   :  posActual(AX, AY) & AX > X & AY == Y & not obstaculo(AX, AY+1)
   <- !moverAbajo(X, Y);
      !moverIzquierda(X, Y).
+!moverIzquierda(X, Y).

+!moverArriba(X, Y)
   :  posActual(AX, AY) & not obstaculo(AX, AY-1)
   <- mover(Loc, AX, AY-1).
+!moverArriba(X, Y)
   :  posActual(AX, AY) & AX == X & AY > Y & not obstaculo(AX+1, AY)
   <- !moverDerecha(X, Y);
      !moverArriba(X, Y).
+!moverArriba(X, Y)
   :  posActual(AX, AY) & AX == X & AY > Y & not obstaculo(AX-1, AY)
   <- !moverIzquierda(X, Y);
      !moverArriba(X, Y).
+!moverArriba(X, Y).

+!moverAbajo(X, Y)
   :  posActual(AX, AY) & not obstaculo(AX, AY+1)
   <- mover(Loc, AX, AY+1).
+!moverAbajo(X, Y)
   :  posActual(AX, AY) & AX == X & AY < Y & not obstaculo(AX-1, AY)
   <- !moverIzquierda(X, Y);
      !moverAbajo(X, Y).
+!moverAbajo(X, Y)
   :  posActual(AX, AY) & AX == X & AY < Y & not obstaculo(AX+1, AY)
   <- !moverDerecha(X, Y);
      !moverAbajo(X, Y).
+!moverAbajo(X, Y).
// -------------------------------------------  

// Mensajes -----------------------------
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// --------------------------------------