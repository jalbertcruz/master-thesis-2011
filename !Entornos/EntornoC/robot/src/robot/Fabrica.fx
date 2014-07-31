package robot;

import javafx.scene.CustomNode;
import javafx.util.Math.*;
import javafx.scene.Node;
import javafx.scene.text.Text;
import tiposPrimitivos.Numero;
import uci.IObjeto;
import uci.IAlmacen;
import uci.erlProxyGen.IFabricaDone;
import uci.erlProxyGen.IFabrica;
import javafx.scene.shape.Shape;
import javafx.scene.layout.HBox;

public class Fabrica extends CustomNode, IFabrica {

    def cantidad = bind sizeof hb.content;
        
    public var objetos: IObjeto[];

    override public function valorDeX(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{layoutX + translateX}")
    }

    override public function sacar(): IObjeto {
        //def res = objetos[0];
        //delete  objetos[0];
        //res
        hb.content[0] as IObjeto
    }

    override public function distanciaHastaAlmacen(arg0: IAlmacen): Numero {
        def yo = this as Node;
        def tu = arg0 as Node;
        def _valorDeX = yo.layoutX + yo.translateX;
        def _valorDeY = yo.layoutY + yo.translateY;
        def otroX = tu.layoutX + tu.translateX;
        def otroY = tu.layoutY + tu.translateY;
        new tiposPrimitivos.impl.NumeroImpl("{sqrt(pow(_valorDeX - otroX, 2) + pow(_valorDeY - otroY, 2))}")
    }

    override public function cantidadProductos(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{cantidad}")
    }

    override public function valorDeY(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{layoutY + translateY}")
    }

    var objDone: IFabricaDone;

    override public function setIFabricaDone(arg0: IFabricaDone): Void {
        objDone = arg0;
    }

    public var forma: Shape;
    def hb = HBox {
                spacing: 2
                layoutX: bind forma.boundsInParent.width + 3
                //content: bind
            }
    public override var children = bind [
                forma,
                Text {
                    content: "{cantidad}"
                    layoutX: bind forma.boundsInParent.width / 2
                    layoutY: bind forma.boundsInParent.height / 2 + 5
                }
                hb
            ];

            init {
              hb.content = for (o in objetos) o as Node ;
            }

}
