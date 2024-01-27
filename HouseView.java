import jason.environment.grid.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;

/** class that implements the View of Domestic Robot application */
public class HouseView extends GridWorldView {

    HouseModel hmodel;

    public HouseView(HouseModel model) {
        super(model, "Domestic Robot", 700);
        hmodel = model;
        defaultFont = new Font("Arial", Font.BOLD, 10); // change default font
        setVisible(true);
        //repaint();
    }

    /** draw application objects */
    @Override
    public void draw(Graphics g, int x, int y, int object) {
        super.drawAgent(g, x, y, Color.lightGray, -1);

        // Dibujado de los elementos que no son agentes
        switch (object) {
        
            // Dibujado del frigorifico
            case HouseModel.FRIDGE:
                super.drawAgent(g, x, y, Color.WHITE, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont,
                    "F:"
                    +hmodel.cervezasEstrella 
                    + "," +hmodel.cervezasMahou
                    + "," +hmodel.pinchosTortilla
                    + "," +hmodel.pinchosEmpanada
                    + "," +hmodel.tortilla
                    + "," +hmodel.empanada);
                break;

            // Dibujado del sillón del owner
            case HouseModel.COUCH1:
                super.drawAgent(g, x, y, Color.PINK, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, "Couch");
                break;

            case HouseModel.COUCH2:
                super.drawAgent(g, x, y, Color.PINK, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, "Couch");
                break;

            // Dibujado de la zona de entrega
            case HouseModel.DELIVERY:
                super.drawAgent(g, x, y, Color.GRAY, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, 
                    "D("+hmodel.entregaCervezasEstrella
                    +"," + hmodel.entregaCervezasMahou
                    +"," + hmodel.entregaTortilla
                    +"," + hmodel.entregaEmpanada
                    + ")");
                break;
            
            // Dibujado del cubo de basura
            case HouseModel.BIN:
                super.drawAgent(g, x, y, Color.GREEN, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, 
                "B("+hmodel.cansInBin+"/3)"
                
                );
                break;

            // Dibujado de la basura repartida por el entorno
            case HouseModel.TRASH:
                super.drawAgent(g, x, y, Color.LIGHT_GRAY, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, "Trash");
                break;
            
            // Dibujado del lavavajillas
            case HouseModel.LAVAVAJILLAS:
                String lav = "L";

                lav +=  "("+hmodel.platosLavavajillasLimpios+","+hmodel.platosLavavajillasSucios+"/4)";
                
                if(hmodel.contadorLavavajillas > 0){
                    lav += "("+hmodel.contadorLavavajillas+")";
                }

                super.drawAgent(g, x, y, Color.CYAN, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, lav);
                break;
            
            // Dibujado de la alcena
            case HouseModel.ALACENA:    
                super.drawAgent(g, x, y, Color.magenta, -1);
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, "A("+hmodel.platosAlacena+"/10)");
                break;
        }
        //repaint();
    }

    @Override
    public void drawAgent(Graphics g, int x, int y, Color c, int id) {

        // Dibujado de los elementos que son agentes
        switch(id){

            // Dibujado del agente rmayordomo
            case 0:
                c = Color.yellow;
                if (hmodel.rmayordomoLlevaPincho) c = Color.orange;
                super.drawAgent(g, x, y, c, -1);
                g.setColor(Color.black);
                super.drawString(g, x, y, defaultFont, "May");
                break;

            // Dibujado del agente rlimpiador
            case 1:
                c = Color.ORANGE;
                super.drawAgent(g, x, y, c, -1);
                g.setColor(Color.black);
                super.drawString(g, x, y, defaultFont, "Limp");
                break;
            
            // Dibujado del agente rbasurero
            case 2:
            c = Color.red;
            if (hmodel.rbasureroEncendido) c = Color.green;
                super.drawAgent(g, x, y, c, -1);
                g.setColor(Color.black);
                super.drawString(g, x, y, defaultFont, "Bas");
                break;

            // Dibujado del agente rpedidos
            case 3:
                c = Color.magenta;
                super.drawAgent(g, x, y, c, -1);
                g.setColor(Color.black);
                super.drawString(g, x, y, defaultFont, "Ped");
                break;

            // Dibujado del agente owner1
            case 4: 
                super.drawAgent(g, x, y, Color.BLUE, -1);
                String o1 = "O1";
                if (hmodel.owner1Sorbos > 0) {
                    o1 +=  "(B:"+hmodel.owner1Sorbos+")";
                }
                if(hmodel.owner1Mordiscos > 0){
                    o1 +=  "(P:"+hmodel.owner1Mordiscos+")";
                }
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, o1);
                break;

            // Dibujado del agente owner2
            case 5: 
                super.drawAgent(g, x, y, Color.BLUE, -1);
                String o2 = "O2";
                if (hmodel.owner2Sorbos > 0) {
                    o2 +=  "(B:"+hmodel.owner2Sorbos+")";
                }
                if(hmodel.owner2Mordiscos > 0){
                    o2 +=  "(P:"+hmodel.owner2Mordiscos+")";
                }
                g.setColor(Color.black);
                drawString(g, x, y, defaultFont, o2);
                break;
        }
    }

    @Override
    public void drawEmpty(Graphics g, int x, int y){
        g.setColor(new Color(0xEEEEEE));
        g.fillRect(x * cellSizeW + 1, y * cellSizeH+1, cellSizeW-1, cellSizeH-1);
        g.setColor(Color.lightGray);
        g.drawRect(x*cellSizeW, y*cellSizeH, cellSizeW, cellSizeH);
    }
}