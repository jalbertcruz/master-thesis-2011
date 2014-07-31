/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package robot;

import uci.erlProxyGen.IRobotDone;

/**
 *
 * @author jalbert
 */
public class TestDone implements IRobotDone{

    @Override
    public void moverHastaAlmacenDone() {
        System.out.println("public void moverHastaAlmacenDone");
    }

    @Override
    public void moverHastaFabricaDone() {
        System.out.println("public void moverHastaFabricaDone() {");
    }

    @Override
    public void cogerObjetoDone() {
        System.out.println("public void cogerObjetoDone() {");
    }

    @Override
    public void entregarObjetoDone() {
        System.out.println("public void entregarObjetoDone() {");
    }

}
