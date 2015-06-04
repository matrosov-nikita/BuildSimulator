/**
 * Created by nik on 22.05.15.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextFormat;
import flash.utils.Timer;

public class Factory extends Building {
    private var contract:int;
    var myFormat:TextFormat = new TextFormat();
    var contract1:MyButton;
    var contract2:MyButton;
    var contract_sprite:Sprite;
    public function Factory(_x:Number, _y:Number, build_type:String, path:String, scene:Field, contract:int) {
        super(_x, _y, build_type, path, scene);
        this.contract = contract;
        sprite.addEventListener(MouseEvent.CLICK,chooseContract);
        myFormat.size = 7;
        myFormat.font = "Georgia";
       timer = new Timer(1000);
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
         contract1 = new MyButton(_x * 50, _y * 50, 20, 10, "K1", myFormat);
         contract2 = new MyButton(_x * 50 + 21, _y * 50, 20, 10, "K2", myFormat);
        contract_sprite = new Sprite();
    }

    private function ready(event:TimerEvent):void {
        trace("The end!");
        state="Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.buttonMode=true;
    }

    private function getProfit(event:MouseEvent):void {
        if (contract == 1) {
            scene.coins+=30;
        }
        else {
            scene.coins+=50;
        }
        sprite.removeEventListener(MouseEvent.CLICK, getProfit);
         sprite.removeChild(contract_sprite);
        state="Простаивает";
        timer.reset();
        Redraw();
        sprite.buttonMode=false;
        contract=0;
        //sprite.addEventListener(MouseEvent.CLICK,chooseContract);
        trace(sprite.hasEventListener(MouseEvent.CLICK));
        trace(scene.coins);
    }
    private function tick(event:TimerEvent):void {
        Redraw();
        trace("contract is running");
    }



    private function chooseContract(event:MouseEvent):void {

        if (contract==0) {
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
        }
    }



    private function chooseContract1(event:MouseEvent):void {
        timer.repeatCount = 15;
        startContract(5,1,"contract_1.png");
    }
    private function chooseContract2(event:MouseEvent):void {

        timer.repeatCount = 25;
        startContract(10,2,"contract_2.png");
    }
    private function  startContract(coins:int, number:int,picture:String):void {
        if (scene.coins>=coins) {
            contract = number;

            if (sprite.contains(contract1)) sprite.removeChild(contract1);
            if (sprite.contains(contract2)) sprite.removeChild(contract2);
            contract_sprite.addChild(new Viewer(picture, _x * 50, _y * 50, 20, 20));
            sprite.addChild(contract_sprite);
            state = "В работе";
            timer.start();
        }
    }



    public override  function  Draw():void {

        if (contract==1) {
            sprite.addChild(new Viewer("contract_1.png",_x*50, _y*50,20,20));
        }
        else if (contract==2) {
            sprite.addChild(new Viewer("contract_2.png",_x*50, _y*50,20,20));
        }
        super.Draw();
    }
}
}
