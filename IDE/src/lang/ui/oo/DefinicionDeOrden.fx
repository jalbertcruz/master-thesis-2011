package lang.ui.oo;

import lang.ui.control.common.CaparazonParaUnBloqueDeInstrucciones;
import lang.ui.oo.orden.OrdenEncabezado;
import lang.ui.oo.orden.OrdenCuerpo;
import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import lang.ui.base.Bloque;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.oo.orden.OrdenHueco;
import lang.ui.base.Rutina;
import javafx.util.Math;
import com.sun.javafx.runtime.sequence.Sequence;
import lang.model.Variable;

public class DefinicionDeOrden extends Rutina {

    override public function getParametrosFormales(): Variable[] {
        (encabezado as OrdenEncabezado).getParametrosFormales()
    }

    override public function getVariablesLocales(): Variable[] {
        (encabezado as OrdenEncabezado).getVariablesLocales()
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
        DefinicionDeOrden {
            grosor: grosor
        }
    }

    public function getFocus(): Void {
        (encabezado as OrdenEncabezado).getFocus();
    }

    public var ordenCreada: function(: String): Void;
    public override def clasificacion = ["Definición"] on replace { }
    public override def encabezado = bind OrdenEncabezado {
                ordenCreada: bind ordenCreada
                huecoClicked: bind huecoClicked
            } on replace { }
    var instrucciones: VBox = VBox {}
    public override var cuerpo = bind OrdenCuerpo {
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
                espacio: OrdenHueco {
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

    init {
        mangos = [(encabezado as OrdenEncabezado).mango];
        huecos = (encabezado as OrdenEncabezado).huecos;
        insert (cuerpo as OrdenCuerpo).espacio into huecos;

    }

}
