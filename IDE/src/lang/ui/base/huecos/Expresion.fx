package lang.ui.base.huecos;

import javafx.scene.layout.Stack;
import lang.ui.base.Hueco;
import java.lang.Class;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

public class Expresion extends Hueco {

    public override def ancho: Number = bind if (contenido.content == []) then 30 else contenido.width;
    public override def alto: Number = bind if (contenido.content == []) then 20 else contenido.height;
    public var tipo: Class;
    public var contenido: Stack;
    override var children = bind [
                Rectangle {
                    width: bind if (contenido.content == []) then 30 else contenido.width
                    height: bind if (contenido.content == []) then 20 else contenido.height
                    fill: Color.YELLOW
                    stroke: Color.BLACK
                    //strokeWidth: 2
                }
                contenido
            ];

   

}
