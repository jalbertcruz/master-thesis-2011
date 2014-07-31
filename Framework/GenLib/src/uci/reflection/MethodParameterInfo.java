package uci.reflection;

public class MethodParameterInfo {

    private String name;
    private Class type;

//   public static Class toSclType(Class type) {
//        //TODO: Completar los tipos wrappers...
//        Class[] primitives = {char.class,     boolean.class,       int.class,       double.class,       short.class};
//        Class[] wrappers = {scala.Char.class, scala.Boolean.class, scala.Int.class, scala.Double.class, scala.Short.class};
//        for (int i = 0; i < primitives.length; i++) {
//            if (type.equals(primitives[i])) {
//                return wrappers[i];
//            }
//        }
//        return type;
//    }

    public MethodParameterInfo(String name, Class type) {
        this.name = name;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public Class getType() {
        return type;
    }
}
