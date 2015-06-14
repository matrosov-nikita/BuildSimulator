/**
 * Created by nik on 20.05.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;

import Global;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.net.XMLSocket;
import flash.system.Security;

public class Main extends  Sprite{

    var  field:Field;


    public function Main() {

        stage.align = StageAlign.TOP_LEFT;

        field = new Field(this);
        var menu:ButtonsMenu = new ButtonsMenu(field,stage);

        Global.coins.text = field.coins.toString();
        Global.coins.x = 700;
        Global.coins.text = "Coins: " + field.coins;
        Global.coins.selectable=false;
        addChild( Global.coins);
    }





}
}
