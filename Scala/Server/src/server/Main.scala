
package server
import scala.erlang.server._

object Main {

    def main(args: Array[String]) :Unit = {

        val node = new Node("nServer@10.36.14.131", "coo")
        if (false){
            val proxyServerFactory = new uci.interfaces.erlProxyGen.TiendaProxyServerFactory(node,
                                                                                             "channel", "nChannel@10.36.14.131",
                                                                                             Symbol("factoryServer"))


        true        }
        else{
            val proxyServerFactory = new uci.interfaces.erlProxyGen.TiendaProxyServerFactory(node,
                                                                                             "channel", "nChannel@10.36.14.131",
                                                                                             Symbol("factoryServer"))


        true
        }
    }

}

//werl -name nChannel@10.36.14.131 -setcookie coo
