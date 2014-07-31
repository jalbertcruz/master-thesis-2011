package lang.ui.control;

import lang.ui.control.common.CaparazonParaUnBloqueDeInstrucciones;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Bloque;
import javafx.scene.paint.Color;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import lang.ui.base.huecos.Expresion;
import javafx.scene.layout.Stack;
import lang.ui.control.si_entonces.*;
import javafx.util.Math;
import tiposPrimitivos.Logico;
import java.util.ArrayList;

public class SiEntonces extends CaparazonParaUnBloqueDeInstrucciones, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Rama("void");
        def al = new ArrayList();
        def hs = new ast.HSentencia();
        def ramas = new ArrayList();
        for(inst in instrucciones.content){
            ramas.add((inst as ast.ASTCreador).crearRama(tds));
        }
        hs.setRamas(ramas);
        // el cuerpo de instrucciones
        al.add(hs);

        // la condicion
        def heCondicion = new ast.HExpresion(Logico.class.getName());
        if (sizeof condicion.content > 0){
            heCondicion.setRama((condicion.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(heCondicion);
        res.setHuecos(al);
        res.setReglaSemantica(res.mkReglaExpresion(tds));

        println(res.ejecutable());
        res
    }

    //impl: 100 %
    override public function traducir(): String {
        var res = " if (({(condicion.content[sizeof condicion.content - 1] as Bloque).traducir()}).valor()) then ";
        for (i in instrucciones.content)
            res += "\n\r {(i as Bloque).traducir()}";
        "{res}\n\r end"
    }

    override public function actualizarPosiciones(): Void {
        def _inst = instrucciones;
        instrucciones = null;
        instrucciones = _inst;

        encabezado.actualizarPosiciones();
        cuerpo.actualizarPosiciones();

        ancho = Math.max(encabezado.ancho, cuerpo.ancho + grosor);
        alto = a + grosor + cuerpo.alto;
        a = encabezado.alto;

        (cuerpo as SiCuerpo).espacio.ancho = ancho - grosor;
        super.actualizarPosiciones();
    }

    override public function mkNode(): Node {
        def res = SiEntonces {
                    grosor: grosor
                }
        res.actualizarPosiciones();
        res
    }

    public override def clasificacion = "EstructuraDeControl" on replace { }
    public override def mangos = bind [(encabezado as SiEncabezado).mangos];
    def condicion = Stack {}
    public override def encabezado = bind SiEncabezado {
                layoutX: 6
                layoutY: 4
                cond: Expresion {
                    huecoClicked: bind huecoClicked
                    descripcion: "Lugar para la expresión lógica que determinará si se hacen o no las instrucciones"
                    huecoMouseEntered: bind huecoMouseEntered
                    contenido: bind condicion
                    tipo: Logico.class
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: Logico.class.getName()
                            accion: function(b: Bloque) {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;
                                insert (b as Node) into condicion.content;
                            }
                        }
                    ]
                }
            } on replace { }
    var instrucciones: VBox = VBox {}
    public override var cuerpo = SiCuerpo {
                def accionEstandar = function(b: Bloque): Void {
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
                        }
                layoutX: bind grosor
                layoutY: bind a
                instruccionesVBox: bind instrucciones
                espacio: SiHueco {
                    ancho: 100
                    alto: 10
                    color: Color.rgb(140, 198, 63)
                    huecoClicked: bind huecoClicked
                    huecoMouseEntered: bind huecoMouseEntered
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
                            tipo: "Orden"
                            accion: accionEstandar
                        }
                    ]
                }
            }

    init {
        huecos = [(cuerpo as SiCuerpo).espacio, (encabezado as SiEncabezado).cond];
        actualizarHuecos = function(): Void {
                    huecos = [(cuerpo as SiCuerpo).espacio];
                    if (condicion.content == [])
                        insert (encabezado as SiEncabezado).cond into huecos;
                }
        actualizarPosiciones();
    }

}
