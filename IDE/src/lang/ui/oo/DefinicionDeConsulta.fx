package lang.ui.oo;

import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.util.Math;
import lang.ui.base.Bloque;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Rutina;
import lang.model.Variable;
import lang.ui.oo.consulta.*;

public class DefinicionDeConsulta  extends Rutina {

    override public function getParametrosFormales(): Variable[] {
        (encabezado as ConsultaEncabezado).getParametrosFormales()
    }

    override public function getVariablesLocales(): Variable[] {
        (encabezado as ConsultaEncabezado).getVariablesLocales()
    }

    override public function compilar(ts: ast.TablaDeSimbolos): Void {
    //TODO: DefinicionDeOrden.compilar
    }

    override public function actualizarPosiciones(): Void {
        def _inst = instrucciones;
        instrucciones = null;
        instrucciones = _inst;
        super.actualizarPosiciones();
        encabezado.actualizarPosiciones();
        cuerpo.actualizarPosiciones();

        alto = a + grosor + cuerpo.alto;
        ancho = Math.max(encabezado.ancho, cuerpo.ancho + grosor);
        a = encabezado.alto;
    }

//    override public def ancho = bind Math.max(encabezado.ancho, cuerpo.ancho + grosor) on replace { }
//    override public def alto = bind a + grosor + cuerpo.alto on replace {
//    }
//    override def a = bind encabezado.alto on replace { }
    override public function mkNode(): Node {
        DefinicionDeConsulta {
            grosor: grosor
        }
    }

    public function getFocus(): Void {
        (encabezado as ConsultaEncabezado).getFocus();
    }

    public var consultaCreada: function(: String): Void;
    public override def clasificacion = ["Definición"] on replace { }
    public override def encabezado = bind ConsultaEncabezado {
                consultaCreada: bind consultaCreada
                huecoClicked: bind huecoClicked
            } on replace { }
    var instrucciones: VBox = VBox {}
    public override var cuerpo = bind ConsultaCuerpo {
                def accionEstandar =  function(b: Bloque): Void {
                            b.huecoClicked = huecoClicked;
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            var nt: Node[] = instrucciones.content;
                            instrucciones.content = [];
                            insert (b as Node) into nt;
                            instrucciones = VBox {
                                        content: nt
                                    }
//                            reposicionar();
                        }
                layoutX: bind grosor
                layoutY: bind a
                instruccionesVBox: bind instrucciones
                espacio: ConsultaHueco {
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
                    ancho: bind ancho - grosor
                    alto: 10
                    color: Color.rgb(140, 198, 63)

                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: "EstructuraDeControl"
                            accion: accionEstandar
                        }
                        AccionBloquePorTipo {
                            tipo: "Asignación"
                            accion: accionEstandar
                        }
                        AccionBloquePorTipo {
                            tipo: "LlamadoRutina"
                            accion: accionEstandar
                        }
                    ]
                }
            }
//    public override def mangos = bind [(encabezado as ConsultaEncabezado).mango] on replace { }
//    public override def huecos = bind [(cuerpo as ConsultaCuerpo).espacio, (encabezado as ConsultaEncabezado).huecos] on replace { }

    init {
        //        reposicionar = function(): Void {
        //                    encabezado.reposicionar();
        //                    cuerpo.reposicionar();
        ////                    def _cuerpo = cuerpo;
        ////                    cuerpo = null;
        ////                    cuerpo = _cuerpo;
        //                }
        mangos = [(encabezado as ConsultaEncabezado).mango];
        huecos = (encabezado as ConsultaEncabezado).huecos;
        insert (cuerpo as ConsultaCuerpo).espacio into huecos;

        esExpresion = true;

    }


}
