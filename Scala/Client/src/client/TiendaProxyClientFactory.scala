
package client
import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class TiendaProxyClientFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceClientFactoryName: Symbol ) {

    private[this] val clientObjs = new scala.collection.mutable.ListBuffer[TiendaProxyClient]

    private[this] val llave = scala.collection.mutable.Map[Symbol, (Boolean, (Symbol, String))]()

    def newObject(): uci.interfaces.Tienda = {
        clientFactory send (erlServiceName, erlServiceNodeName, scl2otp('newObject, (serviceClientFactoryName, nodo.fullName.name)))
        llave += ('newObjectDone -> (false, ('a, "")))
        while(! llave('newObjectDone)._1)
        Thread.sleep(100)
        val sName = serviceClientFactoryName.name + "_client" + clientObjs.length.toString
        val res = new TiendaProxyClient(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), llave('newObjectDone)._2._1, Symbol(llave('newObjectDone)._2._2))
        clientObjs += res
        res
    }

    val clientFactory = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('newObjectDone, (serviceName: Symbol, serviceNodeName: String)) =>
                //println(serviceName, serviceNodeName)
                llave += ('newObjectDone -> (true, (serviceName, serviceNodeName)))
                //result = (serviceName, serviceNodeName)

            case msg => println("client factory: " + msg)
        }

    }
    clientFactory registerName serviceClientFactoryName.name

}
