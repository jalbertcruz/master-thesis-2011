package ide;

import lang.ui.base.Hueco;
import javafx.scene.shape.Polygon;
import lang.ui.base.BloqueArrastrable;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;

public class Papelera extends Hueco {

    public override def children = bind Polygon {
                fill: Color.ORANGE
                points: [
                    0, 0,
                    10, 50,
                    30, 50,
                    40, 0
                ]
            }

    public override function tocar(b: BloqueArrastrable): Void {
        insert (b as Node) into Group {}.content;
    }

}
