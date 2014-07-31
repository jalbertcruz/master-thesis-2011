package lang.ui.literales;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.Node;
import javafx.scene.control.Label;
import lang.ui.literales.base.Literal;
import tiposPrimitivos.Logico;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;

public class LiteralLogico extends BloqueArrastrable, Literal, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Hoja(Logico.class.getName(), true);
        res
    }

    //impl: 100 %
     override public function traducir(): String {
        "(LogicoImpl.new({etiqueta}))"
     }

    override public function mkNode(): Node {
        LiteralLogico {
            etiqueta: etiqueta
        }
    }

    public override def clasificacion = [Logico.class.getName()] on replace { }
    public var etiqueta: Boolean;
    def label = Label {
                text: bind if (etiqueta) then "verdadero" else "falso"
            }
    public override def mangos = bind label;
    public override def hijos = bind
            HBox {
                content: [
                    Text {
                        content: "  "
                    }
                    mangos
                ]

            }

    init {
        tipo = Logico.class;
    }

}
