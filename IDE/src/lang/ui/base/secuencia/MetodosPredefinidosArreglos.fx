package lang.ui.base.secuencia;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.text.Text;
import javafx.scene.control.ChoiceBox;
import javafx.scene.layout.HBox;
import javafx.scene.Node;
import tiposPrimitivos.Numero;

public class MetodosPredefinidosArreglos extends BloqueArrastrable {

    override public function mkNode(): Node {
        MetodosPredefinidosArreglos {
            nombreArreglo: nombreArreglo
        }
    }

    override def clasificacion = [Numero.class.getName()];
    def _mango1 = Text {
                content: bind nombreArreglo
            }
    def _mango2 = Text { content: " de " }
    def _metodos = ChoiceBox {
                items: [
                    "Longitud",
                    "Índice inferior",
                    "Índice superior"
                ]
            }
    public override def mangos = bind [_mango1, _mango2];
    public var nombreArreglo: String;
    public-read def nombreMetodo = bind _metodos.selectedItem.toString();
    public override def hijos = bind
            HBox {
                spacing: 2
                content: [
                    _metodos,
                    _mango2,
                    _mango1
                ]
            }
}
