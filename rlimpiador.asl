// Creencias iniciales ------------------------------------------
trash(can, 0). // Creencia de basura que posee el robot limpiador

pos(bin, 10, 0).
pos(owner1, 10, 10).
pos(owner2, 6, 10).
pos(baseRLimpiador, 0, 5).
// --------------------------------------------------------------

// Funcionalidad de limpiar el entorno -------------------------
!limpiar.

+!limpiar : hayBasura
   <- !recoger(trash);
      .println("El robot limpiador desecha la basura");
      !tirar(trash, bin);
      .send(rmayordomo, achieve, limpiezaTerminada);
      .abolish(hayBasura);
      !limpiar.
+!limpiar : ownerTrash(Owner, Elem, Cantidad)
   <- !mover(Owner);
      ?trash(Elem, C);
      -trash(Elem, C);
      +trash(Elem, C+Cantidad);
      .send(Owner, tell, basuraRecogida);
      !tirar(trash, bin);
      .abolish(ownerTrash(Owner, Elem, Cantidad));
      !limpiar.
+!limpiar : true
   <- !mover(baseRLimpiador);
      .wait(1000);
      !limpiar.

+!recoger(trash) : trashInEnv(T) & T > 0
   <- .println("El robot limpiador va a buscar basura");
      !mover(trash);
      .println("El robot limpiador recoge basura");
      pick(trash);
      ?trash(can, C);
      -+trash(can, C+1);
      !recoger(trash).
+!recoger(trash).

+!tirar(trash, bin): trash(can, X) & X>0
   <- !mover(bin);
      !desechar(trash).
+!tirar(trash, bin).

+!desechar(trash) : trash(can, X) & X>0 & trashInBin(CTrash) & CTrash < 3
   <- desechar(trash);
      -+trash(can, X-1);
      .println("Basura desechada");
      !desechar(trash).
+!desechar(trash) : trash(can, X) & X>0 & trashInBin(CTrash) & CTrash == 3
   <- .wait(100);
      !desechar(trash).
+!desechar(trash).
// ------------------------------------------------------------

// Funcionalidad de vaciar el cubo de basura --------------
+trashInBin(X) : X>=3
   <- .println("El robot limpiador ve la papelera llena");
      .send(rmayordomo, tell, papelera_llena).
// --------------------------------------------------------

// Movimiento ------------------------------------
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
// ------------------------------------------------

// Mensajes -----------------------------
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// --------------------------------------