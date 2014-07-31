package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

import uci.entidades.ParObjetoRemoto


class IRobotProxyClient (
    node: Node,
      erlServiceNodeName: String,
      _global: scala.collection.mutable.Map[Symbol, Any]
){

private[this] val _objsNombres = List("robot")
val objetos = new java.util.ArrayList[uci.entidades.ParObjetoRemoto]()

for(i <- 0 to _objsNombres.length-1){
    val _llave = Symbol("iRobot" + (i + 1).toString)
    val __t = new IRobotProxyClientImpl ( _llave )
    _global += ( _llave ->  __t )
    objetos.add( new ParObjetoRemoto( _objsNombres(i), __t ) )
}
 
class IRobotProxyClientImpl(target: Symbol) extends uci.IRobot {

    private[this] def getKey(value: Any): Symbol = {
        for(i <- _global.keys)
        if (_global(i) == value)
        return i
        return 'none
    }

    def moverHastaAlmacen(p0 : uci.IAlmacen) {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mmoverHastaAlmacen, new OtpErlangBinary(p01)
        )
    }
    def moverHastaFabrica(p0 : uci.IFabrica) {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mmoverHastaFabrica, new OtpErlangBinary(p01)
        )
    }
    def distanciaHastaFabrica(p0 : uci.IFabrica): tiposPrimitivos.Numero = {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mdistanciaHastaFabrica, new OtpErlangBinary(p01)
        ).asInstanceOf[tiposPrimitivos.Numero]
    }
    def cogerObjeto(p0 : uci.IFabrica) {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mcogerObjeto, new OtpErlangBinary(p01)
        )
    }
    def entregarObjeto(p0 : uci.IAlmacen) {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mentregarObjeto, new OtpErlangBinary(p01)
        )
    }
    def distanciaHastaAlmacen(p0 : uci.IAlmacen): tiposPrimitivos.Numero = {
        val p01 = getKey(p0)
        proxy.sendAndWait(
            target, 'mdistanciaHastaAlmacen, new OtpErlangBinary(p01)
        ).asInstanceOf[tiposPrimitivos.Numero]
    }
}

private[this] object proxy {
    val nodo: Node = node
    val llaves = scala.collection.mutable.Map[(Symbol, Symbol), (Boolean, Any)]()
    //(Symbol,   Symbol),    (Boolean,   Any) :-
    //(<objeto>, <mensaje>), (<cerrojo>, <resultado>)
    def sendAndWait(obj: Symbol, mth: Symbol, arg: OtpErlangBinary) = {
        client send ( 
                  obj.name, // proceso al que se le envia el mensaje (que esta registrado en un nodo)
                  erlServiceNodeName, // nodo al que se le envia el mensaje
                  scl2otp(
                        obj, // (Symbol) objeto al que se le envia el mensaje
                        mth, // (Symbol) metodo a ejecutar
                        node.fullName.name, // (Symbol) nodo que envia el mensaje
                        arg // argumentos del metodo
                  ) // mensaje
              )
        llaves += ((obj, mth) -> (false, 0))
        while(! llaves((obj, mth))._1)
        Thread.sleep(10)
        llaves((obj, mth))._2
    }

    def sendAndWait(obj: Symbol, mth: Symbol) = {
        client send (
                  obj.name, // proceso al que se le envia el mensaje (que esta registrado en un nodo)
                  erlServiceNodeName, // nodo al que se le envia el mensaje
                  scl2otp(
                        obj, // (Symbol) objeto al que se le envia el mensaje
                        mth, // (Symbol) metodo a ejecutar
                        node.fullName.name // (Symbol) nodo que envia el mensaje
                  ) // mensaje
              )
        llaves += ((obj, mth) -> (false, 0))
        while(! llaves((obj, mth))._1)
        Thread.sleep(10)
        llaves((obj, mth))._2
    }
    

    val client = new scala.erlang.server.OtpActor {
        override def node = nodo
        override def acts: PartialFunction[Any, Unit] = {

            case (target: Symbol, 'mmoverHastaAlmacenDone) =>
                llaves += ((target, 'mmoverHastaAlmacen) -> (true, 0))
            case (target: Symbol, 'mmoverHastaFabricaDone) =>
                llaves += ((target, 'mmoverHastaFabrica) -> (true, 0))
            case (target: Symbol, 'mdistanciaHastaFabricaDone, res: OtpErlangBinary ) =>
                llaves += ((target, 'mdistanciaHastaFabrica) -> (true, res.getObject()))
            case (target: Symbol, 'mcogerObjetoDone) =>
                llaves += ((target, 'mcogerObjeto) -> (true, 0))
            case (target: Symbol, 'mentregarObjetoDone) =>
                llaves += ((target, 'mentregarObjeto) -> (true, 0))
            case (target: Symbol, 'mdistanciaHastaAlmacenDone, res: OtpErlangBinary ) =>
                llaves += ((target, 'mdistanciaHastaAlmacen) -> (true, res.getObject()))

            case msg => println(msg)
        }

    }
    
    client registerName "iRobotClient"
}
}
