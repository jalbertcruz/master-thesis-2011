
package client
import scala.erlang.server._

object Main {

    def main(args: Array[String]) :Unit = {
        
        //val node = new Node("nClient@10.36.14.131", "coo")
        val node = new Node(args(0)+"@10.36.14.131", "coo")

        if (false){
            val factory = new uci.interfaces.erlProxyGen.TiendaProxyClientFactory(node, "channel", "nChannel@10.36.14.131", 'factoryClient)
        
            val tienda = factory.newObject()
        
            println(tienda.vender(uci.entidades.TArticulos.zapato, 400.0))
        
            println(tienda.getCantVendidos(uci.entidades.TArticulos.zapato))
        
            println(tienda.vender(uci.entidades.TArticulos.zapato, 390.0))
        
            tienda.reflejarVentasUnitarias
        
            tienda.cambiarPrecio(uci.entidades.TArticulos.zapato, 32.0)
        
            tienda.aumentarPreciosEn(2.0)
        
            println(tienda.vender(uci.entidades.TArticulos.zapato, 400.0))
        
            println(tienda.vender(uci.entidades.TArticulos.zapato, 390.0))
        
            println(tienda.getCantVendidos(uci.entidades.TArticulos.zapato))

        }
        else{
            val factory = new uci.interfaces.erlProxyGen.TiendaProxyClientFactory(node, "channel", "nChannel@10.36.14.131", 'factoryClient)

            val tienda = factory.newObject()

            println(tienda.vender(uci.entidades.TArticulos.zapato, 400.0))

            println(tienda.getCantVendidos(uci.entidades.TArticulos.zapato))

            println(tienda.vender(uci.entidades.TArticulos.zapato, 390.0))

            tienda.reflejarVentasUnitarias

            tienda.cambiarPrecio(uci.entidades.TArticulos.zapato, 32.0)

            tienda.aumentarPreciosEn(2.0)

            println(tienda.vender(uci.entidades.TArticulos.zapato, 400.0))

            println(tienda.vender(uci.entidades.TArticulos.zapato, 390.0))

            println(tienda.getCantVendidos(uci.entidades.TArticulos.zapato))
        }
        
        true
    }

}
