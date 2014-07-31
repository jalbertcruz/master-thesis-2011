
package interfaces;

import anotaciones.*;
import tiposPrimitivos.*;

@nombre("Televisor")
@plural("Televisores")
public interface TV {

    @objeto(" El TV ")
    Logico tieneSennal(@etiqueta(" tiene señal en el canal ") Numero canal);

    @objeto(" El TV ")
    @sufijo(" está encendido")
    Logico encendido();

    @objeto(" El TV ")
    @sufijo(" no está encendido")
    Logico noEstaEncendido();

    @objeto(" Encender el televisor")
    void encender();

    @orden({1, 0})
    @objeto(" en el TV ")
    void ponerDVD(@etiqueta(" Poner el DVD ") ReproductorDVD dvd);

}
