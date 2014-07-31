package ast;

import java.util.ArrayList;

public abstract class Hueco {

    protected abstract boolean opcional();

    public abstract boolean estaLleno();
    /**
     * Tipo del parámetro que va en este Hueco
     */
    protected String tipo;

    public Hueco(String tipo) {
        this.tipo = tipo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public abstract ArrayList<Rama> getRamas();
}
