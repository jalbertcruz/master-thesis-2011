package uci.st.entities;

import uci.reflection.AsincMethodInfo;
import anotaciones.retornoAsincrono;
import anotaciones.valorAsincronico;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashSet;
import uci.reflection.MethodInfo;

public class ProxyClientInfo {

    protected Class cls;
    protected ArrayList<MethodInfo> methods;

    HashSet<Method> getAllMethods(Class cls) {
        HashSet<Method> res = new HashSet<Method>();
        for (Method m1 : cls.getDeclaredMethods()) {
            res.add(m1);
        }
        for (Class c : cls.getInterfaces()) {
            res.addAll(getAllMethods(c));
        }
        return res;
    }

    public ProxyClientInfo(Class cls) {
        if (!cls.isInterface()) {
            throw new RuntimeException("Solo son permitidas las interfaces.");
        }

        this.cls = cls;
        methods = new ArrayList<MethodInfo>();
        for (Method m : getAllMethods(cls)) {
            retornoAsincrono ret = m.getAnnotation(retornoAsincrono.class);

            if (ret == null) {
                methods.add(new MethodInfo(m));
            } else {
                valorAsincronico valorAsinc = m.getAnnotation(valorAsincronico.class);
                if (valorAsinc != null && (m.getReturnType().equals(void.class))) {
                    throw new RuntimeException("El metodo " + m.getName() + " tiene que ser de consulta");
                }

                methods.add(new AsincMethodInfo(m, valorAsinc != null));
            }

        }
    }

    public String getPackage() {
        return cls.getPackage().getName() + ".erlProxyGen";
    }

    public String getOriginalPackage() {
        return cls.getPackage().getName();
    }

    public ArrayList<MethodInfo> getMethods() {
        return methods;
    }

    public String getName() {
        return cls.getSimpleName();
    }

    public String getSName() {
        return cls.getSimpleName().substring(0, 1).toLowerCase() + cls.getSimpleName().substring(1);
    }

    public String getFullName() {
        return cls.getName();
    }
}
