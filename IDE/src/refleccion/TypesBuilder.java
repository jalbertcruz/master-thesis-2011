package refleccion;

import anotaciones.literal;
import contratos.DatosRemotos;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.script.ScriptContext;
import javax.script.ScriptException;
import refleccion.modelos.TypeInfo;
import uci.entidades.CosasJRuby;
import uci.entidades.ParObjetoRemoto;

/**
 * Clase encargada de hacer la integración con el servidor y las demás tecnologías
 * @author jalbert
 */
public class TypesBuilder {

    private Properties prop;
    private CosasJRuby jruby;
//

    /**
     *  Metodo Mock
     * @return
     */
//    public List<ParObjetoRemoto> objetosDisponibles(){
//        List<ParObjetoRemoto> list = new ArrayList<ParObjetoRemoto>();
//        IFabrica fabrica = new IFabrica() {
//
//            @Override
//            public Numero cantidadProductos() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public IObjeto sacar() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero distanciaHastaAlmacen(IAlmacen almacen) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero valorDeX() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero valorDeY() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//        };
//        IRobot robot = new IRobot() {
//
//            @Override
//            public void moverHastaFabrica(IFabrica fabrica) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public void moverHastaAlmacen(IAlmacen almacen) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public void cogerObjeto(IFabrica fabrica) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public void entregarObjeto(IAlmacen almacen) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero distanciaHastaFabrica(IFabrica fabrica) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero distanciaHastaAlmacen(IAlmacen almacen) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//        };
//        IAlmacen almacen = new IAlmacen() {
//
//            @Override
//            public Numero cantidadProductos() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public IObjeto sacar() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public void poner(IObjeto objeto) {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero valorDeX() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//
//            @Override
//            public Numero valorDeY() {
//                throw new UnsupportedOperationException("Not supported yet.");
//            }
//        };
//        list.add(new ParObjetoRemoto("fab1", fabrica));
//        list.add(new ParObjetoRemoto("fab2", fabrica));
//        list.add(new ParObjetoRemoto("fab3", fabrica));
//        list.add(new ParObjetoRemoto("robot", robot));
//        list.add(new ParObjetoRemoto("almacen", almacen));
//        return list;
//    }

    public List<ParObjetoRemoto> objetosDisponibles(){
        return datosRemotos.objetosDisponibles();
    }

    DatosRemotos datosRemotos;
    String reqs;

    public TypesBuilder() throws Exception {

        prop = new Properties();

        FileInputStream input = new FileInputStream("./configuracion/configuracion.properties");
        prop.load(input);
        input.close();

        jruby = new CosasJRuby();

        reqs = " require 'java'";

        File jarsLocation = new File("Entorno" + prop.getProperty("entornoActivo"));

        File[] files = jarsLocation.listFiles();
        for (int i = 0; i < files.length; i++) {
            File f1 = files[i];
            if (f1.isFile() && f1.getName().endsWith(".jar")) {
                reqs += "\n\r require '" + f1.getAbsolutePath() + "'";
            }
        }

        jruby.getContext().setAttribute("ja_param", prop, ScriptContext.ENGINE_SCOPE);

        jruby.getEngine().eval(reqs + "\n\r java_import 'uci.proveedor.Remoto' \n\r $resultado = Remoto.new $ja_param");

        datosRemotos = (DatosRemotos) jruby.getContext().getAttribute("resultado");

        jruby.getContext().removeAttribute("ja_param", ScriptContext.ENGINE_SCOPE);
    }

    public void ejecuta(String src) throws ScriptException{
        String jimports = "";

        jimports += "\n\r java_import 'tiposPrimitivos.impl.NumeroImpl'";
        jimports += "\n\r java_import 'tiposPrimitivos.impl.LogicoImpl'";
        jimports += "\n\r java_import 'tiposPrimitivos.impl.CadenaImpl'";

        String variables = "";
        for (ParObjetoRemoto par : objetosDisponibles()) {
            jruby.getContext().removeAttribute(par.getNombre(), ScriptContext.ENGINE_SCOPE);
            jruby.getContext().setAttribute(par.getNombre(), par.getObjeto(), ScriptContext.ENGINE_SCOPE);
            variables += "\n\r " + par.getNombre() + " = " + "$" + par.getNombre();
        }

//        String trad = "\n\r puts \"primeras 3\"; vent.darNVueltas(3); puts \"la otra!\"; vent.cambiarSentido(); vent.darUnaVuelta(); puts \"veces: \"; puts vent.veces()";

        String codeToEvaluate = reqs + jimports + variables + src;

        System.out.println(codeToEvaluate);
        
        jruby.getEngine().eval(codeToEvaluate);
    }
    String getLiteral(Class cls) {
        literal l = (literal) cls.getAnnotation(literal.class);
        return (l != null) ? l.value() : "";
    }

    public ArrayList<TypeInfo> enviromentTypes() {

        ArrayList<TypeInfo> res = new ArrayList<TypeInfo>();

//        Class cls;

//        cls = interfaces.Robot.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));

//        cls = interfaces.Fabrica.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));

//        cls = interfaces.TV.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//
//        cls = interfaces.DVD.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//
//        cls = interfaces.ReproductorDVD.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//
//        cls = interfaces.IVentilador.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));

//        cls = uci.IRobot.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//
//        cls = uci.IAlmacen.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//
//        cls = uci.IFabrica.class;
//        res.add(new TypeInfo(cls, getLiteral(cls)));
//

        for(Class cls: datosRemotos.tiposExportados())
            res.add(new TypeInfo(cls, getLiteral(cls)));

        return res;
    }

    public ArrayList<TypeInfo> primitiveTypes() {
        ArrayList<TypeInfo> res = new ArrayList<TypeInfo>();

        Class cls = tiposPrimitivos.Cadena.class;
        res.add(new TypeInfo(cls, getLiteral(cls)));
        cls = tiposPrimitivos.Logico.class;
        res.add(new TypeInfo(cls, getLiteral(cls)));

        cls = tiposPrimitivos.Numero.class;
        res.add(new TypeInfo(cls, getLiteral(cls)));

        return res;
    }

    public ArrayList<TypeInfo> allTypes() {
        ArrayList<TypeInfo> res = new ArrayList<TypeInfo>(primitiveTypes());
        res.addAll(enviromentTypes());
        return res;
    }
}
