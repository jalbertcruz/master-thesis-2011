package lang.ui.control;

import lang.ui.control.common.CaparazonParaDosBloquesDeInstrucciones;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Bloque;
import lang.ui.base.huecos.Expresion;
import javafx.scene.layout.Stack;
import lang.ui.control.si_entonces_sino.*;
import javafx.util.Math;
import tiposPrimitivos.Logico;
import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import java.lang.Void;
import java.util.ArrayList;

public class SiEntoncesSino extends CaparazonParaDosBloquesDeInstrucciones, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Rama("void");
        def al = new ArrayList();
        def hs = new ast.HSentencia();
        def ramas = new ArrayList();
        for(inst in instrucciones_Si.content){
            ramas.add((inst as ast.ASTCreador).crearRama(tds));
        }
        for(inst in instrucciones_Sino.content){
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
        res
    }


    //impl: 100 %
    override public function traducir(): String {
        var res = " if (({(condicion.content[sizeof condicion.content - 1] as Bloque).traducir()}).valor()) then ";
        for (i in instrucciones_Si.content)
            res += "\n\r  {(i as Bloque).traducir()}";
        res += "\n\r else";
        for (i in instrucciones_Sino.content)
            res += "\n\r  {(i as Bloque).traducir()}";
        "{res}\n\r end"
    }

    override public function actualizarPosiciones(): Void {
        def _inst = instrucciones_Si;
        instrucciones_Si = null;
        instrucciones_Si = _inst;

        def _instSino = instrucciones_Sino;
        instrucciones_Sino = null;
        instrucciones_Sino = _instSino;

        encabezado.actualizarPosiciones();
        cuerpo1.actualizarPosiciones();
        cuerpo2.actualizarPosiciones();

        ancho = Math.max(cuerpo2.ancho + grosor, Math.max(encabezado.ancho, cuerpo1.ancho + grosor));
        alto = a + grosor + super.todoElcuerpo.boundsInParent.height;
        a = encabezado.alto;

        (cuerpo1 as SiSinoCuerpoSi).espacio.ancho = ancho - grosor;
        (cuerpo2 as SiSinoCuerpoSino).espacio.ancho = ancho - grosor;

        super.actualizarPosiciones();
    }

    override public function mkNode(): Node {
        def res = SiEntoncesSino {
                    grosor: grosor
                }
        res.actualizarPosiciones();
        res
    }

    public override def clasificacion = "EstructuraDeControl" on replace { }
    public override def mangos = bind [(encabezado as SiSinoEncabezado).mangos];
    def condicion = Stack {}
    public override def encabezado = bind SiSinoEncabezado {
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
    var instrucciones_Si: VBox = VBox {}
    public override var cuerpo1 = SiSinoCuerpoSi {
                def accionEstandar = function(b: Bloque): Void {
                            b.huecoClicked = huecoClicked;
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            var nt: Node[] = instrucciones_Si.content;
                            instrucciones_Si.content = [];
                            insert (b as Node) into nt;
                            instrucciones_Si = VBox {
                                        content: nt
                                    }
                        }
                instruccionesVBox: bind instrucciones_Si
                espacio: SiSinoHueco {
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
    var instrucciones_Sino: VBox = VBox {}
    public override var cuerpo2 = SiSinoCuerpoSino {
                def accionEstandar = function(b: Bloque): Void {
                            b.huecoClicked = huecoClicked;
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            var nt: Node[] = instrucciones_Sino.content;
                            instrucciones_Sino.content = [];
                            insert (b as Node) into nt;
                            instrucciones_Sino = VBox {
                                        content: nt
                                    }
                        }
                instruccionesVBox: bind instrucciones_Sino
                espacio: SiSinoHueco {
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
//        etiqueta = "Sino";
        huecos = [(cuerpo1 as SiSinoCuerpoSi).espacio, (cuerpo2 as SiSinoCuerpoSino).espacio, (encabezado as SiSinoEncabezado).cond];
        actualizarHuecos = function(): Void {
                    huecos = [(cuerpo1 as SiSinoCuerpoSi).espacio, (cuerpo2 as SiSinoCuerpoSino).espacio];
                    if (condicion.content == [])
                        insert (encabezado as SiSinoEncabezado).cond into huecos;
                }
        actualizarPosiciones();
    }

}

