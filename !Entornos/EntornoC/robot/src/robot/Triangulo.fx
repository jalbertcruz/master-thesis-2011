package robot;

import javafx.scene.CustomNode;
import javafx.scene.paint.Color;
import javafx.scene.shape.Polygon;
import uci.IObjeto;

public class Triangulo extends CustomNode, IObjeto {

 public override var children = [
                Polygon {
                fill: Color.BLUE
                points: [
                    5, 0,
                    10, 10,
                    0, 10
                ]
            }
            ];
}
