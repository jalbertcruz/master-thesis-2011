package lang.ui.base.huecos;

import javafx.scene.layout.Stack;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import lang.ui.base.Hueco;
import lang.ui.base.bloques.Variable;
import java.lang.Class;

public class LugarParaVariable extends Hueco {

    public override def ancho: Number = bind if (contenido.content == []) then 30 else contenido.width;
    public override def alto: Number = bind if (contenido.content == []) then 20 else contenido.height;
    public-read def tipo: Class = bind (contenido.content[sizeof contenido.content - 1] as Variable).tipo on replace {
            println(tipo.getName());
        }
    public var contenido: Stack;
    override var children = bind [
                Rectangle {
                    width: bind if (contenido.content == []) then 30 else contenido.width
                    height: bind if (contenido.content == []) then 20 else contenido.height
                    fill: Color.CHOCOLATE
                }
                contenido
            ];
}
