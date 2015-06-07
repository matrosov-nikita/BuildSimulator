/**
 * Created by nik on 20.05.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;

import Global;

public class Main extends  Sprite{

    var  field:Field;
    private var map: XML = <field coins="50">
        <auto_workshop x="5" y="2" time="234234"/>

        <factory x="6" y="1" contract="1" time="234234"/>
        <factory x="3" y="0" contract="2" time="234234"/>

        <factory x="4" y="0" contract="1" time="234234"/>
        <factory x="9" y="5" contract="2" time="234234"/>
    </field>;
    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        field = new Field(map,this);
        field.draw();
        var menu:ButtonsMenu = new ButtonsMenu(field,stage);

        Global.coins.text = field.coins.toString();
        Global.coins.x = 700;
        Global.coins.text = "Coins: " + field.coins;
        Global.coins.selectable=false;
        addChild( Global.coins);
    }
}
}
