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

    var profit:int;

    public function Workship(_x:Number, _y:Number, build_type:String, path:String, scene:Field) {
    super(_x, _y, build_type, path, scene);
        timer= new Timer(1000,10);
        state="В работе";
         profit =  0;
        timer.start();
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, readyInfrastructure);
        timer.addEventListener(TimerEvent.TIMER, tick);

    }

    private function tick(event:TimerEvent):void {
        Redraw();
      //  event.updateAfterEvent();
        //trace(timer.currentCount);
    }

    private function readyInfrastructure(event:TimerEvent):void {

        state = "Готов к сбору";
        Redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.buttonMode=true;
    }


    private function getProfit(event:MouseEvent):void {

        scene.coins+=10;
        sprite.removeEventListener(MouseEvent.CLICK, getProfit);
        state="В работе";
        Redraw();
        trace(scene.coins);
        timer.reset();
        timer.start();
    }


}

}
