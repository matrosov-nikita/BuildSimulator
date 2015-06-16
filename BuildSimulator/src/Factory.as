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
    public function Factory(_x:Number, _y:Number, scene:Field, contract:int,time:int) {
        super(_x, _y, scene,time);
        path="http://localhost:8090/images/factory.png";
        build_type="factory";
        this.contract = contract;
        if (contract==0) {
            sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        }
        timer = new Timer(1000);
        if (contract!=0) {
            var time_to_complete:int = ((contract==1)?300000:900000);
            var repCount:int = Math.floor((time_to_complete-time)/1000);
           if (repCount==0)
           {
               ready();
           }
            else {
               timer.repeatCount =repCount;
               state="В работе";
               timer.start();
           }
        }
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
    }

    private function ready(event:TimerEvent=null):void {
        state="Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.removeEventListener(MouseEvent.CLICK, chooseContract);
        sprite.buttonMode=true;
    }

    private function getProfit(event:MouseEvent):void {

        if (Global.userOperation==false) {
            if (contract == 1) {
                Global.coins.text = "Coins: " + (scene.coins+=30).toString();
            }
            else {
                Global.coins.text = "Coins: " + (scene.coins+=50).toString();

            }
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            timer.reset();
            time=0;
            contract = 0;
        }
        Global.userOperation = false;
    }

    private function tick(event:TimerEvent):void {
        Redraw();
    }

    private function chooseContract(event:MouseEvent):void {
        if (contract==0 && Global.userOperation==false) {
            var myFormat = new TextFormat("Georgia",7);
            contract1 = new MyButton(_x * 50, _y * 50, 20, 15, "K1", myFormat);
            contract2 = new MyButton(_x * 50 + 21, _y * 50, 20, 15, "K2", myFormat);
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
        }
        Global.userOperation=false;
    }

    private function chooseContract1(event:MouseEvent):void {

        if (scene.coins>=5) {
            Global.coins.text = "Coins: " + (scene.coins-=5).toString();
            timer.repeatCount = 300;
            startContract(1);
        }
    }

    private function chooseContract2(event:MouseEvent):void {

        if (scene.coins>=10) {
            Global.coins.text = "Coins: " + (scene.coins-=10).toString();
            timer.repeatCount = 900;
            startContract(2);
        }
    }
    private function  startContract( number:int):void {
            contract = number;
    }

    public override  function  Draw():void {

        if (contract==1) {
            contract_sprite = new Viewer("http://localhost:8090/images/contract_1.png",_x*50, _y*50,15,15);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer("http://localhost:8090/images/contract_2.png",_x*50, _y*50,15,15);
            sprite.addChild(contract_sprite);
        }
        super.Draw();
    }
}
}
