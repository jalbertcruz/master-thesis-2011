package lang.ui.base.huecos;

import lang.ui.base.Hueco;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.Stack;
import javafx.scene.paint.Color;
import lang.ui.tipos.BloqueTipo;

public class LugarParaTipo extends Hueco {

    public override def ancho: Number = bind if (contenido.content == []) then 30 else contenido.width;
    public override def alto: Number = bind if (contenido.content == []) then 20 else contenido.height;
    public-read def nombre: String = bind (contenido.content[sizeof contenido.content - 1] as BloqueTipo).nombre;
    public var contenido: Stack;
    override var children = bind [
                Rectangle {
                    width: bind if (contenido.content == []) then 30 else contenido.width
                    height: bind if (contenido.content == []) then 20 else contenido.height
                    fill: Color.GREEN
                }
                contenido
            ];
}
