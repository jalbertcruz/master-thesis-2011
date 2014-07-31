package lang.ui.oo.common;

import lang.ui.base.Bloque;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import lang.ui.oo.common.huecos.PrecondicionesHueco;

public class LugarParaPrecondiciones extends Bloque {
//    override public function actualizar () : Void {
//        //TODO:
//    }

    public var contenido: VBox;
    public var precondicionesHueco: PrecondicionesHueco;
    def vb = bind VBox {
                content: [
                    Text {
                        content: "Precondiciones:"
                    }
                    contenido,
                    precondicionesHueco
                ]
            }
    public override def huecos = bind [precondicionesHueco] on replace { }
    public override def ancho = bind vb.boundsInParent.width on replace { }
    public override def alto = bind vb.boundsInParent.height on replace { }
    public override def hijos = bind vb on replace { }
}

