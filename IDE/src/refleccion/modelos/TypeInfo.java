package refleccion.modelos;

import anotaciones.ignorar;
import java.lang.reflect.Method;

public class TypeInfo {

    public static boolean isIncluded(Method mth){
        return mth.getAnnotation(ignorar.class) == null;
    }

    Class type;
    String literal;

    public String getLiteral() {
        return literal;
    }

    public void setLiteral(String literal) {
        this.literal = literal;
    }

    public Class getType() {
        return type;
    }

    public void setType(Class type) {
        this.type = type;
    }

    public TypeInfo(Class type, String literal) {
        this.type = type;
        this.literal = literal;
}
}
