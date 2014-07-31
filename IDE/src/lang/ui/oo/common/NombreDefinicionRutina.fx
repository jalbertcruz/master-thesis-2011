package lang.ui.oo.common;

import lang.ui.base.Bloque;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;

public class NombreDefinicionRutina extends Bloque {
   
    public var tipoRutina: String;
    public function getFocus(): Void {
        tb.requestFocus();
    }

    public var nombreDefinido: function(: String): Void;
    public def mango = Text {
                content: "{tipoRutina}         "
            }
    var tb: TextBox;
    def hb = HBox {
                spacing: 5
                content: [
                    mango,
                    tb = TextBox {
                                promptText: "Nombre de la rutina"
                                columns: 25
                                onKeyReleased: function(e: KeyEvent): Void {
                                    if (e.code == KeyCode.VK_ENTER and tb.text != "") {
                                        tb.editable = false;
                                        nombreDefinido(tb.text);
                                    }

                                }
                            }
                    Button {
                        text: "Compilar"
                    }
                ]
            }
    public override def ancho = bind hb.boundsInParent.width on replace { }
    public override def alto = bind hb.boundsInParent.height on replace { }
    public override def hijos = bind hb on replace { }
}
