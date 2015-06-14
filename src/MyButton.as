/**
 * Created by ������������ on 01.06.2015.
 */
package {
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class MyButton  extends SimpleButton{


    private var upColor:uint   = 0xFFCC00;
    private var overColor:uint = 0xCCFF00;
    private var downColor:uint = 0x00CCFF;
    public function MyButton(_x:int, _y:int, width:int, height:int,_text:String,textFormat:TextFormat) {


      overState = new ButtonDisplayState(_x, _y, width, height, _text, textFormat, overColor);
      downState =  new ButtonDisplayState(_x, _y, width, height, _text, textFormat, downColor);
      upState =  new ButtonDisplayState(_x, _y, width, height, _text, textFormat, upColor);
        hitTestState = new ButtonDisplayState(_x, _y, width, height, _text, textFormat, upColor);
    }

}

}

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class ButtonDisplayState extends Sprite {
    private var bgColor:uint;
    private var text:TextField;
    public function ButtonDisplayState(_x:int, _y:int, width:int, height:int,_text:String,textFormat:TextFormat,bgColor:uint) {
        text = new TextField();
        text.defaultTextFormat = textFormat;
        this.text.text = _text;
        text.x = _x;
        text.y = _y;
        text.height=height;
        text.width=width;
        this.bgColor = bgColor;
        buttonMode=true;
        addChild(text);
        graphics.lineStyle(1, 0x555555);
        graphics.beginFill(bgColor);
        graphics.drawRect(_x, _y, width, height);
        graphics.endFill();
    }
}
