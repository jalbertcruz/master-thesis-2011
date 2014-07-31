package lang.ui.control.iterador_para;

import lang.ui.base.Bloque;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import lang.ui.base.huecos.Expresion;
import javafx.scene.Node;

public class ExpresionNumericaEtiquetada extends Bloque {

    override public function actualizarPosiciones(): Void {
        ancho = expresion.ancho + hb.boundsInParent.width;
        //alto = expresion.alto + hb.boundsInParent.height;
        alto = expresion.alto + 15;
    }

    public var etiqueta: String;
    public-init var expresion: Expresion;
    public def mango: Node = Text {
                content: bind etiqueta
            }
    def hb = HBox {
                content: [
                    mango,
                    expresion
                ]
            }
    override public var hijos = bind hb
}
