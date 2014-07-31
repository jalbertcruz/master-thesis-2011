package contratos;

import java.util.ArrayList;
import java.util.List;
import uci.entidades.ParObjetoRemoto;

public interface DatosRemotos {

    List<ParObjetoRemoto> objetosDisponibles();

    ArrayList<Class> tiposExportados();

}
