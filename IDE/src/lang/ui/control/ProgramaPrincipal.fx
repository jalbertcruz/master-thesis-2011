package lang.ui.control;

import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import lang.ui.base.Bloque;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.control.common.CaparazonParaUnBloqueDeInstrucciones;
import lang.ui.control.programa_principal.ProgramaPrincipalEncabezado;
import lang.ui.control.programa_principal.ProgramaPrincipalCuerpo;
import lang.ui.control.programa_principal.ProgramaPrincipalHueco;
import lang.ui.base.Rutina;
import javafx.util.Math;
import lang.model.Variable;
import com.sun.javafx.runtime.sequence.Sequence;
import java.util.ArrayList;

public class ProgramaPrincipal extends Rutina, ast.ASTCreador {

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

        def hDeclaraciones = new ast.HSentencia();
        def rDeclaraciones = new ArrayList();
        def enc = encabezado as ProgramaPrincipalEncabezado;
        for(inst in enc.varLocales.content){
            ramas.add((inst as ast.ASTCreador).crearRama(tds));
        }
        hDeclaraciones.setRamas(rDeclaraciones);
        // las declaraciones
        al.add(hDeclaraciones);
        
        res.setHuecos(al);
        res.setReglaSemantica(res.mkReglaExpresion(tds));
        res
    }

    //impl: 100 %
    override public function traducir(): String {
        var res = "";
        for(i in instrucciones.content)
            res += "\n\r{(i as Bloque).traducir()}";
        res
    }

    override public function getParametrosFormales(): Variable[] {
        []
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

    override public function mkNode(): Node {
        ProgramaPrincipal {
            grosor: grosor
        }
    }

    public override def clasificacion = "ProgramaPrincipal" on replace { }
    public override def mangos = bind [(encabezado as ProgramaPrincipalEncabezado).mango];

    override public function compilar(ts: ast.TablaDeSimbolos): Void {
        def obj = (this as ast.ASTCreador).crearRama(ts);
        (encabezado as ProgramaPrincipalEncabezado).desactivado = not obj.ejecutable();
    //TODO: compilar.ProgramaPrincipal
    // variablesLocales = (encabezado as ProgramaPrincipalEncabezado).getVariablesLocales();
    }

    override public function getVariablesLocales(): Variable[] {
        return (encabezado as ProgramaPrincipalEncabezado).getVariablesLocales();
    }

    public var ejecutarClicked: function(): Void;

    public override def encabezado = bind ProgramaPrincipalEncabezado {
                layoutX: 6
                layoutY: 4
                huecoClicked: bind huecoClicked
                ejecutarClicked: bind ejecutarClicked
                huecoMouseEntered: bind huecoMouseEntered
            } on replace { }
    public override def huecos = bind [(cuerpo as ProgramaPrincipalCuerpo).espacio, encabezado.huecos];
    var instrucciones: VBox = VBox {}
    public override var cuerpo = ProgramaPrincipalCuerpo {
                def accionEstandar = function(b: Bloque): Void {
//                            if (b.parent != instrucciones) {
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
                        //insert (b as Node) into instrucciones.content;
//                            }
                        }
                layoutX: bind grosor
                layoutY: bind a
                instruccionesVBox: bind instrucciones // with inverse
                espacio: ProgramaPrincipalHueco {
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
                            tipo: "Orden"
                            accion: accionEstandar
                        }
                    ]
                }
            }
}
