
package refleccion;

public class EtiquetasSiEntoncesSino {

    String antesDeCondicion;
    String despuesDeCondicion;
    String sino;

    public String getSino() {
        return sino;
    }

    public void setSino(String sino) {
        this.sino = sino;
    }

    public String getAntesDeCondicion() {
        return antesDeCondicion;
    }

    public void setAntesDeCondicion(String antesDeCondicion) {
        this.antesDeCondicion = antesDeCondicion;
    }

    public String getDespuesDeCondicion() {
        return despuesDeCondicion;
    }

    public void setDespuesDeCondicion(String despuesDeCondicion) {
        this.despuesDeCondicion = despuesDeCondicion;
    }

    @Override
    public String toString() {
        return "EtiquetasSiEntonces{" + "antesDeCondicion=" + antesDeCondicion + ", despuesDeCondicion=" + despuesDeCondicion + '}';
    }

    public EtiquetasSiEntoncesSino() {
    }

    
}
