package lang.ui.base;
import ide.utilidades.IBuilder;

public abstract class BloqueArrastrable extends Bloque, Arrastrable, IBuilder {

    override var children = bind [
                hijos, marca
            ];
}
