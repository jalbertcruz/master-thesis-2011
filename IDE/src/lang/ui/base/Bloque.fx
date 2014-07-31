package lang.ui.base;

import javafx.scene.CustomNode;
import javafx.scene.Node;

public class Bloque extends CustomNode {

    public function actualizarPosiciones(): Void { }

    public function traducir(): String { "" }

    public var huecoClicked: function(: Hueco): Void;
    public var huecoMouseEntered: function(: String): Void;
    public var actualizarHuecos: function(): Void;
    public var ancho: Number on replace{}
    public var alto: Number on replace{}
    public var huecos: Hueco[] on replace{}
    public var hijos: Node[];
    override var children = bind [
                hijos
            ];
}
