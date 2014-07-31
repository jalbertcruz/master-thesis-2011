package lang.ui.control.common;

import lang.ui.base.Hueco;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Paint;

public class HuecoDeInstrucciones extends Hueco {

    public var color: Paint;
    override var children = bind [
                Rectangle {
                    width: bind ancho
                    height: bind alto
                    fill: bind color
                }
            ];
}
