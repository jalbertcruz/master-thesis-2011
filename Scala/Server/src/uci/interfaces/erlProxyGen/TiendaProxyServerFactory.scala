package uci.interfaces.erlProxyGen
import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class TiendaProxyServerFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceFactoryName: Symbol ) {

    @scala.reflect.BeanProperty private[this] var Services = new scala.collection.mutable.ListBuffer[TiendaProxyServer]()

    private[this] val server = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
                val sName = serviceFactoryName.name + "_server" + Services.length.toString
                val t = new TiendaProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName))
                Services += t

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


class TiendaProxyServer( nodo: Node,
                         erlServiceName: String, erlServiceNodeName: String,
                         serviceName: Symbol ) {
   @scala.reflect.BeanProperty private[this] var Objeto : uci.interfaces.impl.TiendaCubana = new uci.interfaces.impl.TiendaCubana
        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo
        override def acts: PartialFunction[Any, Unit] = {

            case ('mgetCantidadDeVentas, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = Objeto.getCantidadDeVentas
                send(erlServiceName, erlServiceNodeName, scl2otp('mgetCantidadDeVentasDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mgetCantVendidos, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[uci.entidades.TArticulos]
                val res = Objeto getCantVendidos ( p0 )
                send (erlServiceName, erlServiceNodeName, scl2otp('mgetCantVendidosDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mcambiarPrecio, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val ( p0 : uci.entidades.TArticulos, p1 : scala.Double ) = b.getObject()
                Objeto cambiarPrecio (p0, p1)
                send (erlServiceName, erlServiceNodeName, scl2otp('mcambiarPrecioDone, (senderServiceName, Symbol(senderServiceNodeName))))
            case ('maumentarPreciosEn, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[scala.Double]
                Objeto aumentarPreciosEn p0
                send (erlServiceName, erlServiceNodeName, scl2otp('maumentarPreciosEnDone, (senderServiceName, Symbol(senderServiceNodeName))))
            case ('mvender, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val (p0 : uci.entidades.TArticulos, p1 : scala.Double) = b.getObject()
                val res = Objeto vender (p0, p1)
                send (erlServiceName, erlServiceNodeName, scl2otp('mvenderDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mreflejarVentasUnitarias, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                Objeto.reflejarVentasUnitarias
                send(erlServiceName, erlServiceNodeName, scl2otp('mreflejarVentasUnitariasDone, (senderServiceName, Symbol(senderServiceNodeName))))
            case msg => println("server " + msg)
        }

    }
    server registerName serviceName.name

}

