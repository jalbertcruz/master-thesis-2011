package client

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class TiendaProxyClient(node: Node,
                        erlServiceName: String, erlServiceNodeName: String,
                        senderServiceName: Symbol,
                        serviceName: Symbol, serviceNodeName: Symbol) extends uci.interfaces.Tienda {

    def vender( p0 : uci.entidades.TArticulos, p1: scala.Double ): uci.entidades.Venta = {
        proxy.sendAndWait(
            'vender, new OtpErlangBinary(p0, p1)
        ).asInstanceOf[uci.entidades.Venta]
    }
    def getCantVendidos(p0 : uci.entidades.TArticulos): scala.Int = {
        proxy.sendAndWait(
            'getCantVendidos, new OtpErlangBinary(p0)
        ).asInstanceOf[scala.Int]
    }
    def getCantidadDeVentas: scala.Int = {
        proxy.sendAndWait(
            'getCantidadDeVentas
        ).asInstanceOf[scala.Int]
    }
    def cambiarPrecio( p0 : uci.entidades.TArticulos, p1: scala.Double ){
        proxy.sendAndWait(
            'cambiarPrecio, new OtpErlangBinary(p0, p1)
        )
    }
    def aumentarPreciosEn( p0 : scala.Double ){
        proxy.sendAndWait(
            'aumentarPreciosEn, new OtpErlangBinary(p0)
        )
    }
    def reflejarVentasUnitarias() {
        proxy.sendAndWait(
            'reflejarVentasUnitarias
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

                case ('venderDone, res: OtpErlangBinary ) =>
                    llaves += ('vender -> (true, res.getObject()))

                case ('getCantVendidosDone, res: OtpErlangBinary ) =>
                    llaves += ('getCantVendidos -> (true, res.getObject()))

                case ('getCantidadDeVentasDone, res: OtpErlangBinary ) =>
                    llaves += ('getCantidadDeVentas -> (true, res.getObject()))

                case 'cambiarPrecioDone =>
                    llaves += ('cambiarPrecio -> (true, 0))

                case 'aumentarPreciosEnDone =>
                    llaves += ('aumentarPreciosEn -> (true, 0))

                case 'reflejarVentasUnitariasDone =>
                    llaves += ('reflejarVentasUnitarias -> (true, 0))

                case msg => println(msg)
            }

        }
        client registerName senderServiceName.name

    }
}
