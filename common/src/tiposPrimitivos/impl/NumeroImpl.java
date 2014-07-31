package tiposPrimitivos.impl;

import tiposPrimitivos.Logico;
import tiposPrimitivos.Numero;

public class NumeroImpl implements Numero {

    private Double valor;

    public NumeroImpl() {
    }

    public NumeroImpl(String n) {
        if (n.startsWith("."))
            n = "0" + n;
        if (n.endsWith("."))
            n = n + "0";
        valor = Double.parseDouble(n);
    }

    public NumeroImpl(Double valor) {
        this.valor = valor;
    }

    @Override
    public Numero sumar(Numero obj) {
        return new NumeroImpl(valor + obj.valor());
    }

    @Override
    public Numero restar(Numero obj) {
        return new NumeroImpl(valor - obj.valor());
    }

    @Override
    public Numero dividir(Numero obj) {
        return new NumeroImpl(valor / obj.valor());
    }

    @Override
    public Numero multiplicar(Numero obj) {
        return new NumeroImpl(valor * obj.valor());
    }

    @Override
    public Numero raiz_cuadrada() {
        return new NumeroImpl(Math.sqrt(valor));
    }

    @Override
    public Numero logN() {
        return new NumeroImpl(Math.log(valor));
    }

    @Override
    public Numero valor_absoluto() {
        return new NumeroImpl(Math.abs(valor));
    }

    @Override
    public Numero opuesto() {
        return new NumeroImpl(-valor);
    }

    @Override
    public Numero potencia(Numero exponente) {
        return new NumeroImpl(Math.pow(valor, exponente.valor()));
    }

    @Override
    public Logico mayor_que(Numero otro) {
        return new LogicoImpl(valor > otro.valor());
    }

    @Override
    public Logico menor_que(Numero otro) {
        return new LogicoImpl(valor < otro.valor());
    }

    @Override
    public Logico igual_a(Numero otro) {
        return new LogicoImpl(Math.abs(valor - otro.valor()) < 0.000001);

    }

    @Override
    public Double valor() {
        return valor;
    }

    @Override
    public Logico menor_igual(Numero otro) {
        return menor_que(otro).disyuncion(igual_a(otro));
    }

    @Override
    public Logico mayor_igual(Numero otro) {
        return mayor_igual(otro).disyuncion(igual_a(otro));
    }
}
