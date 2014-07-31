package robot;

import javafx.scene.CustomNode;
import javafx.scene.shape.Polygon;

public class Objeto extends CustomNode{

    public var forma: Polygon;

    public override var children = bind [
            forma
        ];

}
