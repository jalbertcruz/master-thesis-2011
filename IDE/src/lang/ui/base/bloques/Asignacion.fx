package lang.ui.base.bloques;

import javafx.scene.text.Text;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Stack;
import javafx.scene.Node;
import lang.ui.base.huecos.LugarParaVariable;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.huecos.Expresion;
import lang.ui.base.BloqueArrastrable;
import lang.ui.base.Bloque;
import refleccion.EtiquetasAsignacion;
import com.google.gson.Gson;
import java.io.FileReader;
import java.util.ArrayList;

public class Asignacion extends BloqueArrastrable, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Rama("void");
        def al = new ArrayList();
        
         // la variable
        def heVar= new ast.HExpresion((nombreDeVariable.content[0] as BloqueNombreVariable).tipo.getName());
        if (sizeof nombreDeVariable.content > 0){
            heVar.setRama((nombreDeVariable.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(heVar);

         // la expresion
        def heExpresion = new ast.HExpresion(expresion.tipo.getName());
        if (sizeof valorAAsignar.content > 0){
            heVar.setRama((valorAAsignar.content[0] as ast.ASTCreador).crearRama(tds));
        }
        al.add(heExpresion);

        res.setHuecos(al);
        res.setReglaSemantica(res.mkReglaAsignacion(tds));
        
//        println(res.ejecutable());
        res
    }


    //impl: 100 %
    override public function traducir(): String {
        "{(nombreDeVariable.content[sizeof nombreDeVariable.content - 1] as Bloque).traducir()} = {(valorAAsignar.content[sizeof valorAAsignar.content - 1] as Bloque).traducir()}";
    }

    override public function mkNode(): Node { Asignacion {} }

    init {

        def reader: FileReader = new FileReader("./configuracion/EtiquetasAsignacion.json");
        def gson: Gson = new Gson();
        def et: EtiquetasAsignacion = gson.fromJson(reader, EtiquetasAsignacion.class);
        reader.close();

        _simboloCopiarEn.content = et.getEtiquetaDestino();
        _simboloValor.content = et.getEtiquetaOrigen();
    }

    def _simboloCopiarEn = Text { content: "" }
    def _simboloValor = Text { content: "" }

    public override def mangos = bind [_simboloCopiarEn, _simboloValor] on replace { }

    def nombreDeVariable = Stack {}
    def valorAAsignar = Stack {}
    
    def lugar: LugarParaVariable = LugarParaVariable {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                contenido: bind nombreDeVariable
                bloquesPermitidos: [
                    AccionBloquePorTipo {
                        tipo: "variable"
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            insert (b as Node) into nombreDeVariable.content;
                            expresion.tipo = lugar.tipo
                        }
                    }
                ]
            }
    def expresion: Expresion = Expresion {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                contenido: bind valorAAsignar
                bloquesPermitidos: [
                    AccionBloquePorTipo {
                        tipo: bind lugar.tipo.getName()
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;
                            insert (b as Node) into valorAAsignar.content;
                        }
                    }
                ]
            }
    public override def hijos = bind HBox {
                spacing: 3
                content: [
                    _simboloCopiarEn,
                    lugar,
                    _simboloValor,
                    expresion
                ]
            } on replace { }

    init {
        huecos = [lugar, expresion];
        actualizarHuecos = function(): Void {
                    huecos = [];
                    if (nombreDeVariable.content == [])
                        insert lugar into huecos;
                    if (valorAAsignar.content == [])
                        insert expresion into huecos;
                }
        clasificacion = ["Asignación"];
    }

}
