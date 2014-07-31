package uci;

import anotaciones.*;
import tiposPrimitivos.Numero;

@nombre("Ventilador")
@plural("Ventiladores")
public interface IVentilador {

    @retornoAsincrono
    @valorAsincronico
    @objeto(" veces de ")
    Numero veces();

    @retornoAsincrono
    @sufijo(" a dar una vuelta")
    @objeto(" Poner el ventilador ")
    void darUnaVuelta();

    @retornoAsincrono
    @sufijo(" vueltas")
    @objeto(" Poner el ventilador ")
    void darNVueltas(@etiqueta(" a dar: ") Numero cant);

    @objeto(" Cambiar el sentido del ventilador: ")
    void cambiarSentido();
}
