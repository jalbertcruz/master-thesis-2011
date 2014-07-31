package lang.ui.control.common;

import javafx.scene.layout.VBox;
import lang.ui.base.Bloque;
import lang.ui.base.Hueco;

public class CuerpoDeInstrucciones extends Bloque {

    override public function actualizarPosiciones(): Void {
        
        for (b in instruccionesVBox.content)
            (b as Bloque).actualizarPosiciones();

        cuerpo = VBox {
                    content: [
                        instruccionesVBox,
                        espacio
                    ]
                };
    }

    public override def alto: Number = bind cuerpo.boundsInParent.height on replace { }
    public override def ancho: Number = bind cuerpo.boundsInParent.width on replace { }
    public var espacio: Hueco;
    public var instruccionesVBox: VBox;
    var cuerpo: VBox = VBox {
                content: [
                    instruccionesVBox,
                    espacio
                ]
            } on replace { }
    public override var hijos = bind cuerpo;
    }
