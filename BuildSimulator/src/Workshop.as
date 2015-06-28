package {
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.utils.Timer;
public class Workshop extends Building {
    public static const time_working:int=300;
    public const path_workshop:String ="http://localhost:4567/auto_workshop.png";
    public const path_workshop_income = "http://localhost:4567/getShopIncome";
    public const profit:int=10;
    public function Workshop(_x:Number, _y:Number, scene:Field,time:int,contract:int = 0) {
    super(_x, _y, scene,time, contract);
        path=path_workshop;
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
            HttpHelper.sendRequest(path_workshop_income, variables, function(data) {
                if (data=="true") {
                    timer.reset();
                    time = time_working;
                    launchTimer();
                   Global. clearErrorField();
                }
                else {
                    Global.error_field.text = Global.state["profitFactory"];
                }
            });
        }
        Global.userOperation=false;
    }
    public override function move(index:int,new_x:int,new_y:int):void {
        super.move(index,new_x,new_y);
        if (state==Global.state["ready"]) sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }
}
}
