package robot;

import javafx.scene.CustomNode;
import javafx.scene.shape.Circle;
import javafx.scene.paint.Color;
import uci.IObjeto;

public class Circulo extends CustomNode, IObjeto {

    public override var children = [
                Circle {
                    fill: Color.BROWN
                    radius: 4
                }
            ];
}
