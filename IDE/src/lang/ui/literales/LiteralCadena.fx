package lang.ui.literales;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.control.TextBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.input.KeyEvent;
import lang.ui.literales.base.Literal;
import tiposPrimitivos.Cadena;

public class LiteralCadena extends BloqueArrastrable, Literal, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def str = tb.rawText.replaceAll("\"", "\\\"");
        def res = new ast.Hoja(Cadena.class.getName(), not str.equals(''));
        res
    }

    //impl: 100 %
     override public function traducir(): String {
         def str = tb.rawText.replaceAll("\"", "\\\"");
        "(CadenaImpl.new(\"{str}\"))"
     }

    override public function mkNode(): Node {
        LiteralCadena {
            nuevaLabel: nuevaLabel
            label: nuevaLabel()
        }
    }

    public override def clasificacion = [Cadena.class.getName()] on replace { }
    public-init var label: Label;
    public-init var nuevaLabel: function(): Label;
    def tb: TextBox = TextBox {
                //text: "\"\""
                text: "  "
                width: bind label.width + 10
                onKeyTyped: function(e: KeyEvent): Void {
                    label.text = tb.rawText;
                }

                onKeyPressed: function(e: KeyEvent): Void {
//                    if (tb.dot == tb.rawText.length()) {
//                        tb.positionCaret(tb.rawText.length() - 1);
//                    }
//                    if (tb.dot == 0) {
//                        tb.positionCaret(1);
//                    }
                }
            }
    public override def mangos = [
                Rectangle {
                    height: 5
                    width: bind tb.width
                    fill: Color.GOLD
                }];
    public override def hijos = bind [
                VBox {
                    content: [
                        tb,
                        mangos
                    ]
                }
            ];

    init {
        tipo = Cadena.class;
    }

}

