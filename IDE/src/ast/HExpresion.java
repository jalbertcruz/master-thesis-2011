package ast;

import java.util.ArrayList;

public class HExpresion extends Hueco {

    private Rama rama;

    public Rama getRama() {
        return rama;
    }

    public void setRama(Rama rama) {
        this.rama = rama;
    }

    public HExpresion(String tipo) {
        super(tipo);
        rama = null;
    }

    public HExpresion(String tipo, Rama rama) {
        super(tipo);
        this.rama = rama;
    }

    @Override
    protected boolean opcional() {
        return false;
    }

    @Override
    public boolean estaLleno() {
        return rama != null;
    }

    @Override
    public ArrayList<Rama> getRamas() {
        ArrayList<Rama> result = new ArrayList<Rama>();
        result.add(rama);
        return result;
    }
}
