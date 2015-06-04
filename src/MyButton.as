/**
 * Created by Пользователь on 01.06.2015.
 */
package {
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class MyButton  extends Sprite{
    private var button:Sprite;
    public var text:TextField;

    public function MyButton(_x:int, _y:int, width:int, height:int,_text:String,textFormat:TextFormat=null) {
        button  = new Sprite();
        text = new TextField();
        text.defaultTextFormat = textFormat;
        this.text.text = _text;
        text.x = _x;
        text.y = _y;
        button.addChild(text);
        button.graphics.beginFill(0xFFCC00);
        button.graphics.drawRect(_x,_y,width,height);
        button.graphics.endFill();
        button.buttonMode=true;
        button.useHandCursor=true;
        button.mouseChildren=false;
        this.addChild(button);
    }
}
}
