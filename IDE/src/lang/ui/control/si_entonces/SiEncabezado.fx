package lang.ui.control.si_entonces;

import lang.ui.base.Bloque;
import lang.ui.base.huecos.Expresion;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import javafx.scene.Node;
import refleccion.EtiquetasSiEntoncesSino;
import com.google.gson.Gson;
import java.io.FileReader;

public class SiEncabezado extends Bloque {

    override public function actualizarPosiciones(): Void {
        ancho = cond.ancho + hb.boundsInParent.width;
        //alto = cond.alto + hb.boundsInParent.height;
        alto = cond.alto + 15;
    }

    init {

        def reader: FileReader = new FileReader("./configuracion/EtiquetasSiEntoncesSino.json");
        def gson: Gson = new Gson();
        def et: EtiquetasSiEntoncesSino = gson.fromJson(reader, EtiquetasSiEntoncesSino.class);
        reader.close();

        (mangos[0] as Text).content = et.getAntesDeCondicion();
        (mangos[1] as Text).content = et.getDespuesDeCondicion();

    }

    public-init var cond: Expresion;
    public def mangos: Node[] = [
                Text { content: "" }
                Text { content: "" }
            ];
    def hb = HBox {
                spacing: 3
                content: bind [
                    mangos[0],
                    cond,
                    mangos[1]
                ]
            };
    public override var hijos = bind hb;
//    public override def alto = bind cond.alto + hb.boundsInParent.height;
//    public override def ancho = bind cond.ancho + hb.boundsInParent.width;
}
