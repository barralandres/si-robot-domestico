import jason.NoValueException;
import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.Location;

import java.util.logging.Logger;

public class HouseEnv extends Environment {
 
    // common literals

    // Acción de abrir la nevera
    public static final Literal openFridge  = Literal.parseLiteral("open(fridge)");

    // Acción de cerrar la nevera
    public static final Literal closeFridge = Literal.parseLiteral("close(fridge)");

    // Acción de abrir el lavavajillas
    public static final Literal openLavavajillas = Literal.parseLiteral("open(lavavajillas)");

    // Acción de cerrar el lavavajillas
    public static final Literal closeLavavajillas = Literal.parseLiteral("close(lavavajillas)");
    
    // Acción de encender el robot basurero
    public static final Literal encederRBasurero = Literal.parseLiteral("encender(rbasurero)");

    // Acción de apagar el robot basurero
    public static final Literal apagarRBasurero = Literal.parseLiteral("apagar(rbasurero)");

    // Acción de tomar una cerveza
    public static final Literal tomarBeer  = Literal.parseLiteral("tomar(beer)");

    // Acción de tomar un pincho
    public static final Literal tomarPincho  = Literal.parseLiteral("tomar(pincho)");

    // Acción de quitar los platos limpios del lavavajillas
    public static final Literal quitarPlatosLavavajillas  = Literal.parseLiteral("quitar(platos, lavavajillas)");
    
    // Acción de meter los platos en la alacena
    public static final Literal meterPlatosAlacena  = Literal.parseLiteral("meter(platos, alacena)");
    
    // Acción de vaciar el cubo de basura
    public static final Literal vaciarBin  = Literal.parseLiteral("vaciar(bin)");

    // Acción de tirar una lata en el entorno
    public static final Literal generarBasura = Literal.parseLiteral("generarBasura(can)");

    // Acción de lavar los platos
    public static final Literal lavarPlatos = Literal.parseLiteral("lavar(platos)");

    // Acción de recoger una lata del entorno
    public static final Literal pickTrash = Literal.parseLiteral("pick(trash)");

    // Acción de tirar la basura el el cubo
    public static final Literal desecharTrash = Literal.parseLiteral("desechar(trash)");

    // Creencias de pertenencia de cerveza o pincho
    public static final Literal hasOwner1Beer = Literal.parseLiteral("has(owner1,beer)");
    public static final Literal hasOwner1Pincho = Literal.parseLiteral("has(owner1,pincho)");
    public static final Literal hasOwner2Beer = Literal.parseLiteral("has(owner2,beer)");
    public static final Literal hasOwner2Pincho = Literal.parseLiteral("has(owner2,pincho)");
    public static final Literal hasPincho = Literal.parseLiteral("has(pincho)");
    public static final Literal hasBeer = Literal.parseLiteral("has(beer)");

    // Creencias de localización para los agentes móviles
    public static final Literal atFridge = Literal.parseLiteral("at(fridge)");
    public static final Literal atBaseRMayordomo = Literal.parseLiteral("at(baseRMayordomo)");
    public static final Literal atAlacena = Literal.parseLiteral("at(alacena)");
    public static final Literal atLavavajillas = Literal.parseLiteral("at(lavavajillas)");
    public static final Literal atBin = Literal.parseLiteral("at(bin)");
    public static final Literal atTrash = Literal.parseLiteral("at(trash)");
    public static final Literal atBaseRLimpiador = Literal.parseLiteral("at(baseRLimpiador)");
    public static final Literal atOwner1 = Literal.parseLiteral("at(owner1)");
    public static final Literal atOwner2 = Literal.parseLiteral("at(owner2)");
    public static final Literal atBaseRBasurero = Literal.parseLiteral("at(baseRBasurero)");
    public static final Literal atDelivery = Literal.parseLiteral("at(delivery)");
    public static final Literal atBaseRPedidos = Literal.parseLiteral("at(baseRPedidos)");
    public static final Literal atCouch = Literal.parseLiteral("at(couch)");

    static Logger logger = Logger.getLogger(HouseEnv.class.getName());

    HouseModel model; // the model of the grid

    @Override
    public void init(String[] args) {
        model = new HouseModel();

        if (args.length == 1 && args[0].equals("gui")) {
            HouseView view  = new HouseView(model);
            model.setView(view);
        }

        updatePercepts();
    }

    /** creates the agents percepts based on the HouseModel */
    void updatePercepts() {

        // Limpieza de creencias de todos los agentes
        clearPercepts("rmayordomo");
        clearPercepts("rlimpiador");
        clearPercepts("rbasurero");
        clearPercepts("rpedidos");
        clearPercepts("owner1");
        clearPercepts("owner2");

        Location lRMayordomo = model.getAgPos(model.agents.get("rmayordomo"));
        Location lRLimpiador = model.getAgPos(model.agents.get("rlimpiador"));
        Location lRBasurero = model.getAgPos(model.agents.get("rbasurero"));
        Location lRPedidos = model.getAgPos(model.agents.get("rpedidos"));
        Location lOwner1 = model.getAgPos(model.agents.get("owner1"));
        Location lOwner2 = model.getAgPos(model.agents.get("owner2"));

        addPercept("rmayordomo", Literal.parseLiteral("posActual("+lRMayordomo.x+","+lRMayordomo.y+")"));
        if(!model.esLibre(lRMayordomo.x+1, lRMayordomo.y)){
            addPercept("rmayordomo", Literal.parseLiteral("obstaculo("+(lRMayordomo.x+1)+","+lRMayordomo.y+")"));
        }
        if(!model.esLibre(lRMayordomo.x-1, lRMayordomo.y)){
            addPercept("rmayordomo", Literal.parseLiteral("obstaculo("+(lRMayordomo.x-1)+","+lRMayordomo.y+")"));
        }
        if(!model.esLibre(lRMayordomo.x, lRMayordomo.y+1)){
            addPercept("rmayordomo", Literal.parseLiteral("obstaculo("+lRMayordomo.x+","+(lRMayordomo.y+1)+")"));
        }
        if(!model.esLibre(lRMayordomo.x, lRMayordomo.y-1)){
            addPercept("rmayordomo", Literal.parseLiteral("obstaculo("+lRMayordomo.x+","+(lRMayordomo.y-1)+")"));
        }

        addPercept("rlimpiador", Literal.parseLiteral("posActual("+lRLimpiador.x+","+lRLimpiador.y+")"));
        if(!model.esLibre(lRLimpiador.x+1, lRLimpiador.y)){
            addPercept("rlimpiador", Literal.parseLiteral("obstaculo("+(lRLimpiador.x+1)+","+lRLimpiador.y+")"));
        }
        if(!model.esLibre(lRLimpiador.x-1, lRLimpiador.y)){
            addPercept("rlimpiador", Literal.parseLiteral("obstaculo("+(lRLimpiador.x-1)+","+lRLimpiador.y+")"));
        }
        if(!model.esLibre(lRLimpiador.x, lRLimpiador.y+1)){
            addPercept("rlimpiador", Literal.parseLiteral("obstaculo("+lRLimpiador.x+","+(lRLimpiador.y+1)+")"));
        }
        if(!model.esLibre(lRLimpiador.x, lRLimpiador.y-1)){
            addPercept("rlimpiador", Literal.parseLiteral("obstaculo("+lRLimpiador.x+","+(lRLimpiador.y-1)+")"));
        }
        if(!model.lTrash.isEmpty()){
            for(int i= 0; i<model.lTrash.size(); i++){
                addPercept("rlimpiador", Literal.parseLiteral("pos(trash,"+model.lTrash.get(i).x+","+model.lTrash.get(i).y+")"));
            }
        }

        addPercept("rbasurero", Literal.parseLiteral("posActual("+lRBasurero.x+","+lRBasurero.y+")"));
        if(!model.esLibre(lRBasurero.x+1, lRBasurero.y)){
            addPercept("rbasurero", Literal.parseLiteral("obstaculo("+(lRBasurero.x+1)+","+lRBasurero.y+")"));
        }
        if(!model.esLibre(lRBasurero.x-1, lRBasurero.y)){
            addPercept("rbasurero", Literal.parseLiteral("obstaculo("+(lRBasurero.x-1)+","+lRBasurero.y+")"));
        }
        if(!model.esLibre(lRBasurero.x, lRBasurero.y+1)){
            addPercept("rbasurero", Literal.parseLiteral("obstaculo("+lRBasurero.x+","+(lRBasurero.y+1)+")"));
        }
        if(!model.esLibre(lRBasurero.x, lRBasurero.y-1)){
            addPercept("rbasurero", Literal.parseLiteral("obstaculo("+lRBasurero.x+","+(lRBasurero.y-1)+")"));
        }

        addPercept("rpedidos", Literal.parseLiteral("posActual("+lRPedidos.x+","+lRPedidos.y+")"));
        if(!model.esLibre(lRPedidos.x+1, lRPedidos.y)){
            addPercept("rpedidos", Literal.parseLiteral("obstaculo("+(lRPedidos.x+1)+","+lRPedidos.y+")"));
        }
        if(!model.esLibre(lRPedidos.x-1, lRPedidos.y)){
            addPercept("rpedidos", Literal.parseLiteral("obstaculo("+(lRPedidos.x-1)+","+lRPedidos.y+")"));
        }
        if(!model.esLibre(lRPedidos.x, lRPedidos.y+1)){
            addPercept("rpedidos", Literal.parseLiteral("obstaculo("+lRPedidos.x+","+(lRPedidos.y+1)+")"));
        }
        if(!model.esLibre(lRPedidos.x, lRPedidos.y-1)){
            addPercept("rpedidos", Literal.parseLiteral("obstaculo("+lRPedidos.x+","+(lRPedidos.y-1)+")"));
        }

        addPercept("owner1", Literal.parseLiteral("posActual("+lOwner1.x+","+lOwner1.y+")"));
        if(!model.esLibre(lOwner1.x+1, lOwner1.y)){
            addPercept("owner1", Literal.parseLiteral("obstaculo("+(lOwner1.x+1)+","+lOwner1.y+")"));
        }
        if(!model.esLibre(lOwner1.x-1, lOwner1.y)){
            addPercept("owner1", Literal.parseLiteral("obstaculo("+(lOwner1.x-1)+","+lOwner1.y+")"));
        }
        if(!model.esLibre(lOwner1.x, lOwner1.y+1)){
            addPercept("owner1", Literal.parseLiteral("obstaculo("+lOwner1.x+","+(lOwner1.y+1)+")"));
        }
        if(!model.esLibre(lOwner1.x, lOwner1.y-1)){
            addPercept("owner1", Literal.parseLiteral("obstaculo("+lOwner1.x+","+(lOwner1.y-1)+")"));
        }

        addPercept("owner2", Literal.parseLiteral("posActual("+lOwner2.x+","+lOwner2.y+")"));
        if(!model.esLibre(lOwner2.x+1, lOwner2.y)){
            addPercept("owner2", Literal.parseLiteral("obstaculo("+(lOwner2.x+1)+","+lOwner2.y+")"));
        }
        if(!model.esLibre(lOwner2.x-1, lOwner2.y)){
            addPercept("owner2", Literal.parseLiteral("obstaculo("+(lOwner2.x-1)+","+lOwner2.y+")"));
        }
        if(!model.esLibre(lOwner2.x, lOwner2.y+1)){
            addPercept("owner2", Literal.parseLiteral("obstaculo("+lOwner2.x+","+(lOwner2.y+1)+")"));
        }
        if(!model.esLibre(lOwner2.x, lOwner2.y-1)){
            addPercept("owner2", Literal.parseLiteral("obstaculo("+lOwner2.x+","+(lOwner2.y-1)+")"));
        }

        // Percepciones de posición del agente rmayordomo
        if (model.lFridgePositions.contains(lRMayordomo)) {
                addPercept("rmayordomo", atFridge);
            }
        else if (model.lCouch1Positions.contains(lRMayordomo)) {
            addPercept("rmayordomo", atOwner1);
        }
        else if (model.lCouch2Positions.contains(lRMayordomo)) {
            addPercept("rmayordomo", atOwner2);
        }
        else if(model.lRMayordomo.equals(lRMayordomo)){
            addPercept("rmayordomo", atBaseRMayordomo);
        }
        if(model.lAlacenaPositions.contains(lRMayordomo)){
            addPercept("rmayordomo", atAlacena);
        }
        if(model.lLavavajillasPositions.contains(lRMayordomo)){
            addPercept("rmayordomo", atLavavajillas);

            // Percepción de lavavajillas encencido para el robot mayordomo
            if(model.contadorLavavajillas > 0){
                addPercept("rmayordomo", Literal.parseLiteral("lavavajillasEncendido"));
            }
        } 
        
        // Percepciones de posición del agente rlimpiador
        if (model.lBinPositions.contains(lRLimpiador)){
            addPercept("rlimpiador", atBin);

            // Percepción de cantidad de basura en el cubo para el robot limpiador
            addPercept("rlimpiador", Literal.parseLiteral("trashInBin("+model.cansInBin+")"));
        }
        if(!model.lTrash.isEmpty() && model.lTrash.contains(lRLimpiador)){
            addPercept("rlimpiador", atTrash);
        }
        else if(model.lRLimpiador.equals(lRLimpiador)){
            addPercept("rlimpiador", atBaseRLimpiador);
        }
        else if(model.lCouch1Positions.contains(lRLimpiador)){
            addPercept("rlimpiador", atOwner1);
        }
        else if(model.lCouch2Positions.contains(lRLimpiador)){
            addPercept("rlimpiador", atOwner2);
        }
        // Percepciones de posición del agente robot rbasurero
        if (model.lBinPositions.contains(lRBasurero)){
            addPercept("rbasurero", atBin);
        }
        else if(model.lRBasurero.equals(lRBasurero)){
            addPercept("rbasurero", atBaseRBasurero);
        }

        // Percepciones de posición del agente rpedidos
        if (model.lDeliveryPositions.contains(lRPedidos)){
            addPercept("rpedidos", atDelivery);
        }
        else if (model.lFridgePositions.contains(lRPedidos)) {
            addPercept("rpedidos", atFridge);
        }
        else if(model.lRPedidos.equals(lRPedidos)){
            addPercept("rpedidos", atBaseRPedidos);
        }

        // Percepciones de posición del agente owner1
        if (model.lBinPositions.contains(lOwner1)){
            addPercept("owner1", atBin);

            // Percepción de basura en el cubo para el owner1
            addPercept("owner1", Literal.parseLiteral("trashInBin("+model.cansInBin+")"));
        }
        else if(model.lCouch1.equals(lOwner1)){
            addPercept("owner1", atCouch);
        }
        else if(model.lFridgePositions.contains(lOwner1)){
            addPercept("owner1", atFridge);
        } 

        // Percepciones de posición del agente owner2
        if (model.lBinPositions.contains(lOwner2)){
            addPercept("owner2", atBin);

            // Percepción de basura en el cubo para el owner1
            addPercept("owner2", Literal.parseLiteral("trashInBin("+model.cansInBin+")"));
        }
        else if(model.lCouch2.equals(lOwner2)){
            addPercept("owner2", atCouch);
        }
        else if(model.lFridgePositions.contains(lOwner2)){
            addPercept("owner2", atFridge);
        } 

        // Percepción de stock de cervezas, pinchos y comidas para el agente mayordomo
        if (model.rmayordomoFrigorificoAbierto) {
            addPercept("rmayordomo", Literal.parseLiteral("available(beer, estrella,"+model.cervezasEstrella+")"));
            addPercept("rmayordomo", Literal.parseLiteral("available(beer, mahou,"+model.cervezasMahou+")"));
            addPercept("rmayordomo", Literal.parseLiteral("available(pincho, tortilla,"+model.pinchosTortilla+")"));
            addPercept("rmayordomo", Literal.parseLiteral("available(pincho, empanada,"+model.pinchosEmpanada+")"));
            addPercept("rmayordomo", Literal.parseLiteral("available(comida, tortilla,"+model.tortilla+")"));
            addPercept("rmayordomo", Literal.parseLiteral("available(comida, empanada,"+model.empanada+")"));
            
            // Percepción de nevera abierta
            addPercept("rmayordomo", Literal.parseLiteral("neveraAbierta"));
        }

        // Percepción de stock de cervezas para el agente owner1
        if (model.owner1FrigorificoAbierto) {
            addPercept("owner1", Literal.parseLiteral("available(beer, estrella,"+model.cervezasEstrella+")"));
            addPercept("owner1", Literal.parseLiteral("available(beer, mahou,"+model.cervezasMahou+")"));
        }

        // Percepción de stock de cervezas para el agente owner2 
        if (model.owner2FrigorificoAbierto) {
            addPercept("owner2", Literal.parseLiteral("available(beer, estrella,"+model.cervezasEstrella+")"));
            addPercept("owner2", Literal.parseLiteral("available(beer, mahou,"+model.cervezasMahou+")"));
        }

        // Percepción de platos sucios y limpios para el robot mayordomo cuando abre el lavavajillas
        if(model.lavavajillasAbierto){
            addPercept("rmayordomo", Literal.parseLiteral("platosSucios(lavavajillas,"+model.platosLavavajillasSucios+")"));
            addPercept("rmayordomo", Literal.parseLiteral("platosLimpios(lavavajillas,"+model.platosLavavajillasLimpios+")"));
        }

        // Percepción de posesión de cervezas estrella para el robot de pedidos
        if(model.rpedidosCervezasEstrella > 0){
            addPercept("rpedidos", Literal.parseLiteral("posesion(beer,estrella,"+model.rpedidosCervezasEstrella+")"));
        }

        // Percepción de posesión de cervezas mahou para el robot de pedidos
        if(model.rpedidosCervezasMahou > 0){
            addPercept("rpedidos", Literal.parseLiteral("posesion(beer,mahou,"+model.rpedidosCervezasMahou+")"));
        }

        // Percepción de posesión de tortilla para el robot de pedidos
        if(model.rpedidosTortilla > 0){
            addPercept("rpedidos", Literal.parseLiteral("posesion(comida, tortilla, "+model.rpedidosTortilla+")"));
        }

        // Percepción de posesión de empanada para el robot de pedidos
        if(model.rpedidosEmpanada > 0){
            addPercept("rpedidos", Literal.parseLiteral("posesion(comida, empanada, "+model.rpedidosEmpanada+")"));
        }

        // Percepción de basura en el entorno para el agente mayordomo
        if(model.lTrash.size() > 0){
            addPercept("rmayordomo", Literal.parseLiteral("trashInEnv("+model.lTrash.size()+")"));
            addPercept("rlimpiador", Literal.parseLiteral("trashInEnv("+model.lTrash.size()+")"));
        }

        // Percepciones de posesesión de cerveza para el robot mayordomo y el owner1
        if (model.owner1Sorbos > 0) {
            addPercept("rmayordomo", hasOwner1Beer);
            addPercept("owner1", hasBeer);
        }

        // Percepciones de posesesión de pincho para el robot mayordomo y el owner1
        if(model.owner1Mordiscos > 0){
            addPercept("rmayordomo", hasOwner1Pincho);
            addPercept("owner1", hasPincho);
        }

        // Percepciones de posesesión de cerveza para el robot mayordomo y el owner2
        if (model.owner2Sorbos > 0) {
            addPercept("rmayordomo", hasOwner2Beer);
            addPercept("owner2", hasBeer);
        }

        // Percepciones de posesesión de pincho para el robot mayordomo y el owner2
        if(model.owner2Mordiscos > 0){
            addPercept("rmayordomo", hasOwner2Pincho);
            addPercept("owner2", hasPincho);
        }
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
        System.out.println("["+ag+"] doing: "+action);
        
        boolean result = false;

        // Acción de realizar movimientos por el entorno
        if (action.getFunctor().equals("mover")){
            try {
                result = 
                    model.mover(ag, 
                                (int)((NumberTerm)action.getTerm(1)).solve(),
                                (int)((NumberTerm)action.getTerm(2)).solve()
                               );
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Acción de coger una cerveza, pincho o comida
        else if (action.getFunctor().equals("get")
            && (ag.equals("rmayordomo") 
                || ag.equals("owner1")
                || ag.equals("owner2"))){
            result = model.get(
                        ag, 
                        action.getTerm(0).toString(),
                        action.getTerm(1).toString()
                    );
        }

        // Acción de coger los pedidos de la zona de recogida
        else if(action.getFunctor().equals("getDeliver") && ag.equals("rpedidos")){
            try {
                result = model.cogerProductoDelivery(
                    action.getTerm(0).toString(),
                    action.getTerm(1).toString(),
                    (int)((NumberTerm)action.getTerm(2)).solve()
                );
            } catch (NoValueException e) {
                logger.info("Failed to execute action deliver!"+e);
            }
        }

        // Acción de encender el robot basurero
        else if (action.equals(encederRBasurero) && (ag.equals("rbasurero"))) {
            result = model.encenderRbasurero();
        } 

        // Acción de apagar el robot basurero
        else if (action.equals(apagarRBasurero) && (ag.equals("rbasurero"))) {
            result = model.apagarRBasurero();
        } 

        // Acción de abrir el frigorifico
        else if (action.equals(openFridge) 
            && (ag.equals("rmayordomo") 
            || ag.equals("owner1")
            || ag.equals("owner2"))) {
            result = model.openFridge(ag);
        } 
        
        // Acción de cerrar el frigorifico
        else if (action.equals(closeFridge) 
            && (ag.equals("rmayordomo")
            || ag.equals("owner1")
            || ag.equals("owner2"))) {
            result = model.closeFridge(ag);
        }

        // Acción de abrir el lavavajillas
        else if (action.equals(openLavavajillas) && ag.equals("rmayordomo")) {
            result = model.abrirLavavajillas();
        }

        // Acción de cerrar el lavavajillas
        else if (action.equals(closeLavavajillas) && ag.equals("rmayordomo")) {
            result = model.cerrarLavavajillas();
        }
        
        // Acción de entregar cerveza o pincho a los owners
        else if (action.getFunctor().equals("entrega")){
            if(action.getTerm(0).toString().equals("beer")){
                if(ag.equals("rmayordomo")){
                    result = model.entregaCerveza(ag, action.getTerm(1).toString());
                } else if(ag.equals("owner1") || ag.equals("owner2")){
                    result = model.entregaCerveza(ag, ag);
                }
            } else if(action.getTerm(0).toString().equals("pincho")){
                if(ag.equals("rmayordomo")){
                    result = model.entregaPincho(action.getTerm(1).toString());
                }
            }
        }
        
        // Acción de tomar la cerveza
        else if (action.equals(tomarBeer) 
            && (ag.equals("owner1") || ag.equals("owner2"))) {
            result = model.tomarBeer(ag);
        }

        // Acción de comer el pincho
        else if (action.equals(tomarPincho) 
        && (ag.equals("owner1") || ag.equals("owner2"))) {
            result = model.tomarPincho(ag);
        }

        // Acción de tirar basura en el entorno
        else if(action.equals(generarBasura) 
            && (ag.equals("owner1") || ag.equals("owner2"))){
            result = model.generarBasura();
        }
        
        // Acción de recoger basura del entorno
        else if(action.equals(pickTrash) 
            && (ag.equals("rlimpiador"))){
			result = model.pickTrash();	
		}

        // Acción de tiral la basura al cubo
        else if(action.equals(desecharTrash) 
            && (ag.equals("rlimpiador")) 
                || ag.equals("owner1") 
                || ag.equals("owner2")){
            result = model.desechar();	
        }

        // Acción de qutar los platos del lavavajillas
        else if(action.equals(quitarPlatosLavavajillas) && ag.equals("rmayordomo")){
            result = model.quitarPlatosLavavajillas();	
        }
        
        // Acción de meter los platos en la alacena
        else if(action.equals(meterPlatosAlacena) && ag.equals("rmayordomo")){
            result = model.meterPlatosAlacena();	
        }

        // Acción de vaciar el cubo de basura
        else if(action.equals(vaciarBin) && ag.equals("rbasurero")){
            result = model.vaciarPapelera();
        }

        // Acción de lavar los platos
        else if(action.equals(lavarPlatos) && ag.equals("lavavajillas")){
            result = model.lavarPlatos();
        }

        // Acción de fabricar pinchos
        else if (action.getFunctor().equals("hacerPinchos") && ag.equals("rmayordomo")) {
            result = model.hacerPinchos(action.getTerm(0).toString());
        }

        // Acción de reponer los pinchos en la nevera
        else if (action.getFunctor().equals("reponerPinchos") && ag.equals("rmayordomo")) {
            result = model.reponerPinchos(action.getTerm(0).toString());
        }

        // Acción de proveer existencias en la zona de entrega
        else if (action.getFunctor().equals("deliver") && ag.contains("supermarket")) {
            // wait 4 seconds to finish "deliver"
            try {
                Thread.sleep(4000);
                result = model.anadirProductoDelivery(
                    action.getTerm(0).toString(),
                    action.getTerm(1).toString(),
                    (int)((NumberTerm)action.getTerm(2)).solve()
                );
            } catch (Exception e) {
                logger.info("Failed to execute action deliver!"+e);
            }
        }



        // Acción de reponer las cervezas de la nevera
        else if(action.getFunctor().equals("reponer") && ag.equals("rpedidos")){
            try {
                result = model.meterProductoNevera(
                    action.getTerm(0).toString(),
                    action.getTerm(1).toString(),
                    (int)((NumberTerm)action.getTerm(2)).solve()
                );
            } catch (NoValueException e) {
                logger.info("Failed to execute action deliver!"+e);
            }
        }

        // Acción de meter los platos sucios en el lavavajillas
        else if (action.getFunctor().equals("meter")
            && ag.equals("rmayordomo")){
            try {
                result = model.meterPlatoLavavajillas((int)((NumberTerm)action.getTerm(2)).solve());
            } catch (NoValueException e) {
                e.printStackTrace();
            }
        }

        // Error en la realización de alguna acción
        else {
            logger.info("Failed to execute action "+action);
        }

        if (result) {
            updatePercepts();
            try {
                Thread.sleep(100);
            } catch (Exception e) {}
        }
        return result;
    }
}