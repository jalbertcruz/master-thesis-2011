package uci.entidades;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class CosasJRuby {

    ScriptEngineManager m;
    ScriptEngine engine;
    ScriptContext context;

    public CosasJRuby() {
        m = new ScriptEngineManager();
        engine = m.getEngineByName("jruby");
        context = engine.getContext();
    }

    public ScriptContext getContext() {
        return context;
    }

    public ScriptEngine getEngine() {
        return engine;
    }
}
