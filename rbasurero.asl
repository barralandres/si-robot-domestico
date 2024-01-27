
pos(bin, 10, 0).
pos(baseRBasurero, 8, 0).

// Funcionalidad de vaciar el cubo de basura --------------
+papelera_llena [source(rmayordomo)]: true
    <-   .println("El robot basurero se enciende y va a la papelera");
         encender(rbasurero);
         !mover(bin);
         vaciar(bin);
         .println("El robot basurero ha terminado y vuelve");
         !mover(baseRBasurero);
         .abolish(papelera_llena);
         .send(rmayordomo, tell, papelera_vacia);
         apagar(rbasurero).
// --------------------------------------------------------

// Movimiento ---------------------------------
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
// --------------------------------------------

// Mensajes ------------------------------
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// ---------------------------------