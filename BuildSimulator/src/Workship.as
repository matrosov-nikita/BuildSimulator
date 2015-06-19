/**
 * Created by nik on 22.05.15.
 */
package {
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.utils.Timer;
public class Workship extends Building {
    public function Workship(id:Number,_x:Number, _y:Number, scene:Field,time:int) {
    super(id,_x, _y, scene,time);
        path="http://localhost:8090/images/auto_workshop.png";
        build_type="auto_workshop";
        timer= new Timer(1000);
        var repCount:int = Math.floor((300000 - time) / 1000);
        if (repCount==0) ready();
        else {
            timer.repeatCount =repCount;
            state = "В работе";
            timer.start();
        }
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        timer.addEventListener(TimerEvent.TIMER, tick);
    }

    private function tick(event:TimerEvent):void {
        Redraw();
    }

    private function ready(event:TimerEvent=null):void {
        state = "Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }

    private function getProfit(event:MouseEvent):void {
        if (Global.userOperation==false) {
            Global.coins.text = "Coins: " + (scene.coins+=10).toString();
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            time=0;
            timer.reset();
            var variables:URLVariables = new URLVariables();
            variables.id=id;
            Global.currentBuilding = id;
            sendRequest('http://localhost:8090/getShopIncome', variables);
        }
        Global.userOperation=false;
    }
}
}
