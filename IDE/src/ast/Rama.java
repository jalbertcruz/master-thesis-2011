package ast;

import java.util.ArrayList;
import java.util.Iterator;

public class Rama {

    public abstract class ReglaSemantica {

        TablaDeSimbolos tds;

        public ReglaSemantica(TablaDeSimbolos tds) {
            this.tds = tds;
        }

        public abstract boolean seCumple();
    }

    public class ReglaDeclaracionVariable extends ReglaSemantica {

        public ReglaDeclaracionVariable(TablaDeSimbolos tds) {
            super(tds);
        }

        @Override
        public boolean seCumple() {
            return true;
        }
    }

    public class ReglaAsignacion extends ReglaSemantica {

        public ReglaAsignacion(TablaDeSimbolos tds) {
            super(tds);
        }

        /**
         * Se cumple la compatibilidad de tipos entre la expresion y la variable
         * @return
         */
        @Override
        public boolean seCumple() {
            Rama var = huecos.get(0).getRamas().get(0);
            Rama exp = huecos.get(1).getRamas().get(0);

            System.out.println(var.tipo.equals(exp.tipo));

            return var.tipo.equals(exp.tipo);
        }
    }

    public ReglaSemantica mkReglaExpresion(TablaDeSimbolos tds) {
        return new ReglaExpresion(tds);
    }

    public ReglaSemantica mkReglaDeclaracionVariable(TablaDeSimbolos tds) {
        return new ReglaDeclaracionVariable(tds);
    }

    public ReglaSemantica mkReglaAsignacion(TablaDeSimbolos tds) {
        return new ReglaAsignacion(tds);
    }

    public class ReglaExpresion extends ReglaSemantica {

        public ReglaExpresion(TablaDeSimbolos tds) {
            super(tds);
        }

        @Override
        public boolean seCumple() {
            boolean compatible = true;
            for (Iterator<Hueco> it = huecos.iterator(); it.hasNext() && compatible;) {
                Hueco hueco = it.next();
                if (!hueco.opcional()) {
                    if (!hueco.tipo.equals(hueco.getRamas().get(0).tipo)) {
                        compatible = false;
                    }
                }
            }
            return compatible;
        }
    }
    protected String tipo;
    protected ArrayList<Hueco> huecos;
    protected ReglaSemantica reglaSemantica;

    public ReglaSemantica getReglaSemantica() {
        return reglaSemantica;
    }

    public void setReglaSemantica(ReglaSemantica reglaSemantica) {
        this.reglaSemantica = reglaSemantica;
    }

    public ArrayList<Hueco> getHuecos() {
        return huecos;
    }

    public void setHuecos(ArrayList<Hueco> huecos) {
        this.huecos = huecos;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public boolean ejecutable() {
        // todos los huecos estan llenos
        boolean llenos = true;
        ArrayList<Rama> hijos = new ArrayList<Rama>();
        for (Iterator<Hueco> it = huecos.iterator(); it.hasNext() && llenos;) {
            Hueco hueco = it.next();
            if (!hueco.estaLleno()) {
                if (!hueco.opcional()) {
                    llenos = false;
                }
            } else {
                hijos.addAll(hueco.getRamas());
            }
        }
        boolean hEjecutables = true;
        if (llenos) {
            // todos los hijos son ejecutables
            for (Iterator<Rama> it = hijos.iterator(); it.hasNext() && hEjecutables;) {
                Rama rama = it.next();
                if (!rama.ejecutable()) {
                    hEjecutables = false;
                }
            }
        }
//        System.out.println("llenos: " + llenos + ",  hEjecutables: " + hEjecutables);
        return llenos && hEjecutables && reglaSemantica.seCumple();
    }

    public Rama(String tipo) {
        this.tipo = tipo;
        huecos = new ArrayList<Hueco>();
    }

    
}
