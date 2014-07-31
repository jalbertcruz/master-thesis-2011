package uci.erlProxyGen

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

import uci.entidades.ParObjetoRemoto

class IAlmacenProxyClient(
                           node: Node,
                           erlServiceNodeName: String,
                           _global: scala.collection.mutable.Map[Symbol, Any]
                           ) {

  private[this] val _objsNombres = List("almacen")
  val objetos = new java.util.ArrayList[uci.entidades.ParObjetoRemoto]()

  for (i <- 0 to _objsNombres.length - 1) {
    val _llave = Symbol("iAlmacen" + (i + 1).toString)
    val __t = new IAlmacenProxyClientImpl(_llave)
    _global += (_llave -> __t)
    objetos.add(new ParObjetoRemoto(_objsNombres(i), __t))
  }

  class IAlmacenProxyClientImpl(target: Symbol) extends uci.IAlmacen {

    private[this] def getKey(value: Any): Symbol = {
      for (i <- _global.keys)
        if (_global(i) == value)
          return i
      return 'none
    }

    def valorDeX: tiposPrimitivos.Numero = {
      throw new java.lang.UnsupportedOperationException("Not supported yet.");
    }

    def valorDeY: tiposPrimitivos.Numero = {
      throw new java.lang.UnsupportedOperationException("Not supported yet.");
    }

    def poner(p0: uci.IObjeto) {
      throw new java.lang.UnsupportedOperationException("Not supported yet.");
    }

    def sacar: uci.IObjeto = {
      throw new java.lang.UnsupportedOperationException("Not supported yet.");
    }

    def cantidadProductos: tiposPrimitivos.Numero = {
      proxy.sendAndWait(
        target, 'mcantidadProductos
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
      while (!llaves((obj, mth))._1)
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
      while (!llaves((obj, mth))._1)
        Thread.sleep(10)
      llaves((obj, mth))._2
    }

    val client = new scala.erlang.server.OtpActor {
      override def node = nodo

      override def acts: PartialFunction[Any, Unit] = {

        case (target: Symbol, 'mcantidadProductosDone, res: OtpErlangBinary) =>
          llaves += ((target, 'mcantidadProductos) -> (true, res.getObject()))

        case msg => println(msg)
      }

    }
    client registerName "iAlmacenClient"
  }


}

//class IAlmacenProxyClientFactory(
//		nodo: Node,erlServiceName: String,
//		erlServiceNodeName: String,
//		serviceClientFactoryNameStr: String,
//		_global = scala.collection.mutable.Map[Symbol, Any]
//) {
//
//    private[this] val serviceClientFactoryName = Symbol(serviceClientFactoryNameStr)
//
//    private[this] val clientObjs = new scala.collection.mutable.ListBuffer[IAlmacenProxyClient]
//
//    private[this] val llave = scala.collection.mutable.Map[Symbol, (Boolean, (Symbol, String))]()
//
//    def newObject(): uci.IAlmacen = {
//        clientFactory send (erlServiceName, erlServiceNodeName, scl2otp('newObject, (serviceClientFactoryName, nodo.fullName.name)))
//        llave += ('newObjectDone -> (false, ('a, "")))
//        while(! llave('newObjectDone)._1)
//        Thread.sleep(10)
//        val sName = serviceClientFactoryName.name + "_client" + clientObjs.length.toString
//        val res = new IAlmacenProxyClient(nodo, erlServiceName, erlServiceNodeName, Symbol(sName), llave('newObjectDone)._2._1, Symbol(llave('newObjectDone)._2._2))
//        clientObjs += res
//        res
//    }
//
//    val clientFactory = new scala.erlang.server.OtpActor {
//
//        override def node = nodo
//
//        override def acts: PartialFunction[Any, Unit] = {
//
//            case ('newObjectDone, (serviceName: Symbol, serviceNodeName: String)) =>
//                //println(serviceName, serviceNodeName)
//                llave += ('newObjectDone -> (true, (serviceName, serviceNodeName)))
//                //result = (serviceName, serviceNodeName)
//
//            case msg => println("client factory: " + msg)
//        }
//
//    }
//    clientFactory registerName serviceClientFactoryName.name
//
//}