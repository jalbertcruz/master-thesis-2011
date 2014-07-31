package lang.ui.oo.orden;

import lang.ui.base.Bloque;
import lang.ui.oo.common.NombreDefinicionRutina;
import lang.ui.oo.common.LugarParaDeclaracionDeParametros;
import lang.ui.oo.common.LugarParaPrecondiciones;
import lang.ui.oo.common.LugarParaPostcondiciones;
import lang.ui.oo.common.LugarParaDeclaracionDeVariables;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import lang.ui.oo.common.huecos.ParametrosHueco;
import lang.ui.base.acciones.AccionBloquePorTipo;
import javafx.scene.Node;
import lang.ui.oo.common.huecos.PrecondicionesHueco;
import javafx.scene.paint.Color;
import lang.ui.oo.common.huecos.PostcondicionesHueco;
import lang.ui.oo.common.huecos.DeclaracionDeVariablesHueco;
import lang.ui.base.Hueco;
import lang.model.Arreglo;
import lang.model.Variable;
import lang.ui.base.bloques.DeclaracionDeVariable;

public class OrdenEncabezado extends Bloque {

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
        return res;
    }

    public function getParametrosFormales(): Variable[] {
        var res: Variable[];
        for (vl in centrada.content) {
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
        return res;
    }

    override public function actualizarPosiciones(): Void {
        def t = vb.content;
        vb.content = [];
        vb = VBox { content: t }
    }

    public function getFocus(): Void {
        _nombre.getFocus();
    }

    public var ordenCreada: function(: String): Void;
    public def mango: Node = bind _nombre.mango;
    def _nombre = NombreDefinicionRutina {
                tipoRutina: "Orden"
                nombreDefinido: bind ordenCreada
            }
    var centrada: VBox = VBox {}
    def _entrada = bind LugarParaDeclaracionDeParametros {
                contenido: bind centrada
                parametrosHueco: ParametrosHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: 200
                    alto: 10
                    color: Color.BLACK
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "DeclaraciónDeVariable"
                            accion: function(b: Bloque): Void {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;
                                var nt: Node[] = centrada.content;
                                centrada.content = [];
                                insert (b as Node) into nt;
                                centrada = VBox {
                                            content: nt
                                        }
                            }
                        }
                    ]
                }
            }
    var cpre: VBox = VBox {}
    def _pre = LugarParaPrecondiciones {
                contenido: bind cpre
                precondicionesHueco: PrecondicionesHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: 200
                    alto: 10
                    color: Color.RED
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "Lógico"
                            accion: function(b: Bloque): Void {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;

                                var nt: Node[] = cpre.content;
                                cpre.content = [];
                                insert (b as Node) into nt;
                                cpre = VBox {
                                            content: nt
                                        }

                            }
                        }
                    ]
                }
            }
    var cpos: VBox = VBox {}
    def _pos = LugarParaPostcondiciones {
                contenido: bind cpos
                postcondicionesHueco: PostcondicionesHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: 200
                    alto: 10
                    color: Color.RED
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "Lógico"
                            accion: function(b: Bloque): Void {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;

                                var nt: Node[] = cpos.content;
                                cpos.content = [];
                                insert (b as Node) into nt;
                                cpos = VBox {
                                            content: nt
                                        }

                            }
                        }
                    ]
                }
            }
    var varLocales: VBox = VBox {}
    def _varLocales = bind LugarParaDeclaracionDeVariables {
                contenido: bind varLocales
                declaracionDeVariablesHueco: DeclaracionDeVariablesHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: 200
                    alto: 10
                    color: Color.BLACK
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "DeclaraciónDeVariable"
                            accion: function(b: Bloque): Void {
                                b.huecoClicked = huecoClicked;
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
                content: [
                    _nombre,
                    _entrada,
                    _pre,
                    _pos,
                    _varLocales,
                    Text {
                        content: "Acciones:"
                    }
                ]
            }

    init {
    //        reposicionar = function(): Void {
    //                    _entrada.reposicionar();
    //                    _pre.reposicionar();
    //                    _pos.reposicionar();
    //                    _varLocales.reposicionar();
    //                    def t = vb.content;
    //                    vb.content = [];
    //                    vb = VBox {
    //                                content: t
    //                            }
    //                }
    }

    public override var huecos: Hueco[] = bind [_entrada.huecos, _pre.huecos,
                _pos.huecos, _varLocales.huecos] on replace { }
    public override var hijos = bind vb on replace { }
    public override def alto = bind vb.boundsInParent.height on replace { }
    public override def ancho = bind vb.boundsInParent.width on replace {
            //println("ancho en encabezado:{ancho}");
            }
}
