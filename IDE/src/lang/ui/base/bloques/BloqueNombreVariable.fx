package lang.ui.base.bloques;

import javafx.scene.layout.Stack;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import lang.ui.base.BloqueArrastrable;
import javafx.scene.Node;

public class BloqueNombreVariable extends BloqueArrastrable, Variable, ast.ASTCreador {

    override public function crearRama(tds: ast.TablaDeSimbolos): ast.Rama {
        var validez: Boolean = true;
        validez = tds.existe(nombre) and tds.tipo(nombre).equals(tipo.getName());
        def res = new ast.Hoja(tipo.getName(), validez);
        res
    }

    //impl: 100 %
    override public function traducir(): String {
        "{nombre}"
    }

    override public function mkNode(): Node {
        BloqueNombreVariable {
            color: color
            nombre: nombre
            tipo: tipo
            ancho: ancho
            alto: alto
        }

    }

    def _mango = Text {
                content: bind nombre
            };
    public override def mangos = bind [_mango];
    public var color: Paint;
    public override def clasificacion = bind ["variable", tipo.getName()];
    public override var hijos = bind [
                Stack {
                    content: [
                        Rectangle {
                            fill: bind color
                            width: bind ancho
                            height: bind alto
                        }
                        _mango
                    ]
                }
            ];
}
