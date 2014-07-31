package sala;

import java.io.*;
import java.util.Properties;
import javafx.stage.Stage;
import javafx.scene.Scene;
import uci.Ventilador;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import uci.TV;
import scala.erlang.server.*;

var v: Ventilador;
var tv: TV;

Stage {
    title: "Application title"
    scene: Scene {
        width: 700
        height: 550
        content: [
            v = Ventilador {
                        layoutX: 200
                        layoutY: 350
                    }

//            tv = TV {
//                layoutX: 150
//                layoutY: 20
//            }
            VBox {
                spacing: 6
                content: [
                    Button {
                        text: "darUnaVuelta"
                        action: function() {
//                            v.darUnaVuelta();
                        }
                    }
                    Button {
                        text: "darNVueltas(3)"
                        action: function() {
//                            v.darNVueltas(3);
                        }
                    }
                    Button {
                        text: "encender"
                        action: function() {
//                            tv.encender();
                        }
                    }
                    Button {
                        text: "apagar"
                        action: function() {
//                            tv.apagar();
                        }
                    }
                ]
            }
        ]
    }
}

def prop = new Properties();
def input = new FileInputStream("configuracion.properties");
prop.load(input);
input.close();

def node = new Node("nServer@{prop.getProperty("ip")}", "coo");

def factory = new uci.erlProxyGen.IVentiladorProxyServerFactory(node, "channel", "nChannel@{prop.getProperty("ip")}", "factoryServer", v);

// werl -name nChannel@10.36.14.131 -setcookie coo -s channel start+

