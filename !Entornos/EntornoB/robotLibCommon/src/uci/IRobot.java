package uci;

import anotaciones.*;
import tiposPrimitivos.Numero;

@proxy
@nombre("Robot")
@plural("Robots")
public interface IRobot {

    @retornoAsincrono
    @objeto(" Mover el robot ")
    void moverHastaFabrica(@etiqueta(" hasta la fábrica ") IFabrica fabrica);

    @retornoAsincrono
    @objeto(" El robot ")
    void cogerObjeto(@etiqueta(" coge un objeto de la fábrica ") IFabrica fabrica);

    @retornoAsincrono
    @objeto(" El robot ")
    void entregarObjeto(@etiqueta(" entrega su objeto al almacén ") IAlmacen almacen);

    @retornoAsincrono
    @objeto(" Mover el robot ")
    void moverHastaAlmacen(@etiqueta(" hasta el almacén ") IAlmacen almacen);

    @objeto(" Distancia a la que está el robot ")
    Numero distanciaHastaFabrica(@etiqueta(" de la fábrica ") IFabrica fabrica);

    @objeto(" Distancia a la que está el robot ")
    Numero distanciaHastaAlmacen(@etiqueta(" del almacén ") IAlmacen almacen);
}
