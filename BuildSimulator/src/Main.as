/**
 * Created by nik on 20.05.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

public class Main extends  Sprite{
   public var  field:Field;
    public const path_get_field:String ="http://localhost:4567/getField";
    public function Main() {
            stage.align = StageAlign.TOP_LEFT;
            //stage.scaleMode=StageScaleMode.NO_SCALE;
            field = new Field(stage);
            HttpHelper.sendRequest(path_get_field,null, function(data){
                var xml:XML = XML(data);
                if (xml.name()=="field")
                    field.getField(xml);
            });
            var menu:ButtonsMenu = new ButtonsMenu(field,stage);
            Global.coins.text = field.coins.toString();
            Global.coins.text = "Coins: " + field.coins;
            Global.coins.selectable=false;
            addChild(Global.coins);
            addChild(Global.error_field);
    }
}
}
