package refleccion.modelos;

import anotaciones.etiqueta;
import anotaciones.nombre;
import anotaciones.plural;
import anotaciones.sufijo;
import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import rutinas.TipoRutina;

public class ModeloEjecucionDeMetodoJava implements Serializable {

    private String nombre;
    private String sufijo;
    private ParamInfoJava[] informacionParametros;
    private TipoRutina tipoRutina;
    private Class tipo;

    public Class getTipo() {
        return tipo;
    }

    public void setTipo(Class tipo) {
        this.tipo = tipo;
    }

    private static String eliminar_(String name) {
        return name.replace('_', ' ');
    }

    public static ModeloEjecucionDeMetodoJava crearModeloDesdeMetodo(Method mth, Class cls) throws Exception {

        TipoRutina tipoRutina = TipoRutina.Orden;
        Class t = mth.getReturnType();
        if (!t.equals(void.class)) {
            tipoRutina = TipoRutina.Consulta;
        }
        // buscar el nombre y el sufijo, de no estar se coge el nombre del metodo y "" respectivamente.
        anotaciones.objeto targetObj = mth.getAnnotation(anotaciones.objeto.class);
        if (targetObj == null) {
            throw new Exception("No se ha espcificado la etiqueta a usar para indicar el lugar del objeto en el metodo.");
        }
        String etiquetaDelObjeto = targetObj.value();
        anotaciones.nombre n = (nombre) cls.getAnnotation(anotaciones.nombre.class);
        String nombreClase = (n == null) ? eliminar_(cls.getSimpleName()) : n.value();
        sufijo s = mth.getAnnotation(sufijo.class);
        String suf = (s == null) ? "" : s.value();
        // arreglo para montar las expresiones y sus comentarios, siempre +1 porque el objeto será el primer parametro
        ParamInfoJava[] infPmts = new ParamInfoJava[mth.getParameterTypes().length + 1];

        infPmts[0] =
                new ParamInfoJava(
                "Objeto " + nombreClase + " sobre el que se desarrollará la acción",
                etiquetaDelObjeto, cls);

        // cada parametro o tiene un @comm o no tiene nada
        Annotation[][] at = mth.getParameterAnnotations();

        if (mth.getParameterTypes().length > 0) { // si hay parametros...
            // decido si pongo o no "con:" para la visualizacion de los parametros
            infPmts[1] = (at[0].length != 0)
                    ? new ParamInfoJava("Parámetro: expresión de tipo " + mth.getParameterTypes()[0].getSimpleName(), ((etiqueta) at[0][0]).value(), mth.getParameterTypes()[0])
                    : new ParamInfoJava("Parámetro: expresión de tipo " + mth.getParameterTypes()[0].getSimpleName(), etiquetaDelObjeto + " con: ", mth.getParameterTypes()[0]);

            for (int i = 2; i <= mth.getParameterTypes().length; i++) {

                n = (nombre) mth.getParameterTypes()[i - 1].getAnnotation(anotaciones.nombre.class);
                String nombreTipoParam = (n == null) ? eliminar_(mth.getParameterTypes()[i - 1].getSimpleName()) : n.value();

                infPmts[i] = (at[i - 1].length != 0)
                        ? new ParamInfoJava(
                        "Parámetro: expresión de tipo " + nombreTipoParam,
                        ((etiqueta) at[i - 1][0]).value(),
                        mth.getParameterTypes()[i - 1])
                        : new ParamInfoJava(
                        "Parámetro: expresión de tipo " + nombreTipoParam,
                        ", ",
                        mth.getParameterTypes()[i - 1]);
            }
        }

        anotaciones.orden ord = mth.getAnnotation(anotaciones.orden.class);
        if (ord != null) {
            int[] vs = ord.value();
            if (vs.length != infPmts.length) {
                throw new Exception("El método \"" + mth.getName() + "\" ha sido marcado con un @orden de tamaño incorrecto.");
            }
            ParamInfoJava[] _infPmts = new ParamInfoJava[infPmts.length];
            for (int i = 0; i < vs.length; i++) {
                int j = vs[i];
                _infPmts[i] = infPmts[j];
            }
            infPmts = _infPmts;
        }
        return new ModeloEjecucionDeMetodoJava(mth.getName(), suf, infPmts, tipoRutina, t);
    }

    public static String getPlural(Class cls) {
        anotaciones.plural p = (plural) cls.getAnnotation(anotaciones.plural.class);
        return p != null ? p.value() : cls.getSimpleName();
    }

    public static String getNombre(Class cls) {
        anotaciones.nombre p = (nombre) cls.getAnnotation(anotaciones.nombre.class);
        return p != null ? p.value() : cls.getSimpleName();
    }

//    public static ModeloEjecucionDeMetodoJava crearModeloDesdeMetodo(Method mth, Class cls) {
//
//        TipoRutina tipoRutina = TipoRutina.Orden;
//        Class t = mth.getReturnType();
//        if (!t.equals(void.class)) {
//            tipoRutina = TipoRutina.Consulta;
//        }
//        // buscar el nombre y el sufijo, de no estar se coge el nombre del metodo y "" respectivamente.
//        anotaciones.nombre n = mth.getAnnotation(anotaciones.nombre.class);
//        String nom = (n == null) ? eliminar_(mth.getName()) : n.value();
//        n = (nombre) cls.getAnnotation(anotaciones.nombre.class);
//        String nombreClase = (n == null) ? eliminar_(cls.getSimpleName()) : n.value();
//        sufijo s = mth.getAnnotation(sufijo.class);
//        String suf = (s == null) ? "" : s.value();
//
//        // arreglo para montar las expresiones y sus comentarios, siempre +1 porque el objeto ser� el primer parametro
//        ParamInfoJava[] infPmts = new ParamInfoJava[mth.getParameterTypes().length + 1];
//        encabezado enc = (encabezado) cls.getAnnotation(encabezado.class);
//        preposicion prep = (preposicion) mth.getAnnotation(preposicion.class);
//        String encStr = (enc == null) ? "" : enc.value();
//        // logica para armar el inicio (1er parametro) de las expresiones, dependera de
//        // la existencia de preposicion en primer lugar y luego del encabezado.
//        String commObj = (prep == null) ? encStr : nom + " " + prep.value() + " " + encStr;
//        infPmts[0] =
//                new ParamInfoJava(
//                "Objeto " + nombreClase + " sobre el que se desarrollará la acción",
//                commObj, cls);
//
//        // cada parametro o tiene un @comm o no tiene nada
//        Annotation[][] at = mth.getParameterAnnotations();
//
//        if (mth.getParameterTypes().length > 0) { // si hay parametros...
//            // decido si pongo o no "con:" para la visualizacion de los parametros
//            infPmts[1] = (at[0].length != 0)
//                    ? new ParamInfoJava("Parámetro: expresión de tipo " + mth.getParameterTypes()[0].getSimpleName(), nom + ((comm) at[0][0]).value(), mth.getParameterTypes()[0])
//                    : new ParamInfoJava("Parámetro: expresión de tipo " + mth.getParameterTypes()[0].getSimpleName(), nom + " con: ", mth.getParameterTypes()[0]);
//
//            for (int i = 2; i <= mth.getParameterTypes().length; i++) {
//
//                n = (nombre) mth.getParameterTypes()[i - 1].getAnnotation(anotaciones.nombre.class);
//                String nombreTipoParam = (n == null) ? eliminar_(mth.getParameterTypes()[i - 1].getSimpleName()) : n.value();
//
//                infPmts[i] = (at[i - 1].length != 0)
//                        ? new ParamInfoJava(
//                        "Parámetro: expresión de tipo " + nombreTipoParam,
//                        ((comm) at[i - 1][0]).value(),
//                        mth.getParameterTypes()[i - 1])
//                        : new ParamInfoJava(
//                        "Parámetro: expresión de tipo " + nombreTipoParam,
//                        ", ",
//                        mth.getParameterTypes()[i - 1]);
//            }
//        }
//        return new ModeloEjecucionDeMetodoJava(mth.getName(), suf, infPmts, tipoRutina, t);
//    }
    public ModeloEjecucionDeMetodoJava(
            String nombre, String sufijo, ParamInfoJava[] informacionParametros, TipoRutina tipoRutina, Class tipo) {
        this.nombre = nombre;
        this.sufijo = sufijo;
        this.informacionParametros = informacionParametros;
        this.tipoRutina = tipoRutina;
        this.tipo = tipo;
    }

    public String getSufijo() {
        return sufijo;
    }

    @Override
    public String toString() {
        String infParams = "";
        for (ParamInfoJava p : informacionParametros) {
            infParams += p.toString();
        }
        return "ModeloRutinaJava{" + "nombre=" + nombre + ", sufijo=" + sufijo + ", informacionParametros=" + infParams + ", tipoRutina=" + tipoRutina + '}';
    }

    public void setSufijo(String sufijo) {
        this.sufijo = sufijo;
    }

    public ParamInfoJava[] getInformacionParametros() {
        return informacionParametros;
    }

    public void setInformacionParametros(ParamInfoJava[] informacionParametros) {
        this.informacionParametros = informacionParametros;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public TipoRutina getTipoRutina() {
        return tipoRutina;
    }

    public void setTipoRutina(TipoRutina tipoRutina) {
        this.tipoRutina = tipoRutina;
    }
}
