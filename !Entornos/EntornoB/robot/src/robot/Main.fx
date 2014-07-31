package robot;

import javafx.stage.Stage;
import javafx.scene.Scene;
import uci.IFabrica;
import uci.IRobot;
import uci.IAlmacen;
import javafx.scene.shape.Polygon;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import robot.Triangulo;
import robot.Cuadrado;
import robot.Circulo;
import java.util.Properties;
import java.io.FileInputStream;
import javafx.scene.Group;
import javafx.scene.Node;

var robot: uci.IRobot = Robot {
            layoutX: 60
            layoutY: 70
        }
var f1: uci.IFabrica = Fabrica {
            objetos: for (i in [1..4]) Triangulo {}
            layoutX: 150
            layoutY: 40
            forma: Polygon {
                fill: Color.BLUE
                points: [
                    20, 0,
                    40, 40,
                    0, 40
                ]
            }
        }
var f2: uci.IFabrica = Fabrica {
            objetos: for (i in [1..3]) Cuadrado {}
            layoutX: 200
            layoutY: 400
            forma: Polygon {
                fill: Color.PINK
                points: [
                    0, 0,
                    40, 0,
                    40, 40,
                    0, 40
                ]
            }
        }
var f3: uci.IFabrica = Fabrica {
            objetos: for (i in [1..5]) Circulo {}
            layoutX: 450
            layoutY: 70
            forma: Circle {
                fill: Color.BROWN
                radius: 15
            }
        }
var almacen: uci.IAlmacen = Almacen {
            layoutX: 250
            layoutY: 250
        }
        
public var mGroup = Group {
            content: [
                f1 as Node,
                f2 as Node,
                f3 as Node,
                almacen as Node,
                robot as Node
            ]
        }

function run() {

    Stage {
        title: "Micromundo Robot"
        scene: Scene {
            width: 550
            height: 500
            content: bind mGroup
        }
    }
    
    def testing = false;

    if (testing) {
        uci.help.PaneldeControl.PanelDeControl {
            robot: robot
            f1: f1
            f2: f2
            f3: f3
            almacen: almacen
        }
    } else {
        def props = new Properties();
        def input = new FileInputStream("configuracion.properties");
        props.load(input);
        input.close();

        def node = new scala.erlang.server.Node("nServer@{props.getProperty("ip")}", "coo");

        def robots = new java.util.ArrayList;
        robots.add(robot);

        def almacens = new java.util.ArrayList;
        almacens.add(almacen);

        def fabricas = new java.util.ArrayList;
        fabricas.add(f1);
        fabricas.add(f2);
        fabricas.add(f3);

        def __ = new uci.erlProxyGen.ProxyFactory(
                node,
                "nChannel@{props.getProperty("enrutador")}",
                robots,
                almacens,
                fabricas);

// werl -name nChannel@192.168.1.201 -setcookie coo -s channel start
// werl -name nChannel@10.36.14.131 -setcookie coo -s channel start
    }

}
