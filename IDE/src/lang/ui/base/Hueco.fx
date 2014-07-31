package lang.ui.base;

import javafx.util.Sequences.*;
import lang.ui.base.acciones.AccionBloquePorTipo;
import javafx.scene.input.MouseEvent;
import javafx.scene.CustomNode;

public class Hueco extends CustomNode {

    public var ancho: Number = 30;
    public var alto: Number = 20;
    public var bloquesPermitidos: AccionBloquePorTipo[];

    public function esEsteBloquePermitido(b: BloqueArrastrable): Boolean {
        for (bp in bloquesPermitidos)
            if (indexOf(b.clasificacion, bp.tipo) != -1) {
                return true;
            }
        return false;
    }

    public function tocar(b: BloqueArrastrable): Void {
        for (bp in bloquesPermitidos)
            if (indexOf(b.clasificacion, bp.tipo) != -1) {
                bp.accion(b);
            }
    }

    public var huecoClicked: function(: Hueco): Void;
    public var huecoMouseEntered: function(: String): Void;
    public var descripcion: String;

    init {
        onMouseClicked = function(e: MouseEvent): Void {
                    huecoClicked(this);
                }
        onMouseEntered = function(e: MouseEvent): Void {
                    huecoMouseEntered(descripcion);
                }

    }

}
