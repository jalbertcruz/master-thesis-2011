package server

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class TiendaProxyServer ( nodo: Node, 
                         erlServiceName: String, erlServiceNodeName: String,
                         serviceName: Symbol ) {

    @scala.reflect.BeanProperty private[this] var Objeto = new uci.interfaces.impl.TiendaCubana()

    //private[this] val nodo: Node = new Node("nServer@10.36.15.117", "coo")
    
    private[this] val server = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('vender, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val ( p0 : uci.entidades.TArticulos, p1: scala.Double ) = b.getObject()
                val res = Objeto vender (p0, p1)
                send (erlServiceName, erlServiceNodeName, scl2otp('venderDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))

            case ('getCantVendidos, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[uci.entidades.TArticulos]
                val res = Objeto getCantVendidos ( p0 )
                send (erlServiceName, erlServiceNodeName, scl2otp('getCantVendidosDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))

            case ('getCantidadDeVentas, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = Objeto.getCantidadDeVentas
                send(erlServiceName, erlServiceNodeName, scl2otp('getCantidadDeVentasDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))

            case ('cambiarPrecio, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val ( p0 : uci.entidades.TArticulos, p1: scala.Double ) = b.getObject()
                Objeto cambiarPrecio (p0, p1)
                send (erlServiceName, erlServiceNodeName, scl2otp('cambiarPrecioDone, (senderServiceName, Symbol(senderServiceNodeName))))

            case ('aumentarPreciosEn, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[scala.Double]
                Objeto aumentarPreciosEn p0
                send (erlServiceName, erlServiceNodeName, scl2otp('aumentarPreciosEnDone, (senderServiceName, Symbol(senderServiceNodeName))))

            case ('reflejarVentasUnitarias, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                Objeto.reflejarVentasUnitarias
                send(erlServiceName, erlServiceNodeName, scl2otp('reflejarVentasUnitariasDone, (senderServiceName, Symbol(senderServiceNodeName))))

            case msg => println("server " + msg)
        }

    }
    server registerName serviceName.name
}
