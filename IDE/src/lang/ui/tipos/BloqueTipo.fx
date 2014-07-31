package lang.ui.tipos;

import lang.ui.base.Bloque;
import javafx.scene.layout.Stack;
import lang.ui.base.BloqueArrastrable;
import javafx.scene.Node;
import javafx.scene.control.Label;
import java.lang.Class;
import refleccion.modelos.ModeloEjecucionDeMetodoJava;

public class BloqueTipo extends BloqueArrastrable {

    override public function mkNode(): Node {
        BloqueTipo {
            esSecuencia: esSecuencia
            tipo: tipo
        }
    }
    public var esSecuencia: Boolean;
    def _mango = Label {
                text: bind if (esSecuencia) then " secuencia de {nombre}" else " {nombre}";
            }
            
    public var tipo: Class on replace {
                nombre = if (esSecuencia) then ModeloEjecucionDeMetodoJava.getPlural(tipo) else ModeloEjecucionDeMetodoJava.getNombre(tipo);
            }
            
//    public def esSecuencia = bind nombre.startsWith("secuencia de");
    public override def mangos = bind [_mango];
    public override def ancho = bind _mango.width;
    public var nombre: String;
    public override var hijos = bind [
                Stack {
                    content: [
                        _mango
                    ]
                }
            ];

    init {
        clasificacion = "@Tipo";
        alto = 20;
    }

}
