package {
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.utils.Timer;
public class Workshop extends Building {
    public const time_working:int=300000;
    public const profit:int=10;
    public function Workshop(id:Number,_x:Number, _y:Number, scene:Field,time:int) {
    super(id,_x, _y, scene,time);
        path="http://localhost:8090/images/auto_workshop.png";
        build_type="auto_workshop";
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        timer.addEventListener(TimerEvent.TIMER, tick);
    }

    private function launchTimer():void {
        timer= new Timer(Global.time_tick);
        var repCount:int = Math.floor((time_working - time) / Global.time_tick);
        if (repCount==0) ready();
        else {
            timer.repeatCount =repCount;
            state = "В работе";
            timer.start();
        }
    }
    private function tick(event:TimerEvent):void {
        redraw();
    }

    private function ready(event:TimerEvent=null):void {
        state = "Готов к сбору";
        redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }

    private function getProfit(event:MouseEvent):void {
        if (Global.userOperation==false) {
            Global.coins.text = "Coins: " + (scene.coins+=profit).toString();
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
