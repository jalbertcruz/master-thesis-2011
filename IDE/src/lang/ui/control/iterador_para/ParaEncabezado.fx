package lang.ui.control.iterador_para;

import lang.ui.base.Bloque;
import lang.ui.base.huecos.Expresion;
import javafx.scene.Node;
import tiposPrimitivos.Numero;
import lang.ui.base.acciones.AccionBloquePorTipo;
import javafx.scene.layout.Stack;
import javafx.scene.layout.VBox;
import java.io.FileReader;
import com.google.gson.Gson;
import refleccion.EtiquetasDesdeHasta;
import lang.ui.base.huecos.LugarParaVariable;
import lang.ui.base.bloques.BloqueNombreVariable;
import javafx.scene.text.Text;
import javafx.scene.layout.HBox;

public class ParaEncabezado extends Bloque {

    public def _para = Stack {}
    public def _desde = Stack {}
    public def _hasta = Stack {}
    public def _paso = Stack {}

    public function variable_de_control(): String {
        //tb.text
        (_para.content[0] as BloqueNombreVariable).nombre;
    }

    public function valor_de_inicializacion(): String {
        (_desde.content[sizeof _desde.content - 1] as Bloque).traducir()
    }

    public function cota_superior(): String {
        (_hasta.content[sizeof _hasta.content - 1] as Bloque).traducir()
    }

    public function variacion(): String {
        (_paso.content[sizeof _paso.content - 1] as Bloque).traducir()
    }

    override public function actualizarPosiciones(): Void {
        //        ancho = tb.width + para.ancho + desde.ancho + hasta.ancho + paso.ancho + vb.boundsInParent.width;
        //        alto = tb.height + para.alto + desde.alto + hasta.alto + paso.alto + vb.boundsInParent.height;
        ancho = para.ancho + desde.ancho + hasta.ancho + paso.ancho + vb.boundsInParent.width;
        alto = para.alto + desde.alto + hasta.alto + paso.alto + vb.boundsInParent.height;
    }

//    var tb = TextBox {
//                columns: 10
//            }
//    public def para = IDPara {
//                etiqueta: "para: "
//                idName: bind tb
//            }
 def para: LugarParaVariable = LugarParaVariable {
                huecoClicked: bind huecoClicked
                huecoMouseEntered: bind huecoMouseEntered
                contenido: bind _para
                bloquesPermitidos: [
                    AccionBloquePorTipo {
                        tipo: "variable"
                        accion: function(b: Bloque) {
                            b.layoutX = 0;
                            b.layoutY = 0;
                            b.translateX = 0;
                            b.translateY = 0;

                            insert (b as Node) into _para.content;
                        }
                    }
                ]
            }
            
    public def desde = ExpresionNumericaEtiquetada {
                etiqueta: "desde: "
                expresion: Expresion {
                    huecoClicked: bind huecoClicked
                    descripcion: ""
                    huecoMouseEntered: bind huecoMouseEntered
                    contenido: bind _desde
                    tipo: Numero.class
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: Numero.class.getName()
                            accion: function(b: Bloque) {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;
                                insert (b as Node) into _desde.content;
                            }
                        }
                    ]
                }
            }
    public def hasta = ExpresionNumericaEtiquetada {
                etiqueta: "hasta: "
                expresion: Expresion {
                    huecoClicked: bind huecoClicked
                    descripcion: ""
                    huecoMouseEntered: bind huecoMouseEntered
                    contenido: bind _hasta
                    tipo: Numero.class
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: Numero.class.getName()
                            accion: function(b: Bloque) {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;
                                insert (b as Node) into _hasta.content;
                            }
                        }
                    ]
                }
            }
    public def paso = ExpresionNumericaEtiquetada {
                etiqueta: "con paso de: "
                expresion: Expresion {
                    huecoClicked: bind huecoClicked
                    descripcion: ""
                    huecoMouseEntered: bind huecoMouseEntered
                    contenido: bind _paso
                    tipo: Numero.class
                    bloquesPermitidos: [
                        AccionBloquePorTipo {
                            tipo: Numero.class.getName()
                            accion: function(b: Bloque) {
                                b.huecoClicked = huecoClicked;
                                b.layoutX = 0;
                                b.layoutY = 0;
                                b.translateX = 0;
                                b.translateY = 0;
                                insert (b as Node) into _paso.content;
                            }
                        }
                    ]
                }
            }
    public def mangos = bind [desde.mango, hasta.mango, paso.mango, _etiquetaPara];
    def vb = VBox {
                spacing: 3
                content: bind [
                    HBox{
                        content: [
                                _etiquetaPara,
                                para
                            ]
                    },
//                    para,
                    desde,
                    hasta,
                    paso
                ]
            };
    public override var hijos = bind vb;
    def portador_huecos = [desde, hasta, paso];
    
    def _etiquetaPara = Text { content: "" }

    init {
        huecos = for (h in portador_huecos) h.expresion;
        insert para into huecos;
        actualizarHuecos = function(): Void {
                    huecos = for (h in portador_huecos where sizeof h.expresion.contenido.content > 0) h.expresion;
                    if (_para.content == [])
                        insert para into huecos;
                }

        def reader: FileReader = new FileReader("./configuracion/EtiquetasDesdeHasta.json");
        def gson: Gson = new Gson();
        def et: EtiquetasDesdeHasta = gson.fromJson(reader, EtiquetasDesdeHasta.class);
        reader.close();

        _etiquetaPara.content = et.getNombreVariable();
        desde.etiqueta = et.getInicio();
        hasta.etiqueta = et.getFin();
        paso.etiqueta = et.getPaso();
        
    }

}

