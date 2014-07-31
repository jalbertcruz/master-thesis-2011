package lang.ui.oo.common;

import javafx.scene.text.Text;
import lang.ui.base.Bloque;
import javafx.scene.layout.Stack;
import lang.ui.base.huecos.LugarParaTipo;
import lang.ui.base.acciones.AccionBloquePorTipo;
import javafx.scene.Node;
import java.lang.Class;
import lang.ui.tipos.BloqueTipo;
import javafx.scene.control.TextBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

public class LugarParaTipoDeRetornoDeConsultas extends Bloque {

    public def nombre = bind tb.text;
    def _mango2 = Text {
                content: "de tipo"
            }
    def nombreDeTipo = Stack {}
    def expresionTipo = LugarParaTipo {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                contenido: bind nombreDeTipo
                bloquesPermitidos: [

                    AccionBloquePorTipo {
                        tipo: "@Tipo"
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;
//                            insert (b as Node) into nombreDeTipo.content;
                            nombreDeTipo.content = b as Node;
                        }
                    }
                ]
            }
    public def tipoEspecificado = bind sizeof nombreDeTipo.content > 0;
    public def tipo: Class = bind if (tipoEspecificado) then (nombreDeTipo.content[0] as BloqueTipo).tipo else null;
    public def esSecuencia: Boolean = bind (nombreDeTipo.content[0] as BloqueTipo).esSecuencia;
    def tb: TextBox = TextBox {
                def n = "resultado";
                text: n
                columns: n.length()
                editable: false
            }
            
    public override def huecos = bind if (sizeof nombreDeTipo.content > 0) then [] else [expresionTipo];

    public override def hijos = bind
            VBox {
                spacing: 3
                content: [
                    Text {
                        content: "Tipo de retorno:"
                    }

                    HBox {
                        spacing: 3
                        content: [
                            tb,
                            _mango2,
                            expresionTipo
                        ]
                    }
                ]
            }
}
