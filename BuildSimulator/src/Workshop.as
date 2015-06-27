package {
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.utils.Timer;
public class Workshop extends Building {

    public static const time_working:int=300;
    public const profit:int=10;
    public function Workshop(_x:Number, _y:Number, scene:Field,time:int,contract:int = 0) {
    super(_x, _y, scene,time, contract);
        path="http://localhost:4567/auto_workshop.png";
        build_type="auto_workshop";
        timer= new Timer(Global.time_tick);
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        timer.addEventListener(TimerEvent.TIMER, tick);
    }


    public override  function getProfit(event:MouseEvent):void {
        if (Global.userOperation==false) {
            Global.coins.text = "Coins: " + (scene.coins+=profit).toString();
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);

            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y = _y;
            HttpHelper.sendRequest('http://localhost:4567/getShopIncome', variables, function(data) {
                if (data=="true") {
                    timer.reset();
                    time = time_working;
                    launchTimer();
                }
                else {
                    Global.errors.text = "Не удалось собрать прибыль с инфраструктуры"
                }
            });
        }
        Global.userOperation=false;
    }
    public override function move(index,new_x,new_y):void {
        super.move(index,new_x,new_y);
        if (state=="Готов к сбору") sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }
}
}
