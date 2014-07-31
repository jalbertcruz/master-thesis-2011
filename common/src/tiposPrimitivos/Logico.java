package tiposPrimitivos;

import anotaciones.*;
import java.io.Serializable;
import tiposPrimitivos.impl.LogicoImpl;

@nombre("Lógico")
@plural("Lógicos")
@implementacion(LogicoImpl.class)
public interface Logico extends Serializable {

    @ignorar
    Boolean valor();

    @objeto("")
    Logico conjuncion(@etiqueta(" Y ") Logico p);

    @objeto("")
    Logico disyuncion(@etiqueta(" O ") Logico p);

    @objeto("No ")
    Logico negacion();
}
