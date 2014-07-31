package uci;

import javafx.scene.CustomNode;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;
import javafx.scene.paint.Color;
import javafx.animation.transition.RotateTransition;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import java.lang.Integer;
import uci.erlProxyGen.IVentiladorDone;
import uci.erlProxyGen.IVentilador;
import tiposPrimitivos.Numero;
import tiposPrimitivos.impl.NumeroImpl;

public class Ventilador extends CustomNode, IVentilador {

    override public function cambiarSentido () : Void {
        sentido = not sentido;
    }

    var sentido = true;

    public var cant: Integer = 78;

    override public function veces(): Numero {

        Timeline {
            autoReverse: true
            repeatCount: 1
            keyFrames: [
                KeyFrame {
                    time: 1s
                    action: function(): Void {
                        res.vecesDone(new NumeroImpl("400"));
                    }
                }
            ]
        }.play();

        new NumeroImpl("{cant}");
    }

    override public function setIVentiladorDone(arg0: IVentiladorDone): Void {
        res = arg0
    }

    var res: IVentiladorDone;

    override public function darNVueltas(arg0: Numero): Void {
        RotateTransition {
            node: this
            duration: 2s * arg0.valor().floatValue()
            repeatCount: 1
            byAngle: (if (sentido) then 1 else -1) * 360 * arg0.valor()
            action: function() {
                res.darNVueltasDone();
            }
        }.playFromStart();
    }

    override public function darUnaVuelta(): Void {
        darNVueltas(new NumeroImpl("1"));
    }

    public override var children = [
                Circle {
                    radius: 50
                    fill: Color.BLACK
                }
                Line {
                    endY: 50
                    strokeWidth: 1.5
                    stroke: Color.WHITE
                }
            ];
}
