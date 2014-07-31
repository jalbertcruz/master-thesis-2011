package generator;

import uci.generator.Generator;

public class Main {

    public static void main(String[] args) throws Exception {

        Generator g = new Generator();

        String srcPrefix = "D:/Usuario/JAlbert/Erlang/Erlang Programming/";
        String srcLetter = "B";

        Class[] clases = {
            uci.IAlmacen.class,
            uci.IFabrica.class,
            uci.IRobot.class
        };

        for (Class cls : clases) {
            g.generateClientProxies(srcPrefix + "Entorno" + srcLetter + "/Cliente/src/",
                    cls);
            g.generateServerProxies(srcPrefix + "Entorno" + srcLetter + "/Servidor/src/",
                    cls);
            g.generateInterfaces(srcPrefix + "Entorno" + srcLetter + "/Servidor/src/",
                    cls);
//            g.generateErlangServer(srcPrefix + "Entorno" + srcLetter + "/Erlang/",
//                    cls);

        }

    }
}
