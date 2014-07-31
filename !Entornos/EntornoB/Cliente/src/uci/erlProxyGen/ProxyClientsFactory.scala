package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class ProxyClientsFactory( 
    nodo: Node,
      erlServiceNodeName: String
) {
		
    private[this] val _global = scala.collection.mutable.Map[Symbol, Any]()
	
    def clientsTuples(): java.util.ArrayList[uci.entidades.ParObjetoRemoto] = {
        val res = new java.util.ArrayList[uci.entidades.ParObjetoRemoto]()
		
        val IRobotProxyClientObj = new IRobotProxyClient(nodo, erlServiceNodeName, _global)
        res.addAll(IRobotProxyClientObj.objetos)

        val IFabricaProxyClientObj = new IFabricaProxyClient(nodo, erlServiceNodeName, _global)
        res.addAll(IFabricaProxyClientObj.objetos)

        val IAlmacenProxyClientObj = new IAlmacenProxyClient(nodo, erlServiceNodeName, _global)
        res.addAll(IAlmacenProxyClientObj.objetos)
		
        return res
    }
    
}

//class IRobotProxyClientFactory( nodo: Node,
//                               erlServiceName: String,
//                               erlServiceNodeName: String,
//                               serviceClientFactoryName: Symbol ) {
//
//    private[this] val clientObjs = new scala.collection.mutable.ListBuffer[IRobotProxyClient]
//
//    private[this] val llave = scala.collection.mutable.Map[Symbol, (Boolean, (Symbol, String))]()
//
//    def newObject(): uci.IRobot = {
//        clientFactory send (erlServiceName, erlServiceNodeName, scl2otp('newObject, (serviceClientFactoryName, nodo.fullName.name)))
//        llave += ('newObjectDone -> (false, ('a, "")))
//        while(! llave('newObjectDone)._1)
//        Thread.sleep(10)
//        val sName = serviceClientFactoryName.name + "_client" + clientObjs.length.toString
//        val res = new IRobotProxyClient(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), llave('newObjectDone)._2._1, Symbol(llave('newObjectDone)._2._2))
//        clientObjs += res
//        res
//    }
//
//    val clientFactory = new scala.erlang.server.OtpActor {
//
//        override def node = nodo
//
//        override def acts: PartialFunction[Any, Unit] = {
//
//            case ('newObjectDone, (serviceName: Symbol, serviceNodeName: String)) =>
//                //println(serviceName, serviceNodeName)
//                llave += ('newObjectDone -> (true, (serviceName, serviceNodeName)))
//                //result = (serviceName, serviceNodeName)
//
//            case msg => println("client factory: " + msg)
//        }
//
//    }
//    clientFactory registerName serviceClientFactoryName.name
//
//}

