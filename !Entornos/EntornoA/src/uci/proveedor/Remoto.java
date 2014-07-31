package uci.proveedor;

import contratos.DatosRemotos;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import scala.erlang.server.Node;
import uci.IVentilador;
import uci.entidades.ParObjetoRemoto;
import uci.erlProxyGen.IVentiladorProxyClientFactory;

public class Remoto implements DatosRemotos {

    Properties props;
    List<ParObjetoRemoto> objetos;

    public Remoto(Properties props) {

        this.props = props;

        objetos = new ArrayList<ParObjetoRemoto>();

        Node node = new Node(props.getProperty("nombreDelCliente") + "@" + props.getProperty("ip"), "coo");

        IVentiladorProxyClientFactory factory = 
		new uci.erlProxyGen.IVentiladorProxyClientFactory(
				node,
				"channel", 
				"nChannel@" + props.getProperty("ip"), 
				"factoryClient"
			);

        IVentilador v = factory.newObject();

        objetos.add(new ParObjetoRemoto("vent", v));

    }

    public List<ParObjetoRemoto> objetosDisponibles() {
        return objetos;
    }

    public ArrayList<Class> tiposExportados(){

        ArrayList<Class>  res = new ArrayList<Class>();

        res.add(IVentilador.class);
        
        return res;
    }
}
