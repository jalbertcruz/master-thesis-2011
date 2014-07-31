package uci.help;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;

public class PanelDeControl {

    public var robot: uci.IRobot;
    public var f1: uci.IFabrica;
    public var f2: uci.IFabrica;
    public var f3: uci.IFabrica;
    public var almacen: uci.IAlmacen;
    def st = Stage {
                title: "Control"
                scene: Scene {
                    width: 350
                    height: 200
                    content: [
                        VBox {
                            content: [
                                Button {
                                    text: "robot.moverHastaAlmacen(almacen)"
                                    action: function() {
                                        robot.moverHastaAlmacen(almacen);
                                    }
                                }
                                Button {
                                    text: "robot.moverHastaFabrica(f1)"
                                    action: function() {
                                        robot.moverHastaFabrica(f1);
                                    }
                                }
                                Button {
                                    text: "robot.moverHastaFabrica(f2)"
                                    action: function() {
                                        robot.moverHastaFabrica(f2);
                                    }
                                }
                                Button {
                                    text: "robot.moverHastaFabrica(f3)"
                                    action: function() {
                                        robot.moverHastaFabrica(f3);
                                    }
                                }
                                Button {
                                    text: "robot.cogerObjeto(f1)"
                                    action: function() {
                                        robot.cogerObjeto(f1);
                                    }
                                }
                                Button {
                                    text: "robot.cogerObjeto(f2)"
                                    action: function() {
                                        robot.cogerObjeto(f2);
                                    }
                                }
                                Button {
                                    text: "robot.cogerObjeto(f3)"
                                    action: function() {
                                        robot.cogerObjeto(f3);
                                    }
                                }
                                Button {
                                    text: "robot.entregarObjeto(almacen)"
                                    action: function() {
                                        robot.entregarObjeto(almacen);
                                    }
                                }
                            ]
                        }
                    ]
                }
            }
}
