package uci;

import anotaciones.*;
import tiposPrimitivos.Numero;

@proxy
@nombre("Fábrica")
@plural("Fábricas")
public interface IFabrica extends ILugar {

    @objeto(" Cantidad de productos que tiene la fábrica ")
    Numero cantidadProductos();

    @objeto(" Distancia de la fábrica ")
    Numero distanciaHastaAlmacen(@etiqueta(" hasta el almacén ") IAlmacen almacen);

    @ignorar
    IObjeto sacar();
}
