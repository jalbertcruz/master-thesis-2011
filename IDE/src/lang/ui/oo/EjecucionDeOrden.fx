package lang.ui.oo;

import lang.ui.base.BloqueArrastrable;
import lang.model.rutinas.ModeloRutina;
import javafx.scene.text.Text;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import lang.ui.base.huecos.Expresion;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Bloque;
import javafx.scene.layout.Stack;
import java.util.ArrayList;

public class EjecucionDeOrden extends BloqueArrastrable, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Rama("void");
        def al = new ArrayList();
        // Pongo en al tantas HExpresion como huecos tenga el bloque,
        // en cada uno pongo por <Rama> la rama que tenga cada hueco lleno
        for(pa in parametrosActuales){
            def he = new ast.HExpresion(modelo.informacionParametros[indexof pa].tipo.getName());
            // en el content de <pa> está el bloque necesario
            if (sizeof pa.content > 0){
                he.setRama((pa.content[0] as ast.ASTCreador).crearRama(tds));
            }

            al.add(he);
        }
        res.setHuecos(al);
        res.setReglaSemantica(res.mkReglaExpresion(tds));
        res
    }

    //impl: 100 %
    override public function traducir(): String {
        var res = "";

        def acceso = function(pos: Integer): String{
            (parametrosActuales[pos].content[sizeof parametrosActuales[pos].content - 1] as Bloque).traducir()
        }

        if (esMetodo) {
            res = acceso(0);

            res += ".{nombre}(";
            if (sizeof parametrosActuales > 1) {
                res += acceso(1);
                for (i in [2..sizeof parametrosActuales - 1])
                    res += ", {acceso(i)}";
            }
            res += ")";

        }else{
            //TODO: cuando no sea metodo...
        }

        res

    }

    public var esMetodo: Boolean = true;

    override public function mkNode(): Node {
        EjecucionDeOrden {
            modelo: modelo
        }
    }

    public var modelo: ModeloRutina on replace { }
    public-read def nombre = bind modelo.nombre;
    def _mangoN = Text {
                content: bind modelo.sufijo;
            }
    def parametrosActuales: Stack[] = for (_ in modelo.informacionParametros) Stack {}
    def parametros: Node[] = bind for (pinfo in modelo.informacionParametros)
                [
                    Text { content: pinfo.comentario }
                    Expresion {
                        huecoClicked: bind huecoClicked
                        huecoMouseEntered: bind huecoMouseEntered
                        contenido: parametrosActuales[indexof pinfo]
                        tipo: pinfo.tipo
                        descripcion: pinfo.descripcion
                        bloquesPermitidos: [
                            AccionBloquePorTipo {
                                tipo: pinfo.tipo.getName()
                                accion: function(b: Bloque) {
                                    b.layoutX = 0;
                                    b.layoutY = 0;
                                    b.translateX = 0;
                                    b.translateY = 0;
                                    insert (b as Node) into parametrosActuales[indexof pinfo].content;
                                }
                            }
                        ]
                    }
                ] on replace {
                actualizarHuecos();
                actualizarMangos();
            }

    function actualizarMangos(): Void {
        mangos = [for (i in [0..sizeof parametros - 1 step 2]) parametros[i], _mangoN];
    }

    public override def hijos = bind
            HBox {
                spacing: 1
                content: [
                    parametros,
                    _mangoN
                ]
            }

    init {
        actualizarHuecos = function(): Void {
                    huecos = [];
                    for (pa in parametrosActuales where pa.content == [])
                        insert parametros[(indexof pa) * 2 + 1] as Expresion into huecos;
                }
        clasificacion = ["Orden"];
    }

}
