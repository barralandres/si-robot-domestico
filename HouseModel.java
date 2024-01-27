import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

import jason.environment.grid.GridWorldModel;
import jason.environment.grid.Location;

/** class that implements the Model of Domestic Robot application */
public class HouseModel extends GridWorldModel {

    // Constantes para los elementos del grid
    public static final int FRIDGE = 16;
    public static final int COUCH1 = 32;
    public static final int COUCH2 = 64;
    public static final int DELIVERY = 128;
    public static final int BIN = 256;
    public static final int TRASH = 512;
    public static final int ALACENA = 1024;
    public static final int LAVAVAJILLAS = 2048;

    // Tamaño del grid
    public static final int GSize = 11;
    public static final int NOBSTACULOS = 8;

    // Map relacionando el nombre de los agentes con su id
    Map<String, Integer> agents = 
        Map.of(
            "rmayordomo", 0,
            "rlimpiador", 1,
            "rbasurero", 2,
            "rpedidos", 3,
            "owner1", 4,
            "owner2", 5
        );

    // Variables de frigorifico abierto o cerrado
    boolean rmayordomoFrigorificoAbierto = false;
    boolean owner1FrigorificoAbierto = false;
    boolean owner2FrigorificoAbierto = false;

    // Variable de lavavajillas abierto o cerradp
    boolean lavavajillasAbierto = false;
    
    // Variables que indican que productos lleva el robot mayordomo
    boolean rmayordomoLlevaCerveza = false;
    boolean rmayordomoLlevaPincho = false;
    boolean rmayordomoLlevaTortilla = false;
    boolean rmayordomoLlevaEmpanada = false;
    int rmayordomoPinchosEmpanada = 0;
    int rmayordomoPinchosTortilla = 0;
    int rmayordomoPlatos = 0;

    // Variables que indican que los owners llevan cerveza
    boolean owner1LlevaCerveza = false;
    boolean owner2LlevaCerveza = false;

    // Variable de robot basurero encendido o apagado
    boolean rbasureroEncendido = false;

    // Número de sorbos que han hecho los owner
    int owner1Sorbos = 0;
    int owner2Sorbos = 0;

    // Número de mordisco que han hecho los owner
    int owner1Mordiscos = 0;
    int owner2Mordiscos = 0;

    // Varibles de existencias en la nevera
    int cervezasEstrella = 4;
    int cervezasMahou = 3;
    int pinchosTortilla = 0;
    int pinchosEmpanada = 1;
    int tortilla = 1;
    int empanada = 1;

    // Productos en la zona de entrega
    int entregaCervezasEstrella = 0;
    int entregaCervezasMahou = 0;
    int entregaTortilla = 0;
    int entregaEmpanada = 0;

    // Número de productos que lleva el robot de pedidos
    int rpedidosCervezasEstrella = 0;
    int rpedidosCervezasMahou = 0;
    int rpedidosTortilla = 0;
    int rpedidosEmpanada = 0;

    // Número de latas que hay en el cubo de basura
    int cansInBin = 0;

    // Platos que hay en la alacena
    int platosAlacena = 10;

    // Platos limpios o sucios que hay en el lavavajillas
    int platosLavavajillasLimpios = 0;
    int platosLavavajillasSucios = 0;

    // Cuenta atrás para que el lavavajillas termine de lavar
    int contadorLavavajillas = 0;

    // Posiciones de los elementos del entorno
    Location lFridge = new Location(0,0);
    Location lDelivery = new Location(0, GSize-1);
    Location lBin = new Location(GSize-1, 0);
    Location lCouch1 = new Location(GSize-1,GSize-1);
    Location lCouch2 = new Location(6, GSize-1);
    Location lLavavajillas = new Location(GSize/2, 0);
    Location lAlacena = new Location(GSize/2 -1, 0);

    // Posiciones originales de los agentes
    Location lRMayordomo = new Location(GSize/2, GSize/2);
    Location lRLimpiador = new Location(0, 5);
    Location lRBasurero = new Location(GSize-1-2, 0);
    Location lRPedidos = new Location(GSize/2-2, GSize-1);
    Location lOwner1 = new Location(GSize-1, GSize-1);
    Location lOwner2 = new Location(6, GSize-1);

    // ArrayList de posiciones de la basura
    ArrayList<Location> lTrash 
        = new ArrayList<>();
    
    // Arrays de posiciones permitidas para la colocación de los agentes

    // Posiciones permitidas del frigorifico
    ArrayList<Location> lFridgePositions 
        = new ArrayList<>(Arrays.asList(
            new Location(lFridge.x+1, lFridge.y+1),
            new Location(lFridge.x+1, lFridge.y),
            new Location(lFridge.x, lFridge.y+1)
        ));
    
    // Posiciones permitidas del sillón 1
    ArrayList<Location> lCouch1Positions
        = new ArrayList<>(Arrays.asList(
            new Location(lCouch1.x-1, lCouch1.y-1),
            new Location(lCouch1.x-1, lCouch1.y),
            new Location(lCouch1.x, lCouch1.y-1)
        ));
    
    // Posiciones permitidas del sillón 2
    ArrayList<Location> lCouch2Positions
        = new ArrayList<>(Arrays.asList(
            new Location(lCouch2.x-1, lCouch2.y-1),
            new Location(lCouch2.x-1, lCouch2.y),
            new Location(lCouch2.x, lCouch2.y-1),
            new Location(lCouch2.x+1, lCouch2.y-1),
            new Location(lCouch2.x+1, lCouch2.y)
        ));

    // Posiciones permitidas de la zona de entrega
    ArrayList<Location> lDeliveryPositions
        = new ArrayList<>(Arrays.asList(
            new Location(lDelivery.x+1, lDelivery.y),
            new Location(lDelivery.x, lDelivery.y-1),
            new Location(lDelivery.x+1, lDelivery.y-1)
        ));
    
    // Posiciones permitidas del cubo de basura
    ArrayList<Location> lBinPositions
        = new ArrayList<>(Arrays.asList(
            new Location(lBin.x-1, lBin.y),
            new Location(lBin.x-1, lBin.y+1),
            new Location(lBin.x, lBin.y+1)
        ));
        
    // Posiciones permitidas de la alacena
    ArrayList<Location> lAlacenaPositions
        = new ArrayList<>(Arrays.asList(
            new Location(lAlacena.x-1, lAlacena.y),
            new Location(lAlacena.x-1, lAlacena.y+1),
            new Location(lAlacena.x, lAlacena.y+1),
            new Location(lAlacena.x+1, lAlacena.y+1)
        ));

    // Posiciones permiticas del lavavajillas
    ArrayList<Location> lLavavajillasPositions
        = new ArrayList<>(Arrays.asList(
            new Location(lLavavajillas.x+1, lLavavajillas.y+1),
            new Location(lLavavajillas.x+1, lLavavajillas.y),
            new Location(lLavavajillas.x, lLavavajillas.y+1),
            new Location(lLavavajillas.x-1, lLavavajillas.y-1)
    ));
    
    public HouseModel() {
        // Creación del grid con el tamaño definido en GSize
        // Número de agentes móviles: 5
        super(GSize, GSize, 6);

        // Añadido de posiciones iniciales para los agentes (móviles)
        setAgPos(agents.get("rmayordomo"), lRMayordomo);
        setAgPos(agents.get("rlimpiador"), lRLimpiador);
        setAgPos(agents.get("rbasurero"), lRBasurero);
        setAgPos(agents.get("rpedidos"), lRPedidos);
        setAgPos(agents.get("owner1"), lOwner1);
        setAgPos(agents.get("owner2"), lOwner2);

        // Añadido de posiciones para los elementos del entorno (no móviles)
        add(FRIDGE, lFridge);
        add(DELIVERY, lDelivery);
        add(BIN, lBin);
        add(COUCH1, lCouch1);
        add(COUCH2, lCouch2);
        add(LAVAVAJILLAS, lLavavajillas);
        add(ALACENA, lAlacena);

        generarObstaculosAleatorios();

    }

    // Generacion de obstaculos aleatorios
    private void generarObstaculosAleatorios() {
        Location location;
        int x;
        int y;

        for(int i = 0; i < NOBSTACULOS ;i++){
            do{
                x = (int) (Math.random()*(GSize-1));
                y = (int) (Math.random()*(GSize-1));
                location = new Location(x, y);
            }while(
                location.equals(lCouch1) ||
                location.equals(lCouch2) ||
                !esLibre(location) ||
                !esLibre(location.x-1, location.y) ||
                !esLibre(location.x+1, location.y) ||
                !esLibre(location.x-1, location.y-1) ||
                !esLibre(location.x-1, location.y+1) ||
                !esLibre(location.x+1, location.y-1) ||
                !esLibre(location.x+1, location.y+1) ||
                !esLibre(location.x, location.y+1) ||
                !esLibre(location.x, location.y-1)
            );


            add(HouseModel.OBSTACLE, location);
        } 

    }

    // Abrir frigorífico
    boolean openFridge(String ag) {
        if (!rmayordomoFrigorificoAbierto && ag.equals("rmayordomo")) {
            rmayordomoFrigorificoAbierto = true;   
        } else if(!owner1FrigorificoAbierto && ag.equals("owner1")){
            owner1FrigorificoAbierto = true;
        } else if(!owner2FrigorificoAbierto && ag.equals("owner2")){
            owner2FrigorificoAbierto = true;
        } else {
            return false;
        }

        return true;
    }

    // Cerrar frigorífico
    boolean closeFridge(String ag) {
        if (rmayordomoFrigorificoAbierto && ag.equals("rmayordomo")) {
            rmayordomoFrigorificoAbierto = false;   
        } else if(owner1FrigorificoAbierto && ag.equals("owner1")){
            owner1FrigorificoAbierto = false;
        } else if(owner2FrigorificoAbierto && ag.equals("owner2")){
            owner2FrigorificoAbierto = false;
        } else {
            return false;
        }

        return true;
    }

    // Abrit lavavajillas
    boolean abrirLavavajillas(){
        if(!lavavajillasAbierto){
            lavavajillasAbierto = true;
            return true;
        }
        return false;
    }

    // Cerrar lavavajillas
    boolean cerrarLavavajillas(){
        if(lavavajillasAbierto){
            lavavajillasAbierto = false;
            return true;
        }
        return false;
    }


    // Moviminto de los agentes por el entorno
    public boolean mover(String ag, int X, int Y) {
        int nAg = this.agents.get(ag);
        Location nuevaPosicion = new Location(X,Y);

        if(esLibre(nuevaPosicion)){
            setAgPos(nAg, nuevaPosicion);
        }

        return true;
    }

    // Devuelve true si la posición está libre
    public boolean esLibre(int x, int y){
        return esLibre(new Location(x,y));
    }
    public boolean esLibre(Location location) {
        if(
            lFridge.equals(location) ||
            lDelivery.equals(location) ||
            lBin.equals(location) ||
            lAlacena.equals(location) ||
            lLavavajillas.equals(location)
        ){
            return false;
        }
        
        return isFree(location);
    }

    // Coger cerveza del frigorifico
    boolean get(String ag, String producto, String tipo) {
        if(producto.equals("beer")){
            if(tipo.equals("estrella")){
                if(cervezasEstrella > 0){
                    cervezasEstrella--;
                }
            } else if(tipo.equals("mahou")){
                if(cervezasMahou > 0){
                    cervezasMahou--;
                }
            } else {
                return false;
            }
            if(rmayordomoFrigorificoAbierto && ag.equals("rmayordomo") && !rmayordomoLlevaCerveza){
                rmayordomoLlevaCerveza = true;
            } else if(owner1FrigorificoAbierto && ag.equals("owner1") && !owner1LlevaCerveza){
                owner1LlevaCerveza = true;
            } else if(owner2FrigorificoAbierto && ag.equals("owner2") && !owner2LlevaCerveza){
                owner2LlevaCerveza = true;
            } else {
                return false;
            }
        } else if(producto.equals("pincho")){
            if(tipo.equals("tortilla")){
                if(pinchosTortilla > 0){
                    pinchosTortilla--;
                } else{
                    return false;
                }
            } else if(tipo.equals("empanada")){
                if(pinchosEmpanada > 0){
                    pinchosEmpanada--;
                } else{
                    return false;
                }
            } else{
                return false;
            }
            rmayordomoLlevaPincho = true;
        } else if(producto.equals("comida")){
            if(tipo.equals("tortilla")){
                if(tortilla > 0){
                    rmayordomoLlevaTortilla = true;
                    tortilla--;
                } else{
                    return false;
                }
            } else if(tipo.equals("empanada")){
                if(empanada > 0){
                    rmayordomoLlevaEmpanada = true;
                    empanada--;
                } else{
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
        if (view != null) view.update(lFridge.x,lFridge.y);
        return true;
    }

    // Fabricar pinchos
    boolean hacerPinchos(String comida){
        if(platosAlacena >= 3){
            if(comida.equals("tortilla")){
                if(rmayordomoLlevaTortilla){
                    rmayordomoLlevaTortilla = false;
                    rmayordomoPinchosTortilla = 3;
                    
                } else{
                    return false;
                }
            } else if(comida.equals("empanada")){
                if(rmayordomoLlevaEmpanada){
                    rmayordomoLlevaEmpanada = false;
                    rmayordomoPinchosEmpanada = 3;
                } else{
                    return false;
                }
            } else{
                return false;
            }
            platosAlacena-=3;
        }
        if (view != null) view.update(lAlacena.x,lAlacena.y);
        return true;
    }

    // Reponer pinchos en la nevera
    boolean reponerPinchos(String comida){
        if(comida.equals("tortilla")){
            if(rmayordomoPinchosTortilla > 0){
                pinchosTortilla = rmayordomoPinchosTortilla;
                rmayordomoPinchosTortilla = 0;
            } else{
                return false;
            }
        } else if(comida.equals("empanada")){
            if(rmayordomoPinchosEmpanada > 0){
                pinchosEmpanada = rmayordomoPinchosEmpanada;
                rmayordomoPinchosEmpanada = 0;
            } else{
                return false;
            }
        } else {
            return false;
        }
        if (view != null) view.update(lFridge.x,lFridge.y);
        return true;
    }

    // Añadir productos en la zona de entrega
    boolean anadirProductoDelivery(String producto, String tipo, int n) {
        if(producto.equals("beer")){
            if(tipo.equals("estrella")){
                entregaCervezasEstrella += n;
                if (view != null) view.update(lDelivery.x,lDelivery.y);
                return true;
            } else if(tipo.equals("mahou")){
                entregaCervezasMahou += n;
                if (view != null) view.update(lDelivery.x,lDelivery.y);
                return true;
            }
        } else if(producto.equals("comida")){
            if(tipo.equals("tortilla")){
                entregaTortilla += n;
                if (view != null) view.update(lDelivery.x,lDelivery.y);
                return true;
            } else if(tipo.equals("empanada")){
                entregaEmpanada += n;
                if (view != null) view.update(lDelivery.x,lDelivery.y);
                return true;
            }
        }

        return false;
    }

    // Meter productos en la nevera
    boolean meterProductoNevera(String producto, String tipo, int n) {
        if(producto.equals("beer")){
            if(tipo.equals("estrella")){
                if(rpedidosCervezasEstrella > 0){
                    rpedidosCervezasEstrella-=n;
                    cervezasEstrella+=n;
                    if (view != null) view.update(lFridge.x,lFridge.y);
                    return true;
                }
            } else if(tipo.equals("mahou")){
                if(rpedidosCervezasMahou > 0){
                    rpedidosCervezasMahou-=n;
                    cervezasMahou+=n;
                    if (view != null) view.update(lFridge.x,lFridge.y);
                    return true;
                }
            }
        } else if(producto.equals("comida")){
            if(tipo.equals("tortilla")){
                if(rpedidosTortilla > 0){
                    rpedidosTortilla-=n;
                    tortilla+=n;
                    if (view != null) view.update(lFridge.x,lFridge.y);
                    return true;
                }
            } else if(tipo.equals("empanada")){
                if(rpedidosEmpanada > 0){
                    rpedidosEmpanada-=n;
                    empanada+=n;
                    if (view != null) view.update(lFridge.x,lFridge.y);
                    return true;
                }
            }
        } 
        return false;
    }

    // Entrega de cerveza al owner
    boolean entregaCerveza(String agEmisor, String agReceptor) {
        if(agEmisor.equals("rmayordomo") && rmayordomoLlevaCerveza){
            rmayordomoLlevaCerveza = false;
        } else if(agEmisor.equals("owner1") && owner1LlevaCerveza){
            owner1LlevaCerveza = false;
        } else if(agEmisor.equals("owner2") && owner2LlevaCerveza){
            owner2LlevaCerveza = false;
        } else{
            return false;
        }
            
        if(agReceptor.equals("owner1")){
            owner1Sorbos = 10;
            if(view != null){
                Location lAgent = getAgPos(this.agents.get("owner1"));
                view.update(lAgent.x,lAgent.y);
            }
        } else if(agReceptor.equals("owner2")) {
            owner2Sorbos = 10;
            if(view != null){
                Location lAgent = getAgPos(this.agents.get("owner2"));
                view.update(lAgent.x,lAgent.y);
            }
        } else{
            return false;
        }

        return true;
    }

    // Entrega de pinchos al owner
    boolean entregaPincho(String agReceptor){
        if(rmayordomoLlevaPincho){
            rmayordomoLlevaPincho = false;
        } else {
            return false;
        }
        
        if(agReceptor.equals("owner1")){
            owner1Mordiscos = 10;
            if(view != null){
                Location lAgent = getAgPos(this.agents.get("owner1"));
                view.update(lAgent.x,lAgent.y);
            }
        } else if(agReceptor.equals("owner2")) {
            owner2Mordiscos = 10;
            if(view != null){
                Location lAgent = getAgPos(this.agents.get("owner2"));
                view.update(lAgent.x,lAgent.y);
            }
        } else{
            return false;
        }

        return true;
    }

    // Tomar cerveza
    boolean tomarBeer(String ag) {
        if(ag.equals("owner1")){
            if (owner1Sorbos > 0) {
                owner1Sorbos--;
                if(view != null){
                    Location lAgent = getAgPos(this.agents.get("owner1"));
                    view.update(lAgent.x,lAgent.y);
                }
                return true;
            } else {
                return false;
            }
        } else if(ag.equals("owner2")) {
            if (owner2Sorbos > 0) {
                owner2Sorbos--;
                if(view != null){
                    Location lAgent = getAgPos(this.agents.get("owner2"));
                    view.update(lAgent.x,lAgent.y);
                }
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    // Tomar pincho
    boolean tomarPincho(String ag){
        if(ag.equals("owner1")){
            if (owner1Mordiscos > 0) {
                owner1Mordiscos--;
                if(view != null){
                    Location lAgent = getAgPos(this.agents.get("owner1"));
                    view.update(lAgent.x,lAgent.y);
                }
                return true;
            } else {
                return false;
            }
        } else if(ag.equals("owner2")) {
            if (owner2Mordiscos > 0) {
                owner2Mordiscos--;
                if(view != null){
                    Location lAgent = getAgPos(this.agents.get("owner2"));
                    view.update(lAgent.x,lAgent.y);
                }
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    // desechar la basura
    boolean desechar(){
        cansInBin++;
        if (view != null) view.update(lBin.x,lBin.y);
        return true; 
    }

    // Vacía el cubo de basura
    boolean vaciarPapelera(){
        if(cansInBin > 0){
            cansInBin = 0;
            if (view != null) view.update(lBin.x,lBin.y);
            return true;
        } else{
            return false;
        }
    }

    // Desperdigar la basura que tira el owner por el entorno
    boolean generarBasura() {
        Location location;
        int x;
        int y;
        do{
            x = (int) (Math.random()*(GSize-1));
            y = (int) (Math.random()*(GSize-1));
            location = new Location(x, y);
        }while(
            location.equals(lCouch1) ||
            location.equals(lCouch2) ||
            !esLibre(location)
        );

        add(TRASH, location);
        lTrash.add(location);
        return true;

    }

    // Recoger la basura que se encuentra en el entorno
    boolean pickTrash() {
        Location r1 = getAgPos(agents.get("rlimpiador"));

        if (hasObject(TRASH, r1)) {
            if(lTrash.contains(r1)){
                lTrash.remove(lTrash.indexOf(r1));

            }
            remove(TRASH, r1);
			return true;
        }
		return false;
    }

    // Recoger productos en el punto de recogida
    public boolean cogerProductoDelivery(String product, String tipo, int n) {
        if(product.equals("beer")){
            if(tipo.equals("estrella")){
                if(entregaCervezasEstrella > 0){
                    entregaCervezasEstrella-=n;
                    rpedidosCervezasEstrella+=n;
                    if(view != null) view.update(lDelivery.x,lDelivery.y);
                    return true;
                }
            } else if(tipo.equals("mahou")){
                if(entregaCervezasMahou > 0){
                    entregaCervezasMahou-=n;
                    rpedidosCervezasMahou+=n;
                    if(view != null) view.update(lDelivery.x,lDelivery.y);
                    return true;
                }
            }
        } else if(product.equals("comida")){
            if(tipo.equals("tortilla")){
                if(entregaTortilla > 0){
                    entregaTortilla-=n;
                    rpedidosTortilla+=n;
                    if(view != null) view.update(lDelivery.x,lDelivery.y);
                    return true;
                }
            } else if(tipo.equals("empanada")){
                if(entregaEmpanada > 0){
                    entregaEmpanada-=n;
                    rpedidosEmpanada+=n;
                    if(view != null) view.update(lDelivery.x,lDelivery.y);
                    return true;
                }
            }
        }
        return false;
    }


    // Meter los platos sucios en el lavavajillas
    boolean meterPlatoLavavajillas(int cantidad){
        platosLavavajillasSucios+=cantidad;
        if(view != null) view.update(lLavavajillas.x,lLavavajillas.y);
        return true;
    }

    // Lavar los platos (cuenta atrás con delay)
    boolean lavarPlatos(){
        contadorLavavajillas = 10;
        while(contadorLavavajillas>0){
            if(view != null) view.update(lLavavajillas.x,lLavavajillas.y);
            --contadorLavavajillas;
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        platosLavavajillasLimpios = platosLavavajillasSucios;
        platosLavavajillasSucios = 0;
        if(view != null) view.update(lLavavajillas.x,lLavavajillas.y);
        return true;
    }

    // Quitar los platos del lavavajillas
    public boolean quitarPlatosLavavajillas() {
        if(platosLavavajillasLimpios > 0){
            rmayordomoPlatos = platosLavavajillasLimpios;
            platosLavavajillasLimpios = 0;
            if(view != null) view.update(lLavavajillas.x,lLavavajillas.y);
            return true;
        }
        return false;
    }

    // Meter los platos en la alacena
    public boolean meterPlatosAlacena() {
        platosAlacena += rmayordomoPlatos;
        rmayordomoPlatos = 0;
        if(view != null) view.update(lAlacena.x,lAlacena.y);
            return true;
    }

    // Encender el robot basurero
    public boolean encenderRbasurero(){
        if(!rbasureroEncendido){
            rbasureroEncendido = true;
            if(view != null) view.update(lRBasurero.x,lRBasurero.y);
            return true;
        } 
        return false;
    }

    // Apagar el robot basurero
    public boolean apagarRBasurero(){
        if(rbasureroEncendido){
            rbasureroEncendido = false;
            if(view != null) view.update(lRBasurero.x,lRBasurero.y);
            return true;
        } 
        return false;
    }
}