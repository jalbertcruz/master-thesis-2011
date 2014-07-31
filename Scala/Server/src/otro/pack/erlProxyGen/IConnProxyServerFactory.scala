package otro.pack.erlProxyGen
import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.erlang.server._

class IConnProxyServerFactory( nodo: Node,
                               erlServiceName: String, erlServiceNodeName: String,
                               serviceFactoryName: Symbol ) {

    @scala.reflect.BeanProperty private[this] var Services = new scala.collection.mutable.ListBuffer[IConnProxyServer]()

    private[this] val server = new scala.erlang.server.OtpActor {

        override def node = nodo

        override def acts: PartialFunction[Any, Unit] = {

            case ('newObject, (senderFactoryName: Symbol, senderFactoryNodeName: String)) =>
                val sName = serviceFactoryName.name + "_server" + Services.length.toString
                val t = new IConnProxyServer(nodo, erlServiceName, erlServiceNodeName, Symbol(sName))
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


class IConnProxyServer( nodo: Node,
                         erlServiceName: String, erlServiceNodeName: String,
                         serviceName: Symbol ) {
   @scala.reflect.BeanProperty private[this] var Objeto : otro.pack.Coneccion = new otro.pack.Coneccion
        private[this] val server = new scala.erlang.server.OtpActor {
        override def node = nodo
        override def acts: PartialFunction[Any, Unit] = {

            case ('mobjeto, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = Objeto.objeto
                send(erlServiceName, erlServiceNodeName, scl2otp('mobjetoDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mDameDatos, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[scala.Int]
                val res = Objeto DameDatos ( p0 )
                send (erlServiceName, erlServiceNodeName, scl2otp('mDameDatosDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mActuar2, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val ( p0 : scala.Double, p1 : scala.Boolean ) = b.getObject()
                Objeto Actuar2 (p0, p1)
                send (erlServiceName, erlServiceNodeName, scl2otp('mActuar2Done, (senderServiceName, Symbol(senderServiceNodeName))))
            case ('mgetVal, (senderServiceName: Symbol, senderServiceNodeName: String)) =>
                val res = Objeto.getVal
                send(erlServiceName, erlServiceNodeName, scl2otp('mgetValDone, (senderServiceName, Symbol(senderServiceNodeName)), new OtpErlangBinary(res)))
            case ('mactuar1, (senderServiceName: Symbol, senderServiceNodeName: String), b: OtpErlangBinary) =>
                val p0 = b.getObject().asInstanceOf[scala.Double]
                Objeto actuar1 p0
                send (erlServiceName, erlServiceNodeName, scl2otp('mactuar1Done, (senderServiceName, Symbol(senderServiceNodeName))))
            case msg => println("server " + msg)
        }

    }
    server registerName serviceName.name

}

