package lang.ui.base;

import lang.ui.control.common.CaparazonParaUnBloqueDeInstrucciones;
import lang.model.Variable;

abstract public class Rutina extends CaparazonParaUnBloqueDeInstrucciones {

    public var esExpresion: Boolean = false;

    abstract public function compilar(ts: ast.TablaDeSimbolos): Void;

    abstract public function getVariablesLocales(): Variable[];
    abstract public function getParametrosFormales(): Variable[];

//    public var variablesLocales: Variable[];
//    public var parametrosFormales: Variable[];
    public var bloquesConHuecos: Bloque[];
}
