package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IFabricaProxyServer(
    nodo: Node,
    erlServiceNodeName: String,
    _objetos : java.util.ArrayList[uci.erlProxyGen.IFabrica],
    _global: scala.collection.mutable.Map[Symbol, Any]
 ) {

        private[this] var objetos = scala.collection.mutable.Map[Symbol, uci.erlProxyGen.IFabrica]()

        for(objI <- 0 to _objetos.size - 1){
            val _llave = Symbol("iFabrica" + (objI + 1).toString)
            objetos += (_llave -> _objetos.get(objI))
        }
        _global ++= objetos

        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('mdistanciaHastaAlmacen, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IAlmacen
                val p1 = _global(p1Key).asInstanceOf[uci.IAlmacen] // obtengo el objeto a partir del heap global "_global"
                val res = objetos(senderServiceName) distanciaHastaAlmacen ( p1 )
                send(senderServiceName.name, erlServiceNodeName,
						scl2otp('mdistanciaHastaAlmacenDone, (senderServiceName, Symbol(senderServiceNodeName)),
								new OtpErlangBinary(res)
						)
				)

            case ('mcantidadProductos, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = objetos(senderServiceName).cantidadProductos
                println(res)
                send(senderServiceName.name, erlServiceNodeName,
						scl2otp('mcantidadProductosDone, (senderServiceName, Symbol(senderServiceNodeName)), 
								new OtpErlangBinary(res)
						)
					)

            case msg => println("iFabricaServer no entiende el mensaje: " + msg)
        }

    }
    
    class objIFabricaDone (target: Symbol) extends IFabricaDone {
    }
    
    for(_k <- objetos.keys)
        objetos(_k).setIFabricaDone(new objIFabricaDone(_k))
    //Objeto.setIFabricaDone(objIFabricaDone)
    
    server registerName "iFabricaServer"

}



//class IFabricaProxyServerFactory( nodo: Node,
//                               erlServiceName: String, erlServiceNodeName: String,
//                               serviceFactoryNameStr: String,
//                               obj : uci.erlProxyGen.IFabrica
//) {
//
//    private[this] val serviceFactoryName = Symbol(serviceFactoryNameStr)
//
//    @scala.reflect.BeanProperty private[this] var Services = new scala.collection.mutable.ListBuffer[IFabricaProxyServer]()
//
//    private[this] val server = new scala.erlang.server.OtpActor {
//
//        override def node = nodo
//
//        override def acts: PartialFunction[Any, Unit] = {
//
//            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
//                val sName = serviceFactoryName.name + "_server" + Services.length.toString
//                val t = new IFabricaProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), obj)
//                Services += t
//
//                send( erlServiceName, erlServiceNodeName,
//                     scl2otp('newObjectDone,
//                             (senderFactoryName, Symbol(senderFactoryNodeName)),
//                             (Symbol(sName), nodo.fullName.name)
//                    )
//                )
//
//            case msg => println("server factory..." + msg)
//        }
//
//    }
//    server registerName serviceFactoryName.name
//
//    server send (erlServiceName, erlServiceNodeName,
//                 scl2otp(('registerFactory, (serviceFactoryName, nodo.fullName))) )
//
//}
//
