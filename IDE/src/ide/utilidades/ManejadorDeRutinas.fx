package ide.utilidades;

import javafx.scene.CustomNode;
import javafx.scene.control.ScrollView;
import javafx.scene.layout.Tile;
import javafx.scene.Node;
import javafx.scene.control.ScrollBarPolicy;
import javafx.scene.layout.VBox;
import javafx.scene.shape.Rectangle;
import java.lang.String;
import java.lang.Void;
import lang.ui.control.ProgramaPrincipal;
import lang.ui.base.Rutina;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import java.lang.System;
import javafx.scene.text.Text;
import refleccion.TypesBuilder;

public class ManejadorDeRutinas extends CustomNode {

    public var constructorDeTipos: TypesBuilder on replace {
            }
    var pp: ProgramaPrincipal;
    public-read var objetos: Rutina[] = [
                pp = ProgramaPrincipal {
                            fillColor: ColoresIDE.programaPrincipal
                            grosor: 30
                            huecoMouseEntered: mostrarDescripcion
                            ejecutarClicked: function() {
//                                println(pp.traducir());
                                constructorDeTipos.ejecuta(pp.traducir());
                            }
                        }
            ];
    public var cambioRealizado: function(: Rutina): Void;
    public def rutinaActual: Rutina = bind
            if (creandoRutina) then
                nuevaRutina else
                objetos[indice]
            on replace old {
                cambioRealizado(old);
            }
    var tileValues: Node[] = [ //                Button {
            //                    text: "Programa principal"
            //                    action: function(): Void {
            //                        indice = 0;
            //                        creandoRutina = false;
            //                    }
            //                }
            //                Button {
            //                    text: "Nueva orden"
            //                    action: function(): Void {
            //                        nuevaRutina = DefinicionDeOrden {
            //                                    grosor: 30
            //                                    huecoMouseEntered: mostrarDescripcion
            //                                    ordenCreada: function(nom: String): Void {
            //                                        insert nuevaRutina into objetos;
            //                                        def ind = sizeof tileValues - 2;
            //                                        creandoRutina = false;
            //                                        def bt = Button {
            //                                                    text: "orden: {nom}"
            //                                                    action: function(): Void {
            //                                                        indice = ind;
            //                                                        creandoRutina = false;
            //                                                    }
            //                                                }
            //                                        insert bt into tileValues;
            //                                        indice = ind;
            //                                    }
            //                                }
            //                        creandoRutina = true;
            //                        (nuevaRutina as DefinicionDeOrden).getFocus();
            //                    }
            //                }
            //                Button {
            //                    text: "Nueva consulta"
            //                    action: function(): Void {
            //                        nuevaRutina = DefinicionDeConsulta {
            //                                    grosor: 30
            //                                    huecoMouseEntered: mostrarDescripcion
            //                                    consultaCreada: function(nom: String): Void {
            //                                        insert nuevaRutina into objetos;
            //                                        def ind = sizeof tileValues - 2;
            //                                        creandoRutina = false;
            //                                        def bt = Button {
            //                                                    text: "consulta: {nom}"
            //                                                    action: function(): Void {
            //                                                        indice = ind;
            //                                                        creandoRutina = false;
            //                                                    }
            //                                                }
            //                                        insert bt into tileValues;
            //                                        indice = ind;
            //                                    }
            //                                }
            //                        creandoRutina = true;
            //                        (nuevaRutina as DefinicionDeConsulta).getFocus();
            //                    }
            //                }
            ];

    function mostrarDescripcion(desc: String): Void {
        descripcionHuecoActual.content = desc;
    }

    public-init var descripcionHuecoActual: Text;
    var creandoRutina = false;
    var indice = 0;
    var nuevaRutina: Rutina;
    public override def children = bind VBox {
                spacing: 8
                content: [
                    Rectangle {
                        width: 500
                        height: 600
                        visible: false
                    }
                    ScrollView {
                        width: 500
                        height: 600
                        pannable: false
                        managed: false
                        hbarPolicy: ScrollBarPolicy.AS_NEEDED
                        vbarPolicy: ScrollBarPolicy.AS_NEEDED
                        node: bind if (creandoRutina) then nuevaRutina else objetos[indice];
                    }
                    Tile {
                        content: bind tileValues
                    }
                ]
            }

    init {

        Timeline {
            autoReverse: false
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame {
                    time: 100ms
                    action: function(): Void {
                        rutinaActual.actualizarPosiciones();

                        def ts = new ast.TablaDeSimbolos();
                        var i = 0;
                        while (i < constructorDeTipos.objetosDisponibles().size()) {
                            ts.adicionar(constructorDeTipos.objetosDisponibles().get(0).getNombre(),
                            constructorDeTipos.objetosDisponibles().get(0).getObjeto().getClass().getInterfaces()[0].getName());
                            i++;
                        }
//                        rutinaActual.compilar(ts);
                        
                        if (cantIteraciones > 50000) {
                            cantIteraciones = 0;
                            System.runFinalization();
                            System.gc();
                        }
                        cantIteraciones++;
                    }
                }
            ]
        }.play();


    }

    var cantIteraciones = 0;
}
