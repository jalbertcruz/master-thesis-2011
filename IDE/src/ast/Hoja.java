package ast;

import java.util.ArrayList;

public class Hoja extends Rama {

    public Hoja(String tipo, boolean bienFormada) {
        super(tipo);
        this.bienFormada = bienFormada;
    }

    protected boolean bienFormada;

    public boolean isBienFormada() {
        return bienFormada;
    }

    public void setBienFormada(boolean bienFormada) {
        this.bienFormada = bienFormada;
    }

    @Override
    public boolean ejecutable() {
        return bienFormada;
    }

    @Override
    public ArrayList<Hueco> getHuecos() {
        return new ArrayList<Hueco>();
    }
}
