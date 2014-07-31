package lang.ui.base;

import javafx.scene.Node;
import javafx.scene.shape.Circle;
import javafx.scene.paint.Color;
import javafx.scene.Cursor;

public mixin class Arrastrable {

    public var clasificacion: String[];
    public var mangos: Node[] on replace olds{
        for(old in olds)
        old.cursor = Cursor.DEFAULT;

        for(n in mangos)
            n.cursor = Cursor.HAND;

        };
    public-read var marca: Node = Circle {
                layoutX: 2
                layoutY: 2
                radius: 2
                fill: Color.RED
            };
    public def asNode = bind this as Node;
}
