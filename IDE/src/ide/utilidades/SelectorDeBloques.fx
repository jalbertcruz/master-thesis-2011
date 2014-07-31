package ide.utilidades;

import javafx.scene.CustomNode;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import lang.ui.base.BloqueArrastrable;
import javafx.scene.control.ScrollView;
import javafx.scene.control.ScrollBarPolicy;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.Stack;
import javafx.geometry.HPos;
import dragAndDrop.ComportamientoDeArrastre;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import ide.Papelera;
import lang.ui.base.Bloque;
import lang.ui.base.Hueco;
import javafx.scene.layout.HBox;
import refleccion.TypesBuilder;
import lang.model.rutinas.ModeloRutina;
import lang.ui.oo.EjecucionDeOrden;
import lang.ui.tipos.BloqueTipo;
import lang.ui.control.SiEntonces;
import lang.ui.control.SiEntoncesSino;
import lang.ui.control.IteradorPara;
import lang.ui.base.bloques.DeclaracionDeVariable;
import lang.ui.base.bloques.Asignacion;
import lang.ui.base.bloques.BloqueNombreVariable;
import javafx.scene.paint.Color;
import lang.ui.base.secuencia.IndizacionDeSecuencia;
import lang.ui.base.secuencia.MetodosPredefinidosArreglos;
import javafx.scene.text.Text;
import lang.ui.literales.LiteralCadena;
import lang.ui.literales.LiteralNumero;
import lang.ui.literales.LiteralLogico;
import rutinas.TipoRutina;
import lang.ui.oo.EjecucionDeConsulta;

public class SelectorDeBloques extends CustomNode {

    public-init var descripcionHuecoActual: Text;
    public-init var nuevaLabel: function(): Label;

    function crearMetodos(): Void {
        def modeloTest = ModeloRutina {}
        var i = 0;
        metodos = [];
        while (i < constructorDeTipos.enviromentTypes().size()) {

            def _modelos = modeloTest.crearModelosDesdeInterfaz(constructorDeTipos.enviromentTypes().get(i).getType());

            insert for (m in _modelos where m.tipoRutina == TipoRutina.Orden)
                EjecucionDeOrden {
                    modelo: m
                    huecoMouseEntered: mostrarDescripcion
                } into metodos;

            insert for (m in _modelos where m.tipoRutina == TipoRutina.Consulta)
                EjecucionDeConsulta {
                    modelo: m
                    tipoDevolucion: m.tipoDevolucion
                    huecoMouseEntered: mostrarDescripcion
                } into metodos;

            i++;
        }
    //TODO: poner las rutinas que se hayan compilado exitosamente...
    }

    function crearTipos(): Void {
        tipos = [];
        var i = 0;
        while (i < constructorDeTipos.allTypes().size()) {
            insert BloqueTipo {
                tipo: constructorDeTipos.allTypes().get(i).getType()
                esSecuencia: false
            } into tipos;
            i++;
        }
//        def seqs: BloqueTipo[] = for (t in tipos)
//                    BloqueTipo {
//                        esSecuencia: true
//                        tipo: (t as BloqueTipo).tipo
//                    }
//        for (s in seqs)
//            insert s into tipos;
    }

    function crearVariablesDelEntorno(): Void {

        def vs = constructorDeTipos.objetosDisponibles();

        variablesEntorno = for (i in [0..vs.size() - 1])
                    BloqueNombreVariable {
                        ancho: 50
                        alto: 20
                        color: ColoresIDE.fondoVariables
                        nombre: vs.get(i).getNombre()
                        tipo: vs.get(i).getObjeto().getClass().getInterfaces()[0]
                    }

    }

    var metodosDelTipo: BloqueArrastrable[] on replace { };
    def literales: BloqueArrastrable[] = [
                LiteralCadena {
                    nuevaLabel: nuevaLabel
                    label: nuevaLabel()
                }
                LiteralNumero {
                    nuevaLabel: nuevaLabel
                    label: nuevaLabel()
                }
                LiteralLogico {
                    etiqueta: true
                }
                LiteralLogico {
                    etiqueta: false
                }
            ];
//    def btTypesNames = bind for (tn in [0..<(sizeof tipos) / 2]) // cuando hay secuencias
    def btTypesNames = bind for (tn in [0..<(sizeof tipos)])
                Button {
                    text: "Métodos en el tipo: {(tipos[tn] as BloqueTipo).nombre}"
                    action: function(): Void {
                        metodosDelTipo = [];
                        def modeloTest = ModeloRutina {}
                        def _modelos = modeloTest.crearModelosDesdeInterfaz((tipos[tn] as BloqueTipo).tipo);
                        insert for (m in _modelos where m.tipoRutina == TipoRutina.Orden)
                            EjecucionDeOrden {
                                modelo: m
                                huecoMouseEntered: mostrarDescripcion
                            } into metodosDelTipo;
                        insert for (m in _modelos where m.tipoRutina == TipoRutina.Consulta)
                            EjecucionDeConsulta {
                                modelo: m
                                tipoDevolucion: m.tipoDevolucion
                                huecoMouseEntered: mostrarDescripcion
                            } into metodosDelTipo;
//                        if (constructorDeTipos.primitiveTypes().get(tn).getLiteral() != "") {
//                            var con = FXLocal.getContext();
//                            def cls = con.findClass(constructorDeTipos.primitiveTypes().get(tn).getLiteral());
//                            var obj = cls.newInstance();
//
//                            //insert (con.mirrorOf(obj). as BloqueArrastrable) into metodosDelTipo;
//                        //constructorDeTipos.primitiveTypes().get(0).
//                        }

                        indice = 6;
                        estado = "seleccione el método del tipo: {(tipos[tn] as BloqueTipo).nombre}";
                    }
                }
    public var constructorDeTipos: TypesBuilder on replace {
                crearMetodos();
                crearTipos();
                crearVariablesDelEntorno();
            }
    public var manejadorDeRutinas: ManejadorDeRutinas
            on replace old {
                manejadorDeRutinas.rutinaActual.huecoClicked =
                        huecoClicked;
                old.cambioRealizado = null;
                manejadorDeRutinas.cambioRealizado = function(c: lang.ui.base.Rutina): Void {
                            cambio = not cambio;
                            c.huecoClicked = null;
                            manejadorDeRutinas.rutinaActual.huecoClicked =
                                    huecoClicked;
                            ActualizarSecuencias();
                            ActualizarVariables();
                        }
            }
    public var papelera: Papelera on replace { }
    public var grupoMaestro: Group on replace { }
    var metodos: BloqueArrastrable[] on replace { }

    def estructurasDeControl: BloqueArrastrable[] = [
                SiEntonces {
                    grosor: 20
                    huecoMouseEntered: mostrarDescripcion
                }
                SiEntoncesSino {
                    grosor: 20
                    huecoMouseEntered: mostrarDescripcion
                }
                IteradorPara {
                    grosor: 20
                    huecoMouseEntered: mostrarDescripcion
                }
            ];

    function mostrarDescripcion(desc: String): Void {
        descripcionHuecoActual.content = desc;
    }

    var tipos: BloqueArrastrable[] on replace { }

    function ActualizarVariables(): Void {
        parametrosFormales = for (vl in manejadorDeRutinas.rutinaActual.getParametrosFormales())
                    BloqueNombreVariable {
                        ancho: 50
                        alto: 20
                        color: ColoresIDE.fondoVariables
                        nombre: vl.nombre
                        tipo: vl.tipo
                    }
        variablesLocales = for (vl in manejadorDeRutinas.rutinaActual.getVariablesLocales())
                    BloqueNombreVariable {
                        ancho: 50
                        alto: 20
                        color: ColoresIDE.fondoVariables
                        nombre: vl.nombre
                        tipo: vl.tipo
                    }
    }

    function ActualizarSecuencias(): Void {
        secuencias = [];
        for (vl in manejadorDeRutinas.rutinaActual.getVariablesLocales() where vl.esArreglo) {
            insert IndizacionDeSecuencia {
                nombre: vl.nombre
                tipo: vl.tipo
            } into secuencias;
            insert MetodosPredefinidosArreglos {
                nombreArreglo: vl.nombre
            } into secuencias;
        }
        for (vl in manejadorDeRutinas.rutinaActual.getParametrosFormales() where vl.esArreglo) {
            insert IndizacionDeSecuencia {
                nombre: vl.nombre
                tipo: vl.tipo
            } into secuencias;
            insert MetodosPredefinidosArreglos {
                nombreArreglo: vl.nombre
            } into secuencias;
        }

    }

    def btActualizarVariables = Button {
                text: "Actualizar"
                action: function() {
                    ActualizarVariables();
                }
            }
    def btActualizarSecuencias = Button {
                text: "Actualizar"
                action: function() {
                    ActualizarSecuencias();
                }
            }
    var variables: BloqueArrastrable[] = bind [DeclaracionDeVariable {}, Asignacion {}, parametrosFormales, variablesLocales, variablesEntorno];
    var variablesLocales: BloqueArrastrable[];
    var variablesEntorno: BloqueArrastrable[];
    var parametrosFormales: BloqueArrastrable[];
    var secuencias: BloqueArrastrable[] on replace { }

    function registrarHueco(bArrastrable: Bloque): Void {
        insert bArrastrable into manejadorDeRutinas.rutinaActual.bloquesConHuecos;
    }

    function huecoClicked(h: Hueco): Void {
        //        for (n in h.bloquesPermitidos) println(n.tipo);
        def ordenacion = function(entrada: BloqueArrastrable[]): BloqueArrastrable[] {
                    var si: BloqueArrastrable[];
                    var no: BloqueArrastrable[];
                    for (ba in entrada)
                        if (h.esEsteBloquePermitido(ba)) {
                            insert ba into si;
                        } else
                            insert ba into no;

                    return [si, no];
                }

        metodos = ordenacion(metodos);
        //control = ordenacion(control);
        tipos = ordenacion(tipos);
    //        variablesLocales = ordenacion(variablesLocales);
    //        secuencias = ordenacion(secuencias);
    }

    function conv(ba: BloqueArrastrable[], _: Boolean): Stack[] {
        def result: Stack[] = for (b in ba) Stack {
                        nodeHPos: HPos.LEFT
                        content: [b, b.mkNode()]
                    }

        for (r in result) {
            ComportamientoDeArrastre {
                bloque: r.content[1] as BloqueArrastrable
                // bloquesConHuecos: bind bloquesConHuecos
                contenedorDeBloquesConHuecos: manejadorDeRutinas.rutinaActual
                grupoMaestro: grupoMaestro
                papelera: papelera
            }
            registrarHueco(r.content[1] as BloqueArrastrable);
            def mfunc: function(e: MouseEvent): Void = function(e: MouseEvent): Void {
                        Timeline {
                            autoReverse: false
                            repeatCount: 1
                            keyFrames: [
                                KeyFrame {
                                    time: 20ms
                                    action: function(): Void {
                                        if (sizeof r.content < 2) {
                                            def nobj = (r.content[0] as BloqueArrastrable).mkNode() as BloqueArrastrable;
                                            nobj.onMouseReleased = mfunc;
                                            insert nobj into r.content;
                                            ComportamientoDeArrastre {
                                                bloque: nobj
                                                papelera: papelera
                                                // boquesConHuecos: bind bloquesConHuecos
                                                contenedorDeBloquesConHuecos: manejadorDeRutinas.rutinaActual
                                                grupoMaestro: grupoMaestro
                                            }
                                            registrarHueco(nobj);
                                        }
                                    }
                                }
                            ]
                        }.play();

                    }
            r.content[1].onMouseReleased = mfunc;
        }
        result
    }

    var cambio: Boolean = false;
    public override def children = bind VBox {
                spacing: 8
                content: [
                    Rectangle {
                        width: 365
                        height: 500
                        visible: false
                    }
                    ScrollView {
                        width: 365
                        height: 500
                        pannable: true
                        managed: false
                        hbarPolicy: ScrollBarPolicy.AS_NEEDED
                        vbarPolicy: ScrollBarPolicy.AS_NEEDED
                        node: bind objetos[indice]
                    }
                    VBox {
                        spacing: 5
                        content: [
                            HBox {
                                spacing: 5
                                content: [
                                    Button {
                                        text: "Acciones sobre el micromundo"
                                        action: function(): Void {
                                            indice = 0;
                                            estado = "seleccione la acción a ejecutar sobre el micromundo"
                                        }
                                    }
                                    Button {
                                        text: "Control"
                                        action: function(): Void {
                                            indice = 1;
                                            estado = "seleccione la estructura de control"
                                        }
                                    }
                                    Button {
                                        text: "Tipos"
                                        action: function(): Void {
                                            indice = 2;
                                            estado = "seleccione el tipo"
                                        }
                                    }
                                ]
                            }

                            HBox {
                                spacing: 5
                                content: [
                                    Button {
                                        text: "Variables"
                                        action: function(): Void {
                                            indice = 3;
                                            estado = "seleccione la operación sobre variables que necesite"
                                        }
                                    }
//                                    Button {
//                                        text: "Secuencias"
//                                        action: function(): Void {
//                                            indice = 4;
//                                            estado = "seleccione la acción sobre secuencias"
//                                        }
//                                    }
                                    Button {
                                        text: "Métodos/literales"
                                        action: function(): Void {
                                            indice = 5;
                                            estado = "seleccione el tipo"
                                        }
                                    }
                                ]
                            }
                        ]
                    }

                    Label {
                        text: bind estado
                    }
                ]
            }

    init {
        Timeline {
            autoReverse: false
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame {
                    time: 100ms
                    action: function(): Void {
                        for (s in objetos[1].content)
                            for (b in (s as Stack).content)
                                (b as Bloque).actualizarPosiciones();
                    }
                }
            ]
        }.play();
    }

    def objetos: VBox[] = bind [
                VBox {
                    spacing: 3
                    content: bind conv(metodos, cambio)
                }
                VBox {
                    spacing: 3
                    content: bind conv(estructurasDeControl, cambio)
                }
                VBox {
                    spacing: 3
                    content: bind conv(tipos, cambio)
                }
                VBox {
                    spacing: 3
                    content: bind [conv(variables, cambio), btActualizarVariables]
                }
                VBox {
                    spacing: 3
                    content: bind [conv(secuencias, cambio), btActualizarSecuencias]
                }
                VBox {
                    spacing: 3
                    content: bind [btTypesNames, conv(literales, true)]
                }
                VBox {
                    spacing: 3
                    content: bind conv(metodosDelTipo, cambio)
                }
            ];
    var estado = "seleccione la acción a ejecutar sobre el micromundo";
    var indice = 1;
}
