package lang.ui.base.secuencia;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.text.Text;
import lang.ui.base.huecos.Expresion;
import javafx.scene.layout.Stack;
import javafx.scene.Node;
import lang.ui.base.acciones.AccionBloquePorTipo;
import lang.ui.base.Bloque;
import lang.ui.base.bloques.Variable;
import tiposPrimitivos.Numero;

public class IndizacionDeSecuencia extends BloqueArrastrable, Variable {

    override public function mkNode(): Node {
        IndizacionDeSecuencia {
            nombre: nombre
            tipo: tipo
        }
    }

    override def clasificacion = bind ["variable", tipo.getName()];
    def _mango = Text {
                content: bind " {nombre}"
                layoutY: 5
            }
    def indice = Stack {}
    def expresion = Expresion {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                layoutX: _mango.content.length() * 6
                layoutY: _mango.layoutY - 2
                tipo: Numero.class
                contenido: bind indice
                bloquesPermitidos: [
                    AccionBloquePorTipo {
                        tipo: Numero.class.getName()
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            insert (b as Node) into indice.content;
                        }
                    }
                ]
            }
    public override def mangos = bind [_mango];
    public override def hijos = bind [
                _mango,
                expresion
            ];

    init {
        marca.layoutX = 0;
        marca.layoutY = 0;
        huecos = [expresion];
        actualizarHuecos = function(): Void {
                    huecos = if (indice.content == []) then [expresion] else []
                }
    }

}
