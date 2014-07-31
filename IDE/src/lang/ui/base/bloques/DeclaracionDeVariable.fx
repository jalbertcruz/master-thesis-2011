package lang.ui.base.bloques;

import javafx.scene.text.Text;
import javafx.scene.layout.HBox;
import javafx.scene.control.TextBox;
import lang.ui.base.huecos.LugarParaTipo;
import javafx.scene.layout.Stack;
import javafx.scene.Node;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.BloqueArrastrable;
import lang.ui.base.Bloque;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import java.lang.Class;
import lang.ui.tipos.BloqueTipo;

public class DeclaracionDeVariable extends BloqueArrastrable, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {

        def res = new ast.Hoja("void", variableDeclarada);

        if (variableDeclarada)
            tds.adicionar(nombre, tipo.getName());

//        def al = new ArrayList();
//
//        res.setHuecos(al);
//        res.setReglaSemantica(res.mkReglaDeclaracionVariable(tds));
        res
    }

    override public function mkNode(): Node {  DeclaracionDeVariable { }  }

    public-read var nombre: String;
    public var variableDeclarada = bind tipoEspecificado and not tb.editable;
    def _mango2 = Text {
                content: "de tipo"
            }
    def nombreDeTipo = Stack {}
    def expresionTipo = LugarParaTipo {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                contenido: bind nombreDeTipo
                bloquesPermitidos: [
                    AccionBloquePorTipo {
                        tipo: "@Tipo"
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;
                            insert (b as Node) into nombreDeTipo.content;
                        }
                    }
                ]
            }
    def tipoEspecificado = bind sizeof nombreDeTipo.content > 0;
    public def tipo: Class = bind if (tipoEspecificado) then (nombreDeTipo.content[0] as BloqueTipo).tipo else null;
    public def esSecuencia: Boolean = bind (nombreDeTipo.content[0] as BloqueTipo).esSecuencia;
    def tb: TextBox = TextBox {
                promptText: "Nombre"
                onKeyTyped: function(e: KeyEvent): Void {
                    if (not tb.rawText.matches("[a-zA-Z|_]*"))
                        tb.deletePreviousChar();
                }
                onKeyReleased: function(e: KeyEvent): Void {
                    if (e.code == KeyCode.VK_ENTER and tb.text != "") {
                        tb.editable = false;
                        nombre = tb.text;
                    }

                }
            }
    public override def mangos = bind [_mango2];
    public override def huecos = bind if(sizeof nombreDeTipo.content > 0) then [] else [expresionTipo];
    public override def hijos = bind
            HBox {
                spacing: 3
                content: [
                    tb,
                    _mango2,
                    expresionTipo
                ]
            }

    init {
        clasificacion = ["DeclaraciónDeVariable"];
    }

}
