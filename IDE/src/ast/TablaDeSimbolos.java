package ast;

import java.util.Hashtable;

public class TablaDeSimbolos {

    Hashtable<String, String> ht;

    public TablaDeSimbolos() {
        ht = new Hashtable<String, String>();
    }

    public boolean existe(String id) {
        return ht.containsKey(id);
    }

    public void adicionar(String id, String tipo) {
        ht.put(id, tipo);
    }

    public String tipo(String id) {
        if (!existe(id)) {
            return "indefinido";
        }
        return ht.get(id);
    }
}
