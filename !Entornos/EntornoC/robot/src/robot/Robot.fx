package robot;

import javafx.scene.CustomNode;
import uci.erlProxyGen.IRobot;
import tiposPrimitivos.Numero;
import uci.IFabrica;
import uci.IAlmacen;
import uci.erlProxyGen.IRobotDone;
import javafx.scene.Node;
import javafx.util.Math.*;
import uci.IObjeto;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.layout.VBox;
import javafx.scene.Group;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;

public class Robot extends CustomNode, IRobot {

    override public function distanciaHastaFabrica(arg0: IFabrica): Numero {
        def yo = this as Node;
        def tu = arg0 as Node;
        def _valorDeX = yo.layoutX + yo.translateX;
        def _valorDeY = yo.layoutY + yo.translateY;
        def otroX = tu.layoutX + tu.translateX;
        def otroY = tu.layoutY + tu.translateY;
        new tiposPrimitivos.impl.NumeroImpl("{sqrt(pow(_valorDeX - otroX, 2) + pow(_valorDeY - otroY, 2))}")
    }

    var objDone: IRobotDone = null;

    override public function setIRobotDone(arg0: IRobotDone): Void {
        objDone = arg0;
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

    override public function moverHastaAlmacen(arg0: IAlmacen): Void {

        def dest = arg0 as Node;

        def miX = this.layoutX + this.translateX;
        def miY = this.layoutY + this.translateY;
        def tuX = dest.layoutX + dest.translateX;
        def tuY = dest.layoutY + dest.translateY;

        TranslateTransition {
            node: this
            byX: tuX - miX - this.boundsInParent.width
            byY: tuY - miY
            duration: 2s
            action: function() {
                objDone.moverHastaAlmacenDone();
            }
        }.playFromStart();
    }

    override public function moverHastaFabrica(arg0: IFabrica): Void {
        def dest = arg0 as Node;

        def miX = this.layoutX + this.translateX;
        def miY = this.layoutY + this.translateY;
        def tuX = dest.layoutX + dest.translateX;
        def tuY = dest.layoutY + dest.translateY;

        TranslateTransition {
            node: this
            byX: tuX - miX - this.boundsInParent.width
            byY: tuY - miY
            duration: 2s
            action: function() {
                objDone.moverHastaFabricaDone();
            }
        }.playFromStart();

    }

    override public function cogerObjeto(arg0: IFabrica): Void {
        def res = arg0.sacar() as Node;
        var next = res; // tomo el objeto a mover
        var x = 0.0;
        var y = 0.0;
        while (next.parent != null) { // calculo sus x e y respecto a la escena
            x += next.layoutX + next.translateX;
            y += next.layoutY + next.translateY;
            next = next.parent;
        }
        var tx = 0.0;
        var ty = 0.0;
        next = this;
        while (next.parent != null) {
            tx += next.layoutX + next.translateX;
            ty += next.layoutY + next.translateY;
            next = next.parent;
        }

        res.managed = false;

        Timeline {
            autoReverse: false
            repeatCount: 1
            keyFrames: [
                KeyFrame {
                    time: 300ms
                    action: function(): Void {
                        insert res into Main.mGroup.content;
                        TranslateTransition {
                            node: res
                            fromX: x
                            fromY: y
                            toX: tx
                            toY: ty
                            duration: 2s
                            action: function() {
                                objDone.cogerObjetoDone();
                                res.translateX = 0;
                                res.translateY = 0;
                                res.managed = true;
                                if (sizeof vb.content == 1) {
                                    def t = vb.content[0];
                                    vb.content[0] = res;
                                    insert t into vb.content;
                                } else {
                                    vb.content[0] = res;
                                }
                            }
                        }.playFromStart();

                    }
                }
            ]
        }.play();

    }

    override public function entregarObjeto(arg0: IAlmacen): Void {
        def res = vb.content[0]; // tomo el objeto a mover
        var next = res;
        var x = 0.0;
        var y = 0.0;
        while (next.parent != null) { // calculo sus x e y respecto a la escena
            x += next.layoutX + next.translateX;
            y += next.layoutY + next.translateY;
            next = next.parent;
        }
        var tx = 0.0;
        var ty = 0.0;
        next = arg0 as Node;
        while (next.parent != null) {
            tx += next.layoutX + next.translateX;
            ty += next.layoutY + next.translateY;
            next = next.parent;
        }

        res.managed = false;
        Timeline {
            autoReverse: false
            repeatCount: 1
            keyFrames: [
                KeyFrame {
                    time: 300ms
                    action: function(): Void {
                        insert res as Node into Main.mGroup.content;
                        TranslateTransition {
                            node: res as Node
                            fromX: x
                            fromY: y
                            toX: tx
                            toY: ty
                            duration: 2s
                            action: function() {
                                objDone.entregarObjetoDone();
                                res.translateX = 0;
                                res.translateY = 0;
                                res.managed = true;
                                arg0.poner(res as IObjeto);
                            }
                        }.playFromStart();

                    }
                }
            ]
        }.play();

//        arg0.poner(vb.content[0] as IObjeto);
//        vb.content[0] = null;
    }

    var vb = VBox {
                content: [
                    ImageView {
                        image: Image {
                            url: "{__DIR__}recursos/robot.jpg"
                        }
                    }
                ]
            }
    public override var children = bind vb;
}
