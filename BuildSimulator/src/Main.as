/**
 * Created by nik on 20.05.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;

public class Main extends  Sprite{
   public var  field:Field;
    public const PATH_GET_FIELD:String ="http://localhost:4567/getField";
    public function Main()
    {
            stage.align = StageAlign.TOP_LEFT;
            Global.field = new Field(stage);
            HttpHelper.sendRequest(PATH_GET_FIELD,null, function(data){
                var xml:XML = XML(data);
                if (xml.name()=="field")
                    Global.field.getField(xml);
            });
            var menu:ButtonsMenu = new ButtonsMenu(stage);
            Global.coins.text =  Global.field.coins.toString();
            Global.coins.text = "Coins: " +  Global.field.coins;
            Global.coins.selectable=false;
            addChild(Global.coins);
            addChild(Global.error_field);
    }
}
}
