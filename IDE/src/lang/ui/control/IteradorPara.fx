package lang.ui.control;

import lang.ui.control.common.CaparazonParaUnBloqueDeInstrucciones;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Bloque;
import javafx.scene.paint.Color;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import lang.ui.control.iterador_para.*;
import javafx.util.Math;
import java.util.ArrayList;
import tiposPrimitivos.Numero;

public class IteradorPara extends CaparazonParaUnBloqueDeInstrucciones, ast.ASTCreador {

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

        // la variable
        def hePara = new ast.HExpresion(Numero.class.getName());
        def enc = encabezado as ParaEncabezado;
        if (sizeof enc._para.content > 0){
            hePara.setRama((enc._para.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(hePara);
        // cota inferior
        def heDesde = new ast.HExpresion(Numero.class.getName());
        if (sizeof enc._desde.content > 0){
            heDesde.setRama((enc._desde.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(heDesde);
        // cota superior
        def heHasta= new ast.HExpresion(Numero.class.getName());
        if (sizeof enc._hasta.content > 0){
            heDesde.setRama((enc._hasta.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(heHasta);
        // el paso
        def hePaso= new ast.HExpresion(Numero.class.getName());
        if (sizeof enc._paso.content > 0){
            heDesde.setRama((enc._paso.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(hePaso);
        
        res.setHuecos(al);
        res.setReglaSemantica(res.mkReglaExpresion(tds));

        println(res.ejecutable());
        res
    }

    //impl: 100 %
    override public function traducir(): String {
        def enc = encabezado as ParaEncabezado;
        var res = "{enc.variable_de_control()} = {enc.valor_de_inicializacion()}";
        res += "\n\r while({enc.variable_de_control()}.menor_igual( {enc.cota_superior()} ).valor())";
        for (i in instrucciones.content)
            res += "\n\r {(i as Bloque).traducir()}";
        res += "\n\r {enc.variable_de_control()} = {enc.variable_de_control()}.sumar( {enc.variacion()} )";
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

        (cuerpo as ParaCuerpo).espacio.ancho = ancho - grosor;
        super.actualizarPosiciones();
    }

    override public function mkNode(): Node {
        def res = IteradorPara {
                    grosor: grosor
                }
        res.actualizarPosiciones();
        res
    }

    public override def clasificacion = "EstructuraDeControl" on replace { }
    public override def mangos = bind [(encabezado as ParaEncabezado).mangos];
    public override def encabezado = bind ParaEncabezado {
                layoutX: 6
                layoutY: 4
            } on replace { }
    var instrucciones: VBox = VBox {}
    public override var cuerpo = ParaCuerpo {
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
//                            reposicionar();
                        }
                layoutX: bind grosor
                layoutY: bind a
                instruccionesVBox: bind instrucciones // with inverse
                espacio: ParaHueco {
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
    override public def huecos = bind [(cuerpo as ParaCuerpo).espacio, encabezado.huecos];

    init {
        actualizarPosiciones();
    }

}
