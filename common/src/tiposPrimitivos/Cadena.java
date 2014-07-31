package tiposPrimitivos;

import anotaciones.*;
import java.io.Serializable;
import tiposPrimitivos.impl.CadenaImpl;

@literal("lang.ui.literales.LiteralCadena")
@implementacion(CadenaImpl.class)
@plural("Cadenas")
public interface Cadena extends Serializable{

    @objeto("")
    Cadena subcadena(Numero pi, Numero pf);

    @objeto("")
    Logico tiene(@etiqueta(" la subcadena: ") Cadena cad);
}
