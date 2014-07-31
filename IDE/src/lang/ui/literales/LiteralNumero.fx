package lang.ui.literales;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.layout.VBox;
import javafx.scene.control.TextBox;
import javafx.scene.Node;
import javafx.scene.input.KeyEvent;
import javafx.scene.control.Label;
import lang.ui.literales.base.Literal;
import tiposPrimitivos.Numero;

public class LiteralNumero extends BloqueArrastrable, Literal, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        def res = new ast.Hoja(Numero.class.getName(), not etiqueta.equals(''));
        res
    }

    //impl: 100 %
     override public function traducir(): String {
        "(NumeroImpl.new(\"{etiqueta}\"))"
     }

    override public function mkNode(): Node {
        LiteralNumero {
            nuevaLabel: nuevaLabel
            label: nuevaLabel()
        }
    }

    function tieneDosPuntos(str: String): Boolean {
        def p1 = str.indexOf(".");
        if (p1 == -1) return false;
        def str2 = str.substring(p1 + 1);
        return str2.contains(".");
    }

    def etiqueta: String = bind tb.rawText;

    public-init var label: Label;
    public-init var nuevaLabel: function(): Label;
    public override def clasificacion = [Numero.class.getName()] on replace { }
    def tb: TextBox = TextBox {
                promptText: "0"
                width: bind label.width + 10
                onKeyTyped: function(e: KeyEvent): Void {
                    if (not tb.rawText.matches("[\\d|\\.]+") or tieneDosPuntos(tb.rawText))
                        tb.deletePreviousChar();

                    label.text = tb.rawText;
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
        tipo = Numero.class;
    }

}
