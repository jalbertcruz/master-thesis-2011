package lang.ui.oo.common;

import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import lang.ui.base.Bloque;
import lang.ui.oo.common.huecos.PostcondicionesHueco;

public class LugarParaPostcondiciones extends Bloque {
//    override public function actualizar () : Void {
//        //TODO:
//    }

    public var contenido: VBox;
    public var postcondicionesHueco: PostcondicionesHueco;
    def vb = bind VBox {
                content: [
                    Text {
                        content: "Postcondiciones:"
                    }
                    contenido,
                    postcondicionesHueco
                ]
            }
    public override def huecos = bind [postcondicionesHueco] on replace { }
    public override def ancho = bind vb.boundsInParent.width on replace { }
    public override def alto = bind vb.boundsInParent.height on replace { }
    public override def hijos = bind vb on replace { }
}
