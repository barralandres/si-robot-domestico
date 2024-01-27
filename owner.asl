// Creencis iniciales -------------------------------------
trash(can,0). // Creencia de basura que posee el owner
plato(0).
stock(beer, estrella, 4).
stock(beer, mahou, 3). 

pos(fridge, 0, 0).
pos(bin, 10, 0).
// --------------------------------------------------------

// Objetivos iniciales ------------------------------------------
!drink(beer). // Objetivo inicial de beber
!check_bored. // Objetivo inicial de aburrimiento
!darDinero(rmayordomo). // Objetivo inicial de dar dinero al robot mayordomo
// --------------------------------------------------------------

// Funcionalidad de dar dinero al robot mayordomo --------------------------------
+!darDinero(rmayordomo) : dinero(X)
   <- .println("El owner le da dinero al robot mayordomo");
      .send(rmayordomo, achieve, dinero(X));
      -dinero(X).
+!darDinero(rmayordomo) : true
   <- .println("El owner no tiene dinero que enviarle dinero al robot mayordomo");
      .concat("No tengo dinero para darte", M);
      .send(rmayordomo, tell, msg(M)).
// -------------------------------------------------------------------------------

// Funcionalidad de beber cerveza -----------------------------------
+!drink(beer) : not has(beer) & not asked(beer)
   <- .println("Owner no tiene cerveza.");
      !obtener(beer);
      !drink(beer).

+!drink(beer) : has(beer)
   <- .println("Owner ya tiene una cerveza y se dispone a beberla.");
      !consumir;
      !drink(beer).
      
+!drink(beer) : ~couldDrink(beer)
   <- .println("Owner ha bebido demasiado por hoy.").	

+!drink(beer) : not has(beer) & asked(beer)
   <- .println("Owner está esperando una cerveza.");
	   .wait(500);
	   !drink(beer).

+!obtener(beer) : true
   <- .random(X);
      if(X>0.7){
         .println("Owner va a coger una cerveza");
         !cogerCerveza(beer);
      } else{
         .println("Owner pide cerveza al robot mayordomo");
         !pedirCerveza(beer);
      }.
// -------------------------------------------------------------------

// Reglas para coger una cerveza -----------------------------------
+!cogerCerveza(beer) : true
   <- .println("Owner va a coger una cerveza.");
      !mover(fridge);
      open(fridge);
      .wait(100);
      !get(beer).
// -----------------------------------------------------------------

// Reglas para pedir una cerveza -------------------------------------
+!pedirCerveza(beer) : not asked(beer)
   <- .send(rmayordomo, tell, asked(beer));
      .println("Owner ha pedido una cerveza al robot mayordomo.");
      +asked(beer).

+!get(beer) : stock(beer, Tipo, Cant) & Cant>0
   <- .println("Owner coge una cerveza");
      get(beer, Tipo);
      close(fridge);
      !mover(couch);
      entrega(beer).

+!get(beer) : true
   <- .println("Owner se encuentra la nevera vacía");
      close(fridge);
      !mover(couch);
      .send(rmayordomo, tell, available(beer, estrella, 0));
      .send(rmayordomo, tell, available(beer, mahou, 0));
      .wait(5000).
// -------------------------------------------------------------------

// Actualización de conocimiento del contenido de la nevera ----------
+available(Producto, Tipo, Cant)[source(percept)] 
   : stock(Producto, Tipo, CantAnterior) & not (Cant == CantAnterior)
   <- -stock(Producto, Tipo, _);
      +stock(Producto, Tipo, Cant).
// -------------------------------------------------------------------

// Reglas para tomar la cerveza y el pincho --------------------------
+!consumir : not has(_) & lata
   <- ?trash(can,C);
      -+trash(can, C+1);
      -lata;
      !borrar(can);
      !consumir.
+!consumir : not has(_) & plato
   <- ?plato(P);
      -+plato(P+1);
      -plato;
      .send(rmayordomo, tell, platoSucio);
      .println("Aviso al robot mayordomo para que recoja mi plato");
      !consumir.
+!consumir : not has(_).
+!consumir : (has(beer) | has(pincho)) & asked(beer)
   <- .println("Owner va a empezar a tomar la cerveza y el pincho.");
      -asked(beer);
      !tomar(beer);
      !tomar(pincho);
      !consumir.
+!consumir : (has(beer) | has(pincho)) & not asked(beer)
   <- .println("Owner está bebiendo cerveza y comiendo el pincho.");
      !tomar(beer);
      !tomar(pincho);
      !consumir.

+!tomar(beer) : has(beer) & not lata
   <- tomar(beer);
      +lata.
+!tomar(pincho) : has(pincho) & not plato
   <- tomar(pincho);
      +plato.
+!tomar(Elem) : has(Elem)
   <- tomar(Elem).
+!tomar(Elem).
// -------------------------------------------------------------------

// Reglas para desacerse de una lata ---------------------------------
+!borrar(can) : true
   <- .random([1,2,3],X);
      if(X==1){
         !lanzar(can);
      }elif(X==2){
         !darBasuraRobot(can);   
      } else{
         !desechar(can);
      }.

+!desechar(can) : trash(can, C) & C>0
   <- .println("Owner va a tirar una lata a la basura.");
      !mover(bin);
      desechar(trash);
      -+trash(can, C-1);
      !mover(couch).
+!desechar(can).   

+!lanzar(Elem) : trash(can, C) & C>0
   <- .println("Owner va a lanzar una lata.");
      generarBasura(Elem);
      -+trash(Elem, C-1).
+!lanzar(Elem).

+!darBasuraRobot(Elem) : trash(can, C) & C>0
   <- -basuraRecogida;
      .println("Aviso al robot mayordomo de que tengo basura para recoger");
      .send(rmayordomo, achieve, recogerBasuraOwner(Elem, C));
      -+trash(Elem, 0).

+basuraRecogida [source(rlimpiador)] : true
   <- -+trash(can,0).
//------------------------------------------------------------------------

// Reglas para entregar un plato al robot mayordomo ----------------------
+!darPlato(rmayordomo) : plato(Cant) & Cant > 0
   <- .send(rmayordomo, achieve, llevar(plato, lavavajillas, Cant));
      .println("Propietario da plato al robot mayordomo");
      -+plato(0).
+!darPlato(rmayordomo).
// -----------------------------------------------------------------------

// Funcionalidad de vaciar el cubo de basura ---
+trashInBin(X) : X>=3
   <- .println("El owner ve la papelera llena");
      .send(rmayordomo, tell, papelera_llena).
// ---------------------------------------------

// Funcionalidad de estar aburrido -----------------------------------
+!check_bored : true
   <- .random(X); .wait(X*5000+2000);   // i get bored at random times
      .random([1,2,3,4], E);
      if(E==1){
         .send(rmayordomo, askOne, time(_), R);
         .print(R);
      } elif(E==2){
         .concat("Cuéntame un chiste", M);
         .print("El owner dice: ", M);
         .send(rmayordomo, tell, msg(M));
      }elif(E==3){
         .concat("Me aburro", M);
         .print("El owner dice: ", M);
         .send(rmayordomo, tell, msg(M));
      }else{
         .concat("Veo veo", M);
         .print("El owner dice: ", M);
         .send(rmayordomo, tell, msg(M));
      };
      !check_bored.
// ---------------------------------------------------------------------

// Movimiento -------------------------
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
   :  posActual(AX, AY) & AX == X & AY < Y & not obstaculo(AX+1, AY)
   <- !moverDerecha(X, Y);
      !moverAbajo(X, Y).
+!moverAbajo(X, Y)
   :  posActual(AX, AY) & AX == X & AY < Y & not obstaculo(AX-1, AY)
   <- !moverIzquierda(X, Y);
      !moverAbajo(X, Y).
+!moverAbajo(X, Y).
// ------------------------------------

// Mensajes ----------------------------
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// -------------------------------------