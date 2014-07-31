package ide.tests;

import javafx.scene.Group;
import javafx.scene.Scene;
import ide.Papelera;
import ide.utilidades.SelectorDeBloques;
import ide.utilidades.ManejadorDeRutinas;
import refleccion.TypesBuilder;
import javafx.scene.text.Text;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;

def g = Group {}
def papelera = Papelera {
            layoutX: 515
            layoutY: 5
        }
def descripcionHuecoActual = Text {
            layoutY: 680
            layoutX: 500
        }

def constructorDeTipos = new TypesBuilder();

def mr: ManejadorDeRutinas = ManejadorDeRutinas {
            descripcionHuecoActual: descripcionHuecoActual
            constructorDeTipos: constructorDeTipos
        }

var lbs: Label[];
public var sc: Scene =
        Scene {
            width: 800
            height: 600
            content: [
                VBox{
                    content: bind lbs
                }
                g,
                //papelera,
                descripcionHuecoActual,
                SelectorDeBloques {
                            nuevaLabel: function(): Label {
                                def l = Label {
                                            visible: false
                                            text: "   "
                                        }
                                insert l into lbs;
                                return l;
                            }
                            constructorDeTipos: constructorDeTipos
                            descripcionHuecoActual: descripcionHuecoActual
                            layoutX: 510
                            layoutY: 3
//                            layoutY: 65
                            papelera: papelera
                            manejadorDeRutinas: mr
                            grupoMaestro: g
                        }
                mr
            ];
        }
