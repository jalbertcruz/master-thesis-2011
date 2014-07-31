package uci;

import anotaciones.*;
import tiposPrimitivos.Numero;

@proxy
@nombre("Almacen")
@plural("Almacenes")
public interface IAlmacen extends ILugar {

    @objeto(" Cantidad de productos que tiene el almacén ")
    @sufijo(" en estos momentos")
    Numero cantidadProductos();

    @ignorar
    IObjeto sacar();

    @ignorar
    void poner(IObjeto objeto);
}
