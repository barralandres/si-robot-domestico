// Creencias iniciales --------------------------------------------------------
stock(pincho, tortilla, 0).
stock(pincho, empanada, 1).
stock(beer, estrella, 4).
stock(beer, mahou, 3). 
stock(comida, tortilla, 1).
stock(comida, empanada, 1).

limit(beer, owner1, 5).
limit(beer, owner2, 4).

nPerTime(beer, 3).
nPerTime(comida, 1).

pos(fridge, 0, 0).
pos(owner1, 10, 10).
pos(owner2, 6, 10).
pos(lavavajillas, 5, 0).
pos(alacena, 4, 0).
pos(baseRMayordomo, 5, 5).

dinero(0).

too_much(B, Owner) :- // Calculo para determinar si el owner puede tomar más cerveza
   .date(YY,MM,DD) &
   .count(consumed(YY,MM,DD,_,_,_,B,Owner),QtdB) &
   limit(B, Owner, Limit) &
   QtdB >= Limit.
// -----------------------------------------------------------------------------

// Objetivos iniciales ---------------------------------------------------------------------------
!bring(beer). // Objetivo inicial de llevar cerveza al owner
!comprobarBasura(rmayordomo, trash). // Objetivo inicial de comprobar si hay basura en el entorno
// -----------------------------------------------------------------------------------------------

// Funcionalidad de llevar cerveza al owner ------------------------------------------
+asked(beer) [source(Owner)]
   <- .println(Owner, " ha solicitado una cerveza");
      +asked(Owner, beer);
      -asked(beer) [source(Owner)].

+!dinero(Cant) [source(Owner)]: true
   <- .println("El robot mayordomo ha recibido dinero de ", Owner);
      ?dinero(C);
      +dinero(Cant+C).

+!bring(beer) : platoSucio [source(Owner)]
   <- .println("El robot mayordomo va a buscar el plato de ", Owner);
      !mover(Owner);
      .send(Owner, achieve, darPlato(rmayordomo)).

+!bring(beer) [source(self)]
   :  too_much(beer, Owner) & limit(beer, Owner, L) & not limiteAlcanzado(Owner, beer)
   <- .concat("The Department of Health does not allow me to give you more than ", L,
              " beers a day! I am very sorry about that!",M);
      -asked(Owner, beer);
      .send(Owner,tell,msg(M));
      .send(Owner, tell, ~couldDrink(beer));
      .println("El Robot mayordomo va a descansar porque ", Owner, " ha bebido mucho hoy.");
      +limiteAlcanzado(Owner, beer);
      !bring(beer).

+!bring(beer)[source(self)] 
   :  asked(Owner, beer) & stock(beer, TipoCerveza, Cant) & Cant>0 & 
      not too_much(Owner, beer) & not limiteAlcanzado(Owner, beer)
   <- .println("El robot mayordomo va a buscar una cerveza");
      !mover(fridge);
      !get(beer, Owner, TipoCerveza);
	  !bring(beer).

+!bring(beer) : true
   <- !mover(baseRMayordomo);
      .println("El robot mayordomo está esperando.");
      .wait(2000);
	  !bring(beer).
// -----------------------------------------------------------------------------

// Funcionalidad de llevar platos al lavavajillas y lavar los platos ----------
+!llevar(plato, lavavajillas, Cant) [source(Owner)]
   <- !mover(lavavajillas);
      !abrir(lavavajillas);
      .println("El robot mayordomo ha abierto el lavavajillas");
      !quitar(platos, lavavajillas);
      meter(plato, lavavajillas, Cant);
      .println("El robot mayordomo ha metido un plato en el lavavajillas");
      close(lavavajillas);
      .println("El robot mayordomo ha cerrado el lavavajillas");
      -platoSucio [source(Owner)];
      !lavarPlatos(rmayordomo, lavavajillas);
      !bring(beer).

+!abrir(lavavajillas) : not lavavajillasEncendido
   <- open(lavavajillas).
+!abrir(lavavajillas)
   <- .wait(1000);
      !abrir(lavavajillas).

+platosSucios(lavavajillas,Cant)[source(percept)]
   <- -+platosSucios(lavavajillas,Cant).
+platosLimpios(lavavajillas,Cant)[source(percept)]
   <- -+platosLimpios(lavavajillas,Cant).

+!quitar(platos, lavavajillas)
   :  platosLimpios(lavavajillas,Cant) & Cant > 0
   <- close(lavavajillas);
      .println("El robot mayordomo ha cerrado el lavavajillas");
      quitar(platos, lavavajillas);
      .println("El robot mayordomo ha quitado los platos limpios del lavavajillas");
      !mover(alacena);
      meter(platos, alacena);
      .println("El robot mayordomo ha metido los platos en el lavavajillas");
      !mover(lavavajillas);
      open(lavavajillas);
      .println("El robot mayordomo ha abierto el lavavajillas").
+!quitar(platos, lavavajillas).

+!lavarPlatos(rmayordomo,lavavajillas) 
   :  platosSucios(lavavajillas,Cant) & Cant >= 4
   <- .send(lavavajillas, achieve, encender);
      .println("El robot mayordomo ha encendido el lavavajillas").
+!lavarPlatos(rmayordomo, lavavajillas).
// ----------------------------------------------------------------------------

// Reglas para llevar cerveza al owner ----------------------------------------
+!get(beer, Owner, TipoCerveza) : not neveraAbierta
   <- open(fridge);
      .wait(500);
      .println("El robot mayordomo ha abierto la nevera");
      !get(beer, Owner, TipoCerveza).
+!get(beer, Owner, TipoCerveza) 
   : stock(beer, TipoCerveza, CantCerveza) & CantCerveza > 0 &
     stock(pincho, TipoPincho, CantPincho) & CantPincho > 0
   <- .println("El robot mayordomo coge una cerveza");
      get(beer, TipoCerveza);
      .println("El robot mayordomo coge un pincho");
      get(pincho, TipoPincho);
      close(fridge);
      !mover(Owner);
      !has(Owner, beer);
      !has(Owner, pincho);
      -asked(Owner, beer).
+!get(beer, Owner, TipoCerveza) 
   : stock(comida, TipoComida, Cant) & Cant > 0 &
     stock(pincho, TipoPincho, CantPincho) & CantPincho == 0
   <- close(fridge);
      .println("Robot mayordomo coge comida del frigorífico");
      get(comida, TipoComida);
      .println("Robot mayordomo se dirige a la alacena");
      !mover(alacena);
      .println("El robot mayordomo hace pinchos");
      hacerPinchos(TipoComida);
      .println("El robot mayordomo vuelve a la nevera");
      !mover(fridge);
      open(fridge);
      .wait(500);
      reponerPinchos(TipoComida);
      .println("El robot mayordomo ha abierto la nevera y ha introducido los pinchos");
      close(fridge);
      !get(beer, Owner, TipoCerveza).
+!get(beer, Owner, TipoCerveza) : stock(beer, TipoCerveza, CantCerveza) & CantCerveza > 0
   <- .println("El robot mayordomo coge una cerveza");
      get(beer, TipoCerveza);
      close(fridge);
      !mover(Owner);
      !has(Owner, beer);
      -asked(Owner,beer).
+!get(beer, Owner, TipoCerveza) : true
   <- .println("No hay cervezas en la nevera");
      close(fridge).

+!has(Owner, beer) : true
   <- entrega(beer, Owner);
      .println("El robot mayordomo le entrega la cerveza a ", Owner);
      ?has(Owner, beer);
      // remember that another beer has been consumed
      .date(YY,MM,DD); .time(HH,NN,SS);
      +consumed(YY,MM,DD,HH,NN,SS,beer,Owner).
+!has(Owner, pincho) : true
   <- entrega(pincho, Owner);
      .println("El robot mayordomo le entrega el pincho a ", Owner);
      ?has(Owner, pincho).
// ----------------------------------------------------------------------------

// Funcionalidad de comprar más cervezas --------------------------------------
+available(pincho, Tipo, Cant)[source(percept)] 
   :  stock(pincho, Tipo, CantAnterior) & 
      (not Cant == CantAnterior | Cant == 0)
   <- -stock(pincho, Tipo, _);
      +stock(pincho, Tipo, Cant);
      -available(pincho, Tipo, Cant)[source(rpedidos)].
+available(Producto, Tipo, Cant)[source(rpedidos)] 
   :  stock(Producto, Tipo, CantAnterior) & 
      (not Cant == CantAnterior | Cant == 0)
   <- -stock(Producto, Tipo, _);
      +stock(Producto, Tipo, Cant);
      -ordered(Producto, Tipo);
      -available(Producto, Tipo, Cant)[source(rpedidos)];
      !comprar(rmayordomo, Producto, Tipo).
+available(Producto, Tipo, Cant)[source(Ag)] 
   :  (Ag==percept | Ag==owner1 | Ag == owner2) & 
      stock(Producto, Tipo, CantAnterior) & 
      (not Cant == CantAnterior | Cant == 0)
   <- -stock(Producto, Tipo, _);
      +stock(Producto, Tipo, Cant);
      -available(Producto, Tipo, Cant)[source(Ag)];
      !comprar(rmayordomo, Producto, Tipo).

+!comprar(rmayordomo, Producto, Tipo)
   :  not dineroInsuficiente & not price(Producto, Tipo, _)
   <- .concat("No hay stock de ", Producto, " - ", Tipo, " en ningún supermercado.", M);
      .send(owner1, tell, msg(M));
      .send(owner2, tell, msg(M)).

+!comprar(rmayordomo,Producto, Tipo)
   :  stock(Producto,Tipo,Cant) & nPerTime(Producto, Num) & Cant<Num 
      & not ordered(Producto,Tipo) & not dineroInsuficiente
   <- +ordered(Producto, Tipo);
      .println("El robot mayordomo va a realizar un pedido");
      .findall(q(Precio, Agente), price(Producto, Tipo, Precio)[source(Agente)], L);
      .min(L, Min);
	   !despieza(Min, PrecioMin, Supermercado);
      !realizarPedido(Producto, Tipo, Supermercado, Num, PrecioMin).
+!comprar(rmayordomo,Producto,Tipo).

+!despieza([],[],[]).
+!despieza(q(X,Y),X,Y).

+!realizarPedido(Producto, Tipo, Supermercado, 0, PrecioMin)
   <- +dineroInsuficiente;
      .println("El robot no tiene dinero suficiente para comprar cervezas");
      .concat("No hay dinero para comprar más cervezas", M);
      .send(owner1, tell, msg(M));
      .send(owner2, tell, msg(M));
      -ordered(Producto, Tipo).
+!realizarPedido(Producto, Tipo, Supermercado, N, PrecioMin) 
   :  dinero(M) & M >= N*PrecioMin
   <- .send(Supermercado, achieve, order(Producto, Tipo, N));
      +dineroReservado(Producto, Tipo, N*PrecioMin);
      -+dinero(M-N*PrecioMin);
      .println("El robot mayordomo ha realizado un pedido al supermercado.").
+!realizarPedido(Producto, Tipo, Supermercado, N, PrecioMin) : true
   <- !realizarPedido(Producto, Tipo, Supermercado, N-1, PrecioMin).

+delivered(Producto, Tipo, Qtd,OrderId)[source(Supermercado)]
  <-  ?dineroReservado(Producto, Tipo, Dinero);
      .send(rpedidos, tell, dinero(OrderId, Supermercado, Dinero));
      -dineroReservado(Producto, Tipo, _);
      .send(rpedidos, tell, delivered(Producto, Tipo, Qtd, OrderId, Supermercado)).

+not_enough_stock(Producto, Tipo, _, _)[source(Supermercado)] : true
   <- .println("No ha stock en ", Supermercado);
      -price(Producto, Tipo, _)[source(Supermercado)];
      -ordered(Producto, Tipo);
      ?dineroReservado(Producto, Tipo, DReservado);
      ?dinero(D);
      -+dinero(D+DReservado);
      -dineroReservado(Producto, Tipo, _);
      !comprar(rmayordomo, Producto, Tipo).
// -----------------------------------------------------------------------------

// Funcionalidad de limpiar el entorno ------------------------------------------
+!comprobarBasura(rmayordomo, trash) : trashInEnv(T) & T>0 & not entornoSucio
   <- .println("El robot mayordomo ve el entorno sucio y avisa al robot limpiador");
      +entornoSucio;
      .send(rlimpiador, tell, hayBasura);
      !comprobarBasura(rmayordomo, trash).

+!comprobarBasura(rmayordomo, trash) : true
   <- .wait(5000);
      !comprobarBasura(rmayordomo, trash).

+!limpiezaTerminada 
   <- -entornoSucio;
      .println("El entorno ya está limpio").

+!recogerBasuraOwner(Elem, C)[source(Owner)] : true
   <- .send(rlimpiador, tell, ownerTrash(Owner, Elem, C));
      .println("El robot mayordomo avisa al robot limpiador para que recoja la basura de ", Owner).

// ------------------------------------------------------------------------------

// Funcionalidad de vaciar el cubo de basura ------------------
+papelera_llena [source(Ag)] : Ag == rlimpiador | Ag == owner1 |Ag == owner2
   <- .println("La papelera está llena y aviso al robot basurero");
      .send(rbasurero, tell, papelera_llena);
      .abolish(papelera_vacia).

+papelera_vacia [source(rbasurero)] : true
   <- .println("La papelera ya está vacía");
      .abolish(papelera_llena).
// -----------------------------------------------------------

// Movimiento -----------------------------------
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
// ----------------------------------------------

// Comprobar la hora
+?time(T) : true
  <-  time.check(T).
// ------------------

// Mensajes -------------------------------------------------------------------
+msg("Me aburro")[source(Ag)] : Ag == owner1 | Ag == owner2
   <- .concat("Siento no poder ayudarte", M);
      .send(Ag, tell, msg(M));
      -msg("Me aburro")[source(Ag)].
+msg("Veo veo")[source(Ag)] : Ag == owner1 | Ag == owner2
   <- .concat("¿Qué ves?", M);
      .send(Ag, tell, msg(M));
      -msg("Veo veo")[source(Ag)].
+msg("Cuéntame un chiste")[source(Ag)] : Ag == owner1 | Ag == owner2
   <- .concat("¿Qué le dice un jardinero a otro? Nos vemos cuando podamos", M);
      .send(Ag, tell, msg(M));
      -msg("Cuéntame un chiste")[source(Ag)].
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M)[source(Ag)].
// ----------------------------------------------------------------------------