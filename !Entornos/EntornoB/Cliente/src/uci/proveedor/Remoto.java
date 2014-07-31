package uci.proveedor;

import contratos.DatosRemotos;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import scala.erlang.server.Node;
import uci.entidades.ParObjetoRemoto;

import uci.erlProxyGen.ProxyClientsFactory;

public class Remoto implements DatosRemotos {

    Properties props;
    List<ParObjetoRemoto> objetos;

    public Remoto(Properties props) {

        this.props = props;

        Node node = new Node(props.getProperty("nombreDelCliente") + "@" + props.getProperty("ip"), "coo");

        ProxyClientsFactory pcf = new ProxyClientsFactory(node, "nChannel" + "@" + props.getProperty("enrutador"));

        objetos = pcf.clientsTuples();

    }

    public List<ParObjetoRemoto> objetosDisponibles() {
        return objetos;
    }

    public ArrayList<Class> tiposExportados(){

        ArrayList<Class>  res = new ArrayList<Class>();

        res.add(uci.IRobot.class);
        res.add(uci.IAlmacen.class);
        res.add(uci.IFabrica.class);
        
        return res;
    }
}
