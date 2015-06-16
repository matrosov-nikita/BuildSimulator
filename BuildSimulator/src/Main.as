/**
 * Created by nik on 20.05.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;
public class Main extends  Sprite{
    var  field:Field;
    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        field = new Field(this);
        var menu:ButtonsMenu = new ButtonsMenu(field,stage);
        Global.coins.text = field.coins.toString();
        Global.coins.text = "Coins: " + field.coins;
        Global.coins.selectable=false;
        addChild( Global.coins);
    }
}
}
