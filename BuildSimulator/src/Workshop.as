package {
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.utils.Timer;
public class Workshop extends Building {
    public static const TIME_WORKING:int=300;
    public static const COST_WORKSHOP:int=20;
    public const PATH_WORKSHOP_INCOME = "http://localhost:4567/getShopIncome";
    public const PROFIT:int=10;
    public function Workshop(_x:Number, _y:Number,time:int,contract:int = 0)
    {
    super(_x, _y,time, contract);
        path=Global.PATH_WORKSHOP;
        build_type="auto_workshop";
        timer= new Timer(Global.TIME_TICK);
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        timer.addEventListener(TimerEvent.TIMER, tick);
    }

    public override  function getProfit(event:MouseEvent):void
    {
        if (Global.userOperation==false) {

            sprite.removeEventListener(MouseEvent.CLICK, getProfit);

            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y = _y;
            successGetProfit();
            HttpHelper.sendRequest(PATH_WORKSHOP_INCOME, variables, function(data) {
                if (data=="false") {
                    time=0;
                    giveProfit();
                    Global.error_field.text = Global.state["profitFactory"];
                }
            });
        }
        Global.userOperation=false;
    }

    public function successGetProfit():void
    {
        Global.coins.text = "Coins: " + ( Global.field.coins+=PROFIT).toString();
        timer.reset();
        time = TIME_WORKING;
        launchTimer();
        Global. clearErrorField();
    }

    public override function move(index:int,new_x:int,new_y:int):void
    {
        super.move(index,new_x,new_y);
        if (state==Global.state["ready"]) sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }
}
}
