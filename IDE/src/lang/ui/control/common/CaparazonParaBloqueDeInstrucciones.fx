package lang.ui.control.common;

import lang.ui.base.BloqueArrastrable;
import javafx.scene.shape.Polygon;
import javafx.scene.paint.Color;
import lang.ui.base.Bloque;
import javafx.scene.paint.Paint;
import ide.utilidades.ColoresIDE;

public abstract class CaparazonParaBloqueDeInstrucciones extends BloqueArrastrable {

    public var fillColor: Paint = ColoresIDE.estructurasDeControl;

    protected def poligono = bind Polygon {
                stroke: Color.WHITE

                fill: bind fillColor
                points: [
                    0, 0, 0, alto,
                    ancho, alto, ancho, alto - grosor,
                    grosor, alto - grosor, grosor, a,
                    ancho, a, ancho, 0
                ]
            }
    // largo de la parte de arriba
    protected var a: Number on replace { }
    // ancho del borde izquierdo
    public var grosor: Number;
    public var encabezado: Bloque;
}

//public class CaparazonUnBloqueDeInstrucciones extends BloqueArrastrable
//
//{
//
//    public var a: Number; // largo de la parte de arriba
//    public var b: Number = bind ancho; // ancho
//    public var g: Number; // ancho del borde izquierdo
//    public var h: Number = bind altura; // altura
//
//    public override var hijos = bind [
//            Polygon{
//                fill: Color.BLUE
//                points: [
//                    0, 0,      0, h,
//                    b, h,      b, h-g,
//                    g, h-g,    g, a,
//                    b, a,      b, 0
//                    ]
//            }
//
//        ];
//}
