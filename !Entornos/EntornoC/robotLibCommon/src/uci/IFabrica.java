package uci;

import anotaciones.*;
import tiposPrimitivos.Numero;

@proxy 
@plural("Fábricas")


@nombre("Fábrica")

@exportar({"fab1", "fab2", "fab3"})

public interface IFabrica extends ILugar {

    @objeto(" Distancia de la fábrica ")
    Numero distanciaHastaAlmacen(
            @etiqueta(" hasta el almacén ")
            IAlmacen almacen);


    @objeto(" Cantidad de productos que tiene la fábrica ")
    Numero cantidadProductos();

    @ignorar
    IObjeto sacar();
}
