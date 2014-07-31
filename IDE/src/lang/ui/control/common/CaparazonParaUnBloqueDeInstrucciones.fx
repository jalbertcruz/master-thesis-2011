package lang.ui.control.common;

import lang.ui.base.Bloque;

public abstract class CaparazonParaUnBloqueDeInstrucciones extends CaparazonParaBloqueDeInstrucciones {

    public var cuerpo: Bloque;
    public override var hijos = bind [
                poligono,
                encabezado,
                cuerpo
            ];
}