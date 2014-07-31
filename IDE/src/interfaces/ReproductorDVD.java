package interfaces;

import anotaciones.*;
import tiposPrimitivos.*;

@nombre("Reproductor de DVD")
@plural("Reproductores de DVD")
public interface ReproductorDVD {

    @objeto(" El DVD ")
    @sufijo(" no está encendido")
    Logico noEstaEncendido();

    @objeto(" Encender el televisor ")
    void encender();

    @objeto(" Reproducir el DVD ")
    void reproducir();

    @orden({1, 0})
    @objeto(" en el DVD ")
    void ponerDisco(@etiqueta(" Poner el disco") DVD dvd);
}
