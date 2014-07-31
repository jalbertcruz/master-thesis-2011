package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IRobotProxyServer(
    nodo: Node,
    erlServiceNodeName: String,
    _objetos : java.util.ArrayList[uci.erlProxyGen.IRobot],
    _global: scala.collection.mutable.Map[Symbol, Any]
 ) {

        private[this] var objetos = scala.collection.mutable.Map[Symbol, uci.erlProxyGen.IRobot]()

        for(objI <- 0 to _objetos.size - 1){
            val _llave = Symbol("iRobot" + (objI + 1).toString)
            objetos += (_llave -> _objetos.get(objI))
        }
        _global ++= objetos

        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('mmoverHastaAlmacen, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IAlmacen
                val p1 = _global(p1Key).asInstanceOf[uci.IAlmacen] // obtengo el objeto a partir del heap global "_global"
                moverHastaAlmacenDoneAux +=( senderServiceName -> (() => {
                   send(senderServiceName.name, erlServiceNodeName,
						scl2otp('mmoverHastaAlmacenDone, (senderServiceName, Symbol(senderServiceNodeName)))
				   )
                }))
                objetos(senderServiceName) moverHastaAlmacen p1

            case ('mmoverHastaFabrica, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IFabrica
                val p1 = _global(p1Key).asInstanceOf[uci.IFabrica] // obtengo el objeto a partir del heap global "_global"
                moverHastaFabricaDoneAux += (senderServiceName -> (() => {
                   send(senderServiceName.name, erlServiceNodeName,
						scl2otp('mmoverHastaFabricaDone, (senderServiceName, Symbol(senderServiceNodeName)))
				    )
                }))
                objetos(senderServiceName) moverHastaFabrica p1

            case ('mdistanciaHastaFabrica, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IFabrica
                val p1 = _global(p1Key).asInstanceOf[uci.IFabrica] // obtengo el objeto a partir del heap global "_global"
                val res = objetos(senderServiceName) distanciaHastaFabrica ( p1 )
                send(senderServiceName.name, erlServiceNodeName,
					scl2otp('mdistanciaHastaFabricaDone, (senderServiceName, Symbol(senderServiceNodeName)), 
								new OtpErlangBinary(res)
					)
				)

            case ('mcogerObjeto, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IFabrica
                val p1 = _global(p1Key).asInstanceOf[uci.IFabrica] // obtengo el objeto a partir del heap global "_global"
                cogerObjetoDoneAux += (senderServiceName -> (() => {
                   send(senderServiceName.name, erlServiceNodeName, scl2otp('mcogerObjetoDone, (senderServiceName, Symbol(senderServiceNodeName))))
                }))
                objetos(senderServiceName) cogerObjeto p1

            case ('mentregarObjeto, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IAlmacen
                val p1 = _global(p1Key).asInstanceOf[uci.IAlmacen] // obtengo el objeto a partir del heap global "_global"
                entregarObjetoDoneAux += (senderServiceName -> (() => {
                   send(senderServiceName.name, erlServiceNodeName, scl2otp('mentregarObjetoDone, (senderServiceName, Symbol(senderServiceNodeName))))
                }))
                objetos(senderServiceName) entregarObjeto p1

            case ('mdistanciaHastaAlmacen, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p1Key = b.getObject().asInstanceOf[Symbol] // obtengo la llave del proxy de IAlmacen
                val p1 = _global(p1Key).asInstanceOf[uci.IAlmacen] // obtengo el objeto a partir del heap global "_global"
                val res = objetos(senderServiceName) distanciaHastaAlmacen ( p1 )
                send(senderServiceName.name, erlServiceNodeName, scl2otp('mdistanciaHastaAlmacenDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
                
            case msg => println("iRobotServer no entiende el mensaje: " + msg)
                
        }

    }

    class objIRobotDone (target: Symbol) extends IRobotDone {
        def moverHastaAlmacenDone(){
                moverHastaAlmacenDoneAux(target)()
        }
        def moverHastaFabricaDone(){
                moverHastaFabricaDoneAux(target)()
        }
        def cogerObjetoDone(){
                cogerObjetoDoneAux(target)()
        }
        def entregarObjetoDone(){
                entregarObjetoDoneAux(target)()
        }
    }

    val moverHastaAlmacenDoneAux = scala.collection.mutable.Map[Symbol, () => Unit]()
    val moverHastaFabricaDoneAux = scala.collection.mutable.Map[Symbol, () => Unit]()
    val cogerObjetoDoneAux = scala.collection.mutable.Map[Symbol, () => Unit]()
    val entregarObjetoDoneAux = scala.collection.mutable.Map[Symbol, () => Unit]()

    for(_k <- objetos.keys)
        objetos(_k).setIRobotDone(new objIRobotDone(_k))

    server registerName "iRobotServer"

}

