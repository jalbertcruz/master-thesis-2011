
package scala.erlang.client

import scala.erlang.conversions.Converter._
import com.ericsson.otp.erlang._
import scala.actors._

abstract class OtpActor {

    def acts: PartialFunction[Any, Unit]

    def node: OtpSelf

    def peer: OtpPeer

    private[this] val connection: OtpConnection       = node connect peer

    def deliver(msg: OtpMsg)                          = connection deliver msg

    def exit(dest: OtpErlangPid, reason: OtpErlangObject)
    = connection exit (dest, reason)

    def link(dest: OtpErlangPid)                      = connection link dest

    def msgCount                                      = connection.msgCount

    def send (name: String, msg: Any)                 = connection send (name, scl2otp(msg))

    def send (to: OtpErlangPid, msg: Any)             = connection send (to, scl2otp(msg))

    private[this] var me: Actor =  scala.actors.Actor.actor {
        scala.actors.Actor.loop {
            if (! actorActive) scala.actors.Actor.exit()
            scala.actors.Actor.react(acts)
        }
    }

    private[this] var actorActive = true

    // actor que recibe de Erlang y manda para el mio
    private[this] val _t1 = new Runnable{
        def run() {
            while(actorActive){ // No se si hace falta para que se pare el Actor, a veces parece que si a veces que no... por si acaso uso la bandera!
                me ! otp2scl( connection.receive )
            }
        }
    }

    val th = new Thread( _t1 )
    th.start()

    def terminate(): Unit = {
        actorActive = false
    }

}

