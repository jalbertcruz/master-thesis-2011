package ast;

import java.util.ArrayList;

public class HSentencia extends Hueco {

    private ArrayList<Rama> ramas;

    @Override
    public ArrayList<Rama> getRamas() {
        return ramas;
    }

    public void setRamas(ArrayList<Rama> ramas) {
        this.ramas = ramas;
    }

    /**
     * Constructor que pone como tipo void y construye la lista para las ramas a poner.
     *
     * Se deben poner las ramas
     */
    public HSentencia() {
        super("void");
        ramas = new ArrayList<Rama>();
    }

    @Override
    protected boolean opcional() {
        return true;
    }

    @Override
    public boolean estaLleno() {
        return true;
    }
}
