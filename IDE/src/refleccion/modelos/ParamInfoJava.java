
package refleccion.modelos;

public class ParamInfoJava {

    private String descripcion;
    private String comentario;
    private Class tipo;

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public ParamInfoJava(String descripcion, String comentario, Class tipo) {
        this.descripcion = descripcion;
        this.comentario = comentario;
        this.tipo = tipo;
    }


    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public Class getTipo() {
        return tipo;
    }

    public void setTipo(Class tipo) {
        this.tipo = tipo;
    }

    @Override
    public String toString() {
        return "ParamInfoJava{" + "descripcion=" + descripcion + "comentario=" + comentario + "tipo=" + tipo + '}';
    }
}
