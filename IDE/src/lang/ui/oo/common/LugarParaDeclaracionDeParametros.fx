package lang.ui.oo.common;

import lang.ui.base.Bloque;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import lang.ui.oo.common.huecos.ParametrosHueco;

public class LugarParaDeclaracionDeParametros extends Bloque {
//    override public function actualizar () : Void {
//        //TODO:
//    }

    public var parametrosHueco: ParametrosHueco;
    public var contenido: VBox;
    def vb = bind VBox {
                content: [
                    Text {
                        content: "Entrada:"
                    }
                    contenido,
                    parametrosHueco
                ]
            }
    public override def huecos = bind [parametrosHueco] on replace { }
    public override def ancho = bind vb.boundsInParent.width on replace { }
    public override def alto = bind vb.boundsInParent.height on replace { }
    public override def hijos = bind vb on replace { }

    init {
//        reposicionar = function(): Void {
//
//                }

    }

}
