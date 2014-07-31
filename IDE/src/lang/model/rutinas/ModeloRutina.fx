package lang.model.rutinas;

import java.lang.reflect.Method;
import java.lang.Class;
import rutinas.TipoRutina;
import refleccion.modelos.ModeloEjecucionDeMetodoJava;
import refleccion.modelos.TypeInfo;

public class ModeloRutina {

    public var tipoRutina: TipoRutina = TipoRutina.Consulta;
    public var nombre: String;
    public var sufijo: String;
    public var tipoDevolucion: Class;
    public var informacionParametros: ParamInfo[];

    public function crearModeloDesdeMetodo(mth: Method, cls: Class): ModeloRutina {

        def res: ModeloEjecucionDeMetodoJava = ModeloEjecucionDeMetodoJava.crearModeloDesdeMetodo(mth, cls);

        ModeloRutina {
            tipoRutina: res.getTipoRutina()
            nombre: res.getNombre()
            sufijo: res.getSufijo()
            tipoDevolucion: res.getTipo()
            informacionParametros: for (i in [0..sizeof res.getInformacionParametros() - 1])
                ParamInfo {
                    comentario: res.getInformacionParametros()[i].getComentario()
                    tipo: res.getInformacionParametros()[i].getTipo()
                    descripcion: res.getInformacionParametros()[i].getDescripcion()
                }
        }
        
    }

    public function crearModelosDesdeInterfaz(cls: Class): ModeloRutina[] {
        for (mth in cls.getMethods() where TypeInfo.isIncluded(mth))
            crearModeloDesdeMetodo(mth, cls)
    }

}
