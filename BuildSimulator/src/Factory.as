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
    public var contract:int;

    var contract1:MyButton;
    var contract2:MyButton;
    var contract_sprite:Sprite;
    public function Factory(_x:Number, _y:Number, build_type:String, path:String, scene:Field, contract:int,time:int) {
        super(_x, _y, build_type, path, scene,time);
        this.contract = contract;
      if (this.contract==0) {
          sprite.addEventListener(MouseEvent.CLICK, chooseContract);
      }
         timer = new Timer(1000);
        if (state=="В работе") {
            var time_to_complete:int = ((contract==1)?300000:900000);
            var repCount:int = Math.floor((time_to_complete-time)/1000);
           if (repCount==0)
           {
               ready();
           }
            else {
               timer.repeatCount =repCount;
               timer.start();
           }
        }
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);

        contract_sprite = new Sprite();
    }

    private function ready(event:TimerEvent=null):void {
        state="Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.removeEventListener(MouseEvent.CLICK, chooseContract);
        sprite.buttonMode=true;
    }

    private function getProfit(event:MouseEvent):void {
        trace(Global.userOperation);
        if (Global.userOperation==false) {
            if (contract == 1) {
                Global.coins.text = "Coins: " + (scene.coins+=30).toString();

            }
            else {
                Global.coins.text = "Coins: " + (scene.coins+=50).toString();

            }
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            sprite.removeChild(contract_sprite);
            contract_sprite = new Sprite();
            state = "Простаивает";
            timer.reset();
            time=0;
            Redraw();
            sprite.buttonMode = false;
            contract = 0;
            sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        }
        Global.userOperation = false;
        if (!sprite.hasEventListener(MouseEvent.CLICK) )
        {
            sprite.addEventListener(MouseEvent.CLICK,getProfit);
        }
    }
    private function tick(event:TimerEvent):void {
        Redraw();
    }


    private function chooseContract(event:MouseEvent):void {
        trace(sprite.hasEventListener(MouseEvent.CLICK));
        if (contract==0 && Global.userOperation==false) {
            contract1 = new MyButton(_x * 50, _y * 50, 20, 10, "K1", myFormat);
            contract2 = new MyButton(_x * 50 + 21, _y * 50, 20, 10, "K2", myFormat);
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
        }
        Global.userOperation=false;
        if (!sprite.hasEventListener(MouseEvent.CLICK) )
        {
            sprite.addEventListener(MouseEvent.CLICK,chooseContract);
        }
    }



    private function chooseContract1(event:MouseEvent):void {

        if (scene.coins>=5) {
            Global.coins.text = "Coins: " + (scene.coins-=5).toString();
            timer.repeatCount = 300;
            startContract(5, 1, "contract_1.png");
        }

    }
    private function chooseContract2(event:MouseEvent):void {

        if (scene.coins>=10) {
            Global.coins.text = "Coins: " + (scene.coins-=10).toString();
            timer.repeatCount = 900;
            startContract(10, 2, "contract_2.png");
        }

    }
    private function  startContract(coins:int, number:int,picture:String):void {

            contract = number;

            if (sprite.contains(contract1))
                sprite.removeChild(contract1);
            if (sprite.contains(contract2))
                sprite.removeChild(contract2);
            contract_sprite.addChild(new Viewer(picture, _x * 50, _y * 50, 15, 15));
            sprite.addChild(contract_sprite);
            state = "В работе";
            timer.start();

    }



    public override  function  Draw():void {

        if (contract==1) {
            contract_sprite = new Viewer("contract_1.png",_x*50, _y*50,15,15);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer("contract_2.png",_x*50, _y*50,15,15);
            sprite.addChild(contract_sprite);
        }
        super.Draw();
    }
}
}
