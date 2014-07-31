package tiposPrimitivos;

import anotaciones.*;
import java.io.Serializable;
import tiposPrimitivos.impl.NumeroImpl;

@nombre("Número")
@plural("Números")
@literal("lang.ui.literales.LiteralNumero")
@implementacion(NumeroImpl.class)
public interface Numero extends Serializable {

    @ignorar
    Double valor();

    @objeto("")
    Numero sumar(@etiqueta(" + ") Numero obj);

    @objeto("")
    Numero restar(@etiqueta(" - ") Numero obj);

    @objeto("")
    Numero dividir(@etiqueta(" / ") Numero obj);

    @objeto("")
    Numero multiplicar(@etiqueta(" * ") Numero obj);

    @objeto("raíz cuadrada de ")
    Numero raiz_cuadrada();

    @objeto("logaritmo natural de ")
    Numero logN();

    @objeto("valor absoluto de ")
    Numero valor_absoluto();

    @objeto("opuesto de ")
    Numero opuesto();

    @objeto("elevar ")
    Numero potencia(@etiqueta(" al exponente ") Numero exponente);

    @objeto("")
    Logico mayor_que(@etiqueta("  es mayor que ") Numero otro);

    @objeto("")
    Logico menor_que(@etiqueta(" menor que ") Numero otro);

    @objeto("")
    Logico menor_igual(@etiqueta(" menor igual que ") Numero otro);

    @objeto("")
    Logico igual_a(@etiqueta(" igual a") Numero otro);

    @objeto("")
    Logico mayor_igual(@etiqueta(" mayor igual que ") Numero otro);
}
