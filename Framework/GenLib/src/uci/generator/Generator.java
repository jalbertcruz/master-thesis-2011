package uci.generator;

import org.antlr.stringtemplate.StringTemplate;
import org.antlr.stringtemplate.StringTemplateGroup;
import uci.st.entities.ProxyClientInfo;
import uci.st.entities.ProxyServerInfo;

import java.io.*;

public class Generator {

    StringTemplateGroup group;
    StringTemplate st;

    public Generator() {
        group = new StringTemplateGroup(
                new InputStreamReader(
                        this.getClass().getResourceAsStream("/templates/scalaErlang.stg")));
    }

    public void generateClientProxies(String targetPath, Class cls) throws IOException {
        ProxyClientInfo clientModel = new ProxyClientInfo(cls);
        File newPath = new File(targetPath + clientModel.getPackage().replace('.', '/') + "/");
        newPath.mkdirs();

        st = group.getInstanceOf("scalaClientSrc");
        st.setAttribute("model", clientModel);

        FileWriter fw = new FileWriter(new File(newPath, clientModel.getName() + "ProxyClientFactory.scala"));
        PrintWriter salida = new PrintWriter(fw);
        salida.println(st.toString());
        salida.close();
    }

    public void generateServerProxies(String targetPath, Class pInterface) throws IOException {
        ProxyServerInfo serverModel = new ProxyServerInfo(pInterface);
        File newPath = new File(targetPath + serverModel.getPackage().replace('.', '/') + "/");
        newPath.mkdirs();

        st = group.getInstanceOf("scalaServerSrc");
        st.setAttribute("model", serverModel);

        FileWriter fw = new FileWriter(new File(newPath, serverModel.getName() + "ProxyServerFactory.scala"));
        PrintWriter salida = new PrintWriter(fw);
        salida.println(st.toString());
        salida.close();
    }

    public void generateInterfaces(String targetPath, Class pInterface) throws IOException {
        ProxyServerInfo serverModel = new ProxyServerInfo(pInterface);
        File newPath = new File(targetPath + serverModel.getPackage().replace('.', '/') + "/");

        st = group.getInstanceOf("childInterface");
        st.setAttribute("model", serverModel);

        FileWriter fw = new FileWriter(new File(newPath, serverModel.getName() + ".java"));
        PrintWriter salida = new PrintWriter(fw);
        salida.println(st.toString());
        salida.close();

        st = group.getInstanceOf("doneInterface");
        st.setAttribute("model", serverModel);

        fw = new FileWriter(new File(newPath, serverModel.getName() + "Done.java"));
        salida = new PrintWriter(fw);
        salida.println(st.toString());
        salida.close();

    }

    public void generateErlangServer(String targetPath, Class cls) throws IOException {
        ProxyClientInfo clientModel = new ProxyClientInfo(cls);
        st = group.getInstanceOf("erlangChannelSrc");
        st.setAttribute("model", clientModel);

        String fname = cls.getSimpleName().substring(0, 1).toLowerCase() + cls.getSimpleName().substring(1) + "Channel.erl";
        FileWriter fw = new FileWriter(new File(targetPath, fname));
        PrintWriter salida = new PrintWriter(fw);
        salida.println(st.toString());
        salida.close();
    }
}
