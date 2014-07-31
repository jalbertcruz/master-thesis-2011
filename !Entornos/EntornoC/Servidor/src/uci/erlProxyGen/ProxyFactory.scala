package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class ProxyFactory(
        nodo: Node, // Nodo Jinterface
        erlServiceNodeName: String, // Nodo Erlang
        objsIRobot: java.util.ArrayList[uci.erlProxyGen.IRobot],      // Objetos a proxear
        objsIAlmacen: java.util.ArrayList[uci.erlProxyGen.IAlmacen],  // Objetos a proxear
        objsIFabrica: java.util.ArrayList[uci.erlProxyGen.IFabrica]   // Objetos a proxear
) {

    val _global = scala.collection.mutable.Map[Symbol, Any]()

    new IRobotProxyServer(nodo, erlServiceNodeName, objsIRobot, _global)

    new IAlmacenProxyServer(nodo, erlServiceNodeName, objsIAlmacen, _global)

    new IFabricaProxyServer(nodo, erlServiceNodeName, objsIFabrica, _global)

}


