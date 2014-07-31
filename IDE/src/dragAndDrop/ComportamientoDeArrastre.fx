package dragAndDrop;

import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import lang.ui.base.BloqueArrastrable;
import javafx.scene.Group;
import javafx.util.Sequences.*;
import dragAndDrop.base.ComportamientoBasicoDeArrastre;
import ide.Papelera;
import lang.ui.base.Rutina;

public class ComportamientoDeArrastre extends ComportamientoBasicoDeArrastre {

    public var papelera: Papelera;
    public var grupoMaestro: Group;
    public var bloque: BloqueArrastrable on replace {
                for (mango in bloque.mangos) {
                    mango.onMousePressed = MousePressed;
                    mango.onMouseDragged = MouseDragged;
                    mango.onMouseReleased = MouseReleased;
                }
            };
    public var contenedorDeBloquesConHuecos: Rutina;
    var startX = 0.0;
    var startY = 0.0;
    var _marcador: Boolean;

    function MousePressed(e: MouseEvent): Void {
        _marcador = true;

        startX = e.sceneX - bloque.asNode.translateX;
        startY = e.sceneY - bloque.asNode.translateY;
        grupoMaestro.toFront();
    }

    function MouseDragged(e: MouseEvent): Void {
        def tx = e.sceneX - startX;
        def ty = e.sceneY - startY;
        bloque.asNode.translateX = tx;
        bloque.asNode.translateY = ty;
        if (_marcador) {
//            bloque.toFront();
            def no_esta = indexByIdentity(grupoMaestro.content, bloque as Node) == -1;
            if (no_esta) {
                // calcular la posicion respecto a la escena (contenedor del grupoMaestro)
                var cursor: Node = bloque.parent;
                var gx = bloque.layoutX + bloque.translateX;
                var gy = bloque.layoutY + bloque.translateY;
                while (cursor != grupoMaestro.parent) {
                    gx += cursor.layoutX + cursor.translateX;
                    gy += cursor.layoutY + cursor.translateY;
                    cursor = cursor.parent;
                }

                insert (bloque as Node) into grupoMaestro.content;

                bloque.translateX = 0;
                bloque.translateY = 0;

//                println("-------------------------------------------------");
//                println(gx);
//                println(gy);
//
                bloque.layoutX = gx;
                bloque.layoutY = gy;
            }
            _marcador = false;
        }
    }

    function MouseReleased(e: MouseEvent): Void {
        def punto: Node = bloque.marca;
        def huecos = [for (b in contenedorDeBloquesConHuecos.bloquesConHuecos) b.huecos, contenedorDeBloquesConHuecos.huecos, papelera];
        var f = false;
        for (hueco in huecos)
            if (punto.intersects(punto.sceneToLocal(hueco.localToScene(hueco.boundsInLocal)))) {
                hueco.tocar(bloque);
                f = true;
                break;
            }

        for (b in contenedorDeBloquesConHuecos.bloquesConHuecos) {
            b.actualizarHuecos();
        }

        contenedorDeBloquesConHuecos.actualizarHuecos();

        bloque.onMouseReleased(e);
        bloque.onMouseReleased = null;

        if(not f)
        insert bloque into Group{}.content;
        
    }

}
