package robot;

import javafx.scene.CustomNode;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import uci.erlProxyGen.IAlmacen;
import uci.IObjeto;
import tiposPrimitivos.Numero;
import uci.erlProxyGen.IAlmacenDone;
import javafx.scene.layout.HBox;
import javafx.scene.Node;

public class Almacen extends CustomNode, IAlmacen {

    override public function cantidadProductos(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{cantidad}")
    }

    def cantidad = bind sizeof objetos;
    public var objetos: IObjeto[];

    override public function sacar(): IObjeto {
        def res = objetos[0];
        delete  objetos[0];
        res
    }

    override public function valorDeX(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{layoutX + translateX}")
    }

    override public function valorDeY(): Numero {
        new tiposPrimitivos.impl.NumeroImpl("{layoutY + translateY}")
    }

    override public function poner(arg0: IObjeto): Void {
        insert arg0 into objetos;
    }

    var objDone: IAlmacenDone;

    override public function setIAlmacenDone(arg0: IAlmacenDone): Void {
        objDone = arg0;
    }

    def lado = 40;
    public override var children = bind [
                Rectangle {
                    width: lado
                    height: lado
                    fill: Color.WHITE
                    stroke: Color.BLACK
                }
                Polygon {
                    fill: Color.WHITE
                    stroke: Color.BLACK
                    points: [
                        0, 0, lado / 2, -lado / 2,
                        lado, 0
                    ]
                }
                Text {
                    content: "{cantidad}"
                    layoutX: 15
                    layoutY: 20
                }

                HBox {
                    spacing: 2
                    layoutX: 50
                    content: bind for (o in objetos) o as Node
                }
            ];
}
