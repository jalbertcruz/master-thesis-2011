package lang.ui.oo.common;

import lang.ui.base.Bloque;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import lang.ui.oo.common.huecos.DeclaracionDeVariablesHueco;

public class LugarParaDeclaracionDeVariables extends Bloque {

    public var contenido: VBox;
    public var declaracionDeVariablesHueco: DeclaracionDeVariablesHueco;
    def vb = bind VBox {
                content: [
                    Text {
                        content: "Variables locales:"
                    }
                    contenido,
                    declaracionDeVariablesHueco
                ]
            }
    public override def huecos = bind [declaracionDeVariablesHueco] on replace { }
    public override def ancho = bind vb.boundsInParent.width on replace { }
    public override def alto = bind vb.boundsInParent.height on replace { }
    public override def hijos = bind vb on replace { }
}
