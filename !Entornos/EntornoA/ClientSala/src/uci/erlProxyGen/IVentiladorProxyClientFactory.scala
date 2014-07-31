package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IVentiladorProxyClientFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceClientFactoryNameStr: String ) {

    private[this] val serviceClientFactoryName = Symbol(serviceClientFactoryNameStr)
    
    private[this] val clientObjs = new scala.collection.mutable.ListBuffer[IVentiladorProxyClient]

    private[this] val llave = scala.collection.mutable.Map[Symbol, (Boolean, (Symbol, String))]()

    def newObject(): uci.IVentilador = {
        clientFactory send (erlServiceName, erlServiceNodeName, scl2otp('newObject, (serviceClientFactoryName, nodo.fullName.name)))
        llave += ('newObjectDone -> (false, ('a, "")))
        while(! llave('newObjectDone)._1)
        Thread.sleep(10)
        val sName = serviceClientFactoryName.name + "_client" + clientObjs.length.toString
        val res = new IVentiladorProxyClient(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), llave('newObjectDone)._2._1, Symbol(llave('newObjectDone)._2._2))
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

class IVentiladorProxyClient (node: Node,
                        erlServiceName: String, erlServiceNodeName: String,
                        senderServiceName: Symbol,
                        serviceName: Symbol, serviceNodeName: Symbol) extends uci.IVentilador {

    def darNVueltas(p0 : tiposPrimitivos.Numero) {
        proxy.sendAndWait(
            'mdarNVueltas, new OtpErlangBinary(p0)
        )
    }
    def veces: tiposPrimitivos.Numero = {
        proxy.sendAndWait(
            'mveces
        ).asInstanceOf[tiposPrimitivos.Numero]
    }
    def darUnaVuelta() {
        proxy.sendAndWait(
            'mdarUnaVuelta
        )
    }
    def cambiarSentido() {
        proxy.sendAndWait(
            'mcambiarSentido
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

                case 'mdarNVueltasDone =>
                    llaves += ('mdarNVueltas -> (true, 0))
                case ('mvecesDone, res: OtpErlangBinary ) =>
                    llaves += ('mveces -> (true, res.getObject()))
                case 'mdarUnaVueltaDone =>
                    llaves += ('mdarUnaVuelta -> (true, 0))
                case 'mcambiarSentidoDone =>
                    llaves += ('mcambiarSentido -> (true, 0))

                case msg => println(msg)
            }

        }
        client registerName senderServiceName.name
    }
}
