package lang.ui.control.common;

import lang.ui.base.Bloque;
import javafx.util.Math;
import javafx.scene.layout.VBox;
import javafx.scene.shape.Line;
import ide.utilidades.ColoresIDE;
import refleccion.EtiquetasSiEntoncesSino;
import com.google.gson.Gson;
import java.io.FileReader;

public abstract class CaparazonParaDosBloquesDeInstrucciones extends CaparazonParaBloqueDeInstrucciones {

    public var cuerpo1: Bloque;
    public var cuerpo2: Bloque;
    init {

        def reader: FileReader = new FileReader("./configuracion/EtiquetasSiEntoncesSino.json");
        def gson: Gson = new Gson();
        def et: EtiquetasSiEntoncesSino = gson.fromJson(reader, EtiquetasSiEntoncesSino.class);
        reader.close();

        etiqueta.etiqueta = et.getSino();
    }
    def etiqueta = EtiquetaSegundoBloqueDeInstrucciones {
                ancho: bind Math.max(cuerpo1.ancho, cuerpo2.ancho)
                alto: bind grosor
                etiqueta: ""
            }
    protected def todoElcuerpo = VBox {
                layoutX: bind grosor
                layoutY: bind a
                content: [
                    cuerpo1,
                    etiqueta,
                    cuerpo2
                ]
            }
    def l = Line {
                fill: ColoresIDE.estructurasDeControl
                endY: bind grosor
                layoutX: bind todoElcuerpo.layoutX + todoElcuerpo.translateX
                layoutY: bind etiqueta.layoutY + etiqueta.translateY + todoElcuerpo.layoutY + todoElcuerpo.translateY
                stroke: ColoresIDE.estructurasDeControl
                strokeWidth: 1.9
            }
    public override var hijos = bind [
                poligono,
                encabezado,
                todoElcuerpo,
                l
            ];
}
