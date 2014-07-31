package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IVentiladorProxyServerFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceFactoryNameStr: String,
                               obj : uci.erlProxyGen.IVentilador 
) {

    private[this] val serviceFactoryName = Symbol(serviceFactoryNameStr)

    @scala.reflect.BeanProperty private[this] var Services = new scala.collection.mutable.ListBuffer[IVentiladorProxyServer]()

    private[this] val server = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
                val sName = serviceFactoryName.name + "_server" + Services.length.toString
                val t = new IVentiladorProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), obj)
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


class IVentiladorProxyServer( nodo: Node,
                         erlServiceName: String, erlServiceNodeName: String,
                         serviceName: Symbol,
                         Objeto : uci.erlProxyGen.IVentilador
 ) {


var darNVueltasDoneAux:() => Unit = _

var vecesDoneAux:(tiposPrimitivos.Numero) => Unit = _

var darUnaVueltaDoneAux:() => Unit = _


        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo
        override def acts: PartialFunction[Any, Unit] = {

            case ('mdarNVueltas, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[tiposPrimitivos.Numero]
                darNVueltasDoneAux = () => {
                   send (erlServiceName, erlServiceNodeName, scl2otp('mdarNVueltasDone, (senderServiceName, Symbol(senderServiceNodeName))))
                }
                Objeto darNVueltas p0                
            case ('mveces, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                var res : tiposPrimitivos.Numero = null
                vecesDoneAux = (a) => {
                send(erlServiceName, erlServiceNodeName, scl2otp('mvecesDone, (senderServiceName, Symbol(senderServiceNodeName)), 
                   new OtpErlangBinary(a )))
		}                
                res = Objeto.veces                
            case ('mdarUnaVuelta, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                darUnaVueltaDoneAux = () => {
                   send(erlServiceName, erlServiceNodeName, scl2otp('mdarUnaVueltaDone, (senderServiceName, Symbol(senderServiceNodeName))))
                }
                Objeto.darUnaVuelta
                                
            case ('mcambiarSentido, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                Objeto.cambiarSentido
                send(erlServiceName, erlServiceNodeName, scl2otp('mcambiarSentidoDone, (senderServiceName, Symbol(senderServiceNodeName))))
                                
            case msg => println("server " + msg)
        }

    }
    
    object objIVentiladorDone extends IVentiladorDone {


    	      		def darNVueltasDone(){
    	    			darNVueltasDoneAux()
    	    		}
    	        
    	      		def vecesDone(r: tiposPrimitivos.Numero){
    	    			vecesDoneAux(r)
    	    		}
    	        
    	      		def darUnaVueltaDone(){
    	    			darUnaVueltaDoneAux()
    	    		}
    	        
    	            	
    
    }
    
    Objeto.setIVentiladorDone(objIVentiladorDone)
    
    server registerName serviceName.name

}

