package robot;

import javafx.scene.CustomNode;
import javafx.scene.shape.Polygon;
import javafx.scene.paint.Color;
import uci.IObjeto;

public class Cuadrado extends CustomNode, IObjeto {

 public override var children = [
                Polygon {
                fill: Color.PINK
                points: [
                    0, 0,
                    10, 0,
                    10, 10,
                    0, 10
                ]
            }
            ];
}
