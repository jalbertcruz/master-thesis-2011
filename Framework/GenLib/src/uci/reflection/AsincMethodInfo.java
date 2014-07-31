package uci.reflection;

import java.lang.reflect.Method;

public class AsincMethodInfo extends MethodInfo {

    boolean valorAsincronico;

    public boolean getIsValorAsincronico() {
        return valorAsincronico;
    }

    public String getReturnType() {
        return mth.getReturnType().getName();
    }

    public boolean getIsQuery() {
        return !mth.getReturnType().equals(void.class);
    }

    public AsincMethodInfo(Method mth, boolean valorAsincronico) {
        super(mth);
        asincronico = true;
        this.valorAsincronico = valorAsincronico;
    }

}
