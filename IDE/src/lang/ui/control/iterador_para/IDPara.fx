package lang.ui.control.iterador_para;
import javafx.scene.Node;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import lang.ui.base.Bloque;
import javafx.scene.control.TextBox;

public class IDPara extends Bloque {

    override public function actualizarPosiciones(): Void {
        
        //TODO: Probar esto> IDPara.actualizarPosiciones
        ancho = hb.boundsInParent.width;
        //alto = expresion.alto + hb.boundsInParent.height;
        alto = idName.height + 15;
    }

    public var etiqueta: String;
    public var idName: TextBox;
    public def mango: Node = Text {
                content: bind etiqueta
            }
    def hb = HBox {
                content: [
                    mango,
                    idName
                ]
            }
    override public var hijos = bind hb
}
