package lang.ui.oo.common.huecos;

import lang.ui.base.Hueco;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;

public class HuecoEstandar extends Hueco {

    public var color: Paint;
    override var children = [
                Rectangle {
                    width: bind ancho
                    height: bind alto
                    fill: bind color
                }
            ];
}
