package lang.ui.control.programa_principal;

import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import lang.ui.base.Bloque;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.oo.common.LugarParaDeclaracionDeVariables;
import lang.ui.oo.common.huecos.DeclaracionDeVariablesHueco;
import lang.ui.base.Hueco;
import lang.model.Variable;
import lang.ui.base.bloques.DeclaracionDeVariable;
import lang.model.Arreglo;
import ide.utilidades.ColoresIDE;

public class ProgramaPrincipalEncabezado extends Bloque {

    public var ejecutarClicked: function(): Void;

    override public function actualizarPosiciones(): Void {
        def t = vb.content;
        vb.content = [];
        vb = VBox { content: t }
    }

//    var variablesLocalesAnteriores: Variable[] = [];
    public function getVariablesLocales(): Variable[] {
        var res: Variable[];
        for (vl in varLocales.content) {
            def dv = vl as DeclaracionDeVariable;
            if (dv.variableDeclarada) {
                if (dv.esSecuencia) {
                    insert Arreglo {
                        nombre: dv.nombre
                        tipo: dv.tipo
                    } into res;
                } else {
                    insert Variable {
                        nombre: dv.nombre
                        tipo: dv.tipo
                    } into res;

                }
            }
        }
        //        println("variables calculadas: {sizeof res}");
        return res;
    //        if (variablesLocalesAnteriores == []) {
    //            return res;
    //        } else {
    //            var f = true;
    //            var i = 0;
    //            def l = sizeof res;
    //            while (f and i < l) {
    //                if (not (res[i].tipo.equals(variablesLocalesAnteriores[i].tipo) and res[i].nombre.equals(variablesLocalesAnteriores[i].nombre))) {
    //                    f = false;
    //                }
    //                i++;
    //            }
    //            if (not f) {
    //                variablesLocalesAnteriores = res;
    //            }
    //            return variablesLocalesAnteriores;
    //        }

    }

    public def mango: Node = Text {
                content: "Programa                                                  "
                //content: "Programa principal                                      "
            };
    def botones = [
//                Button {
//                    text: "Compilar"
//                }
                Button {
                    text: "Ejecutar"
                    action: function() { ejecutarClicked() }
                    disable: bind desactivado
                }
            ];

    public var desactivado: Boolean = false;

    public var varLocales: VBox = VBox {}
    def _varLocales = bind LugarParaDeclaracionDeVariables {
                contenido: bind varLocales
                declaracionDeVariablesHueco: DeclaracionDeVariablesHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: 200
                    alto: 10
                    color: ColoresIDE.declaracionVariables
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "DeclaraciónDeVariable"
                            accion: function(b: Bloque): Void {
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;

                                var nt: Node[] = varLocales.content;
                                varLocales.content = [];
                                insert (b as Node) into nt;
                                varLocales = VBox {
                                            content: nt
                                        }
                            }
                        }
                    ]
                }
            }
    var vb = VBox {
                spacing: 5
                content: [
                    HBox {
                        spacing: 5
                        content: [
                            mango,
                            botones
                        ]
                    }
                    _varLocales,
                    Text {
                        content: "Acciones:"
                    }
                ]
            }
    public override var hijos = bind vb;
    public override def alto = bind vb.boundsInParent.height + 15;
    public override def ancho = bind vb.boundsInParent.width + 20;
    public override var huecos: Hueco[] = bind [_varLocales.huecos] on replace { }

    init {
    //        reposicionar = function(): Void {
    //                    _varLocales.reposicionar();
    //                    def t = vb.content;
    //                    vb.content = [];
    //                    vb = VBox {
    //                                content: t
    //                            }
    //                }
    }

}
