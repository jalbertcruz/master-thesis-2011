package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IAlmacenProxyServer( 
    nodo: Node,
    erlServiceNodeName: String,
    _objetos : java.util.ArrayList[uci.erlProxyGen.IAlmacen],
    _global: scala.collection.mutable.Map[Symbol, Any]
 ) {

        private[this] var objetos = scala.collection.mutable.Map[Symbol, uci.erlProxyGen.IAlmacen]()

        for(objI <- 0 to _objetos.size - 1){
            val _llave = Symbol("iAlmacen" + (objI + 1).toString)
            objetos += (_llave -> _objetos.get(objI))
        }
        _global ++= objetos

        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo
        override def acts: PartialFunction[Any, Unit] = {

            case ('mcantidadProductos, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = objetos(senderServiceName).cantidadProductos
                send(senderServiceName.name, erlServiceNodeName, scl2otp('mcantidadProductosDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
                
            case msg => println("iAlmacenServer no entiende el mensaje: " + msg)
        }
    }
    
    class objIAlmacenDone (target: Symbol) extends IAlmacenDone {
    }
    
    for(_k <- objetos.keys)
        objetos(_k).setIAlmacenDone(new objIAlmacenDone(_k))
    //Objeto.setIAlmacenDone(objIAlmacenDone)
    
    server registerName "iAlmacenServer"

}


//class IAlmacenProxyServerFactory( nodo: Node,
//                               erlServiceName: String, erlServiceNodeName: String,
//                               serviceFactoryNameStr: String,
//                               obj : uci.erlProxyGen.IAlmacen
//) {
//
//    private[this] val serviceFactoryName = Symbol(serviceFactoryNameStr)
//
//    @scala.reflect.BeanProperty private[this] var Services = new scala.collection.mutable.ListBuffer[IAlmacenProxyServer]()
//
//    private[this] val server = new scala.erlang.server.OtpActor {
//
//        override def node = nodo
//
//        override def acts: PartialFunction[Any, Unit] = {
//
//            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
//                val sName = serviceFactoryName.name + "_server" + Services.length.toString
//                val t = new IAlmacenProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), obj)
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
