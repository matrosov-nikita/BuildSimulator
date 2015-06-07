/**
 * Created by nik on 22.05.15.
 */
package {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;
import flash.utils.setInterval;

public class Workship extends Building {



    public function Workship(_x:Number, _y:Number, build_type:String, path:String, scene:Field,time:int) {
    super(_x, _y, build_type, path, scene,time);

        timer= new Timer(1000);
        timer.repeatCount = Math.floor((300000-time)/1000);
        state="В работе";
        timer.start();
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        timer.addEventListener(TimerEvent.TIMER, tick);

    }

    private function tick(event:TimerEvent):void {
        Redraw();
      //  event.updateAfterEvent();
        //trace(timer.currentCount);
    }

    private function ready(event:TimerEvent):void {

        state = "Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.buttonMode=true;
    }


    private function getProfit(event:MouseEvent):void {
        if (Global.userOperation==false) {
            Global.coins.text = "Coins: " + (scene.coins+=10).toString();

            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            state = "В работе";
            Redraw();
            timer.reset();
            timer.repeatCount = 300;
            timer.start();
        }
        Global.userOperation=false;
        if (!sprite.hasEventListener(MouseEvent.CLICK) )
        {
            sprite.addEventListener(MouseEvent.CLICK,getProfit);
        }

    }


}

}
