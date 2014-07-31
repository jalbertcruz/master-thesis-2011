package uci.interfaces.erlProxyGen

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
        Thread.sleep(10)
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

class TiendaProxyClient (node: Node,
                        erlServiceName: String, erlServiceNodeName: String,
                        senderServiceName: Symbol,
                        serviceName: Symbol, serviceNodeName: Symbol) extends uci.interfaces.Tienda {

    def getCantidadDeVentas: scala.Int = {
        proxy.sendAndWait(
            'mgetCantidadDeVentas
        ).asInstanceOf[scala.Int]
    }
    def getCantVendidos(p0 : uci.entidades.TArticulos): scala.Int = {
        proxy.sendAndWait(
            'mgetCantVendidos, new OtpErlangBinary(p0)
        ).asInstanceOf[scala.Int]
    }
    def cambiarPrecio(p0 : uci.entidades.TArticulos, p1 : scala.Double) {
        proxy.sendAndWait(
            'mcambiarPrecio, new OtpErlangBinary(p0, p1)
        )
    }
    def aumentarPreciosEn(p0 : scala.Double) {
        proxy.sendAndWait(
            'maumentarPreciosEn, new OtpErlangBinary(p0)
        )
    }
    def vender(p0 : uci.entidades.TArticulos, p1 : scala.Double): uci.entidades.Venta = {
        proxy.sendAndWait(
            'mvender, new OtpErlangBinary(p0, p1)
        ).asInstanceOf[uci.entidades.Venta]
    }
    def reflejarVentasUnitarias() {
        proxy.sendAndWait(
            'mreflejarVentasUnitarias
        )
    }

    private[this] object proxy {
        val nodo: Node = node
        val llaves = scala.collection.mutable.Map[Symbol, (Boolean, Any)]()
        def sendAndWait(label: Symbol, arg: OtpErlangBinary) = {
            client send ( erlServiceName, erlServiceNodeName, scl2otp(label,
                                                                      (senderServiceName, node.fullName.name),
                                                                      (serviceName, serviceNodeName),
                                                                      arg) )
            llaves += (label -> (false, 0))
            while(! llaves(label)._1)
            Thread.sleep(10)
            llaves(label)._2
        }
        def sendAndWait(label: Symbol) = {

            client send ( erlServiceName, erlServiceNodeName, scl2otp(label,
                                                                      (senderServiceName, node.fullName.name),
                                                                      (serviceName, serviceNodeName)
                                                              )
            )
            llaves += (label -> (false, 0))
            while(! llaves(label)._1)
            Thread.sleep(10)
            llaves(label)._2
        }

        val client = new scala.erlang.server.OtpActor {
            override def node = nodo
            override def acts: PartialFunction[Any, Unit] = {

                case ('mgetCantidadDeVentasDone, res: OtpErlangBinary ) =>
                    llaves += ('mgetCantidadDeVentas -> (true, res.getObject()))
                case ('mgetCantVendidosDone, res: OtpErlangBinary ) =>
                    llaves += ('mgetCantVendidos -> (true, res.getObject()))
                case 'mcambiarPrecioDone =>
                    llaves += ('mcambiarPrecio -> (true, 0))
                case 'maumentarPreciosEnDone =>
                    llaves += ('maumentarPreciosEn -> (true, 0))
                case ('mvenderDone, res: OtpErlangBinary ) =>
                    llaves += ('mvender -> (true, res.getObject()))
                case 'mreflejarVentasUnitariasDone =>
                    llaves += ('mreflejarVentasUnitarias -> (true, 0))

                case msg => println(msg)
            }

        }
        client registerName senderServiceName.name
    }
}
