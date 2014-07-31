package uci.reflection;

import java.lang.reflect.Method;

public class MethodInfo {

    protected Method mth;
    protected MethodParameterInfo[] parameters;
    protected boolean asincronico;

    public boolean getIsAsincronico() {
        return asincronico;
    }

    public MethodInfo(Method mth) {
        asincronico = false;
        this.mth = mth;
        Class[] types = mth.getParameterTypes();
        parameters = new MethodParameterInfo[types.length];
        for (int i = 0; i < types.length; i++) {
            parameters[i] = new MethodParameterInfo("p" + i, types[i]);
        }
    }

    public String getName() {
        return mth.getName();
    }

    public MethodParameterInfo[] getParametersInfo() {
        return parameters;
    }

    public MethodParameterInfo getFirstParameterInfo() {
        return parameters[0];
    }

    public String getReturnTypeName() {
        return mth.getReturnType().getName();
    }

    public boolean getIsProcedure() {
        return getReturnTypeName().equalsIgnoreCase("void");
    }

    public boolean getHasNoParameters() {
        return parameters.length < 1;
    }

    public boolean getHasOneParameter() {
        return parameters.length == 1;
    }

    public boolean getHasMoreThanOneParameters() {
        return parameters.length > 1;
    }
}
