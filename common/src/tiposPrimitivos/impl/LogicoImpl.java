package tiposPrimitivos.impl;

import tiposPrimitivos.Logico;

public class LogicoImpl implements Logico {

    private Boolean val;

    public LogicoImpl(Boolean val) {
        this.val = val;
    }

    public LogicoImpl(String val) {
        this.val = val.equals("verdadero");
    }

    @Override
    public Logico conjuncion(Logico p) {
        return new LogicoImpl(val && p.valor());
    }

    @Override
    public Logico disyuncion(Logico p) {
        return new LogicoImpl(val || p.valor());
    }

    @Override
    public Logico negacion() {
        return new LogicoImpl(!val);
    }

    @Override
    public Boolean valor() {
        return val;
    }
}
