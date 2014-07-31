package uci.st.entities;

public class ProxyServerInfo extends ProxyClientInfo {

    public ProxyServerInfo(Class pInterface) {
        super(pInterface);
    }

    public String getImplementerType() {
        return getPackage() + "." + cls.getSimpleName();
    }
}
