package lang.ui.control.common;

import javafx.scene.CustomNode;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import ide.utilidades.ColoresIDE;

public class EtiquetaSegundoBloqueDeInstrucciones extends CustomNode {

    public var etiqueta: String;
    public var ancho: Number;
    public var alto: Number;

    public override var children = [
                Rectangle {
                    stroke: Color.WHITE
                    fill: ColoresIDE.estructurasDeControl
                    width: bind ancho
                    height: bind alto
                }
                Text {
                    layoutX: 5
                    layoutY: 15
                    content: bind etiqueta
                }
            ];
}
