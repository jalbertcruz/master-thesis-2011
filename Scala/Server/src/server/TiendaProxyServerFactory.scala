
package server

import scala.erlang.server._
import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._

class TiendaProxyServerFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceFactoryName: Symbol ) {

    @scala.reflect.BeanProperty private[this] var Tiendas = new scala.collection.mutable.ListBuffer[TiendaProxyServer]()

    private[this] val server = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
                val sName = serviceFactoryName.name + "_server" + Tiendas.length.toString
                val t = new TiendaProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName))
                Tiendas += t
                
                send( erlServiceName, erlServiceNodeName,
                     scl2otp('newObjectDone,
                             (senderFactoryName, Symbol(senderFactoryNodeName)),
                             (Symbol(sName), nodo.fullName.name)
                    )
                )

            case msg => println("server factory..." + msg)
        }

    }
    server registerName serviceFactoryName.name

    server send (erlServiceName, erlServiceNodeName,
                 scl2otp(('registerFactory, (serviceFactoryName, nodo.fullName))) )

}
