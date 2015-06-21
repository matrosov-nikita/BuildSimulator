/**
 * Created by nik on 22.05.15.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.text.TextFormat;
import flash.utils.Timer;
public class Factory extends Building {
    public const time_contract1:int = 300000;
    public const time_contract2:int = 900000;
    public const profit_contract1:int=30;
    public const profit_contract2:int=50;
    public const cost_launch_contract1:int=5;
    public const cost_launch_contract2:int=10;
    public const width_button_contract:int=20;
    public const height_button_contract:int=15;
    public const offset_button_contract:int=21;
    public const name_button_contract1:String="К1";
    public const name_button_contract2:String="К2";
    public const width_contract_image:int = 15;
    public const height_contract_image:int = 15;
    public var contract:int;
    var contract1:MyButton;
    var contract2:MyButton;
    var contract_sprite:Sprite;

    public function Factory(id:Number,_x:Number, _y:Number, scene:Field, contract:int,time:int) {
        super(id,_x, _y, scene,time);
        path="http://localhost:8090/images/factory.png";
        build_type="factory";
        this.contract = contract;
        if (contract==0) {
            sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        }
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
    }

    private function launchTimer():void {
        timer = new Timer(Global.time_tick);
        if (contract!=0) {
            var time_to_complete:int = ((contract==1)?time_contract1:time_contract2);
            var repCount:int = Math.floor((time_to_complete-time)/Global.time_tick);
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
    }
    private function ready(event:TimerEvent=null):void {
        state="Готов к сбору";
        redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
        sprite.removeEventListener(MouseEvent.CLICK, chooseContract);
        sprite.buttonMode=true;
    }

    private function getProfit(event:MouseEvent):void {

        if (Global.userOperation==false) {
            if (contract == 1) {
                Global.coins.text = "Coins: " + (scene.coins+=profit_contract1).toString();
            }
            else {
                Global.coins.text = "Coins: " + (scene.coins+=profit_contract2).toString();

            }
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            timer.reset();
            time=0;
            contract = 0;
            var variables:URLVariables = new URLVariables();
            variables.id=id;
            Global.currentBuilding = id;
            variables.contract=contract;
            sendRequest('http://localhost:8090/getFactoryIncome', variables);
        }
        Global.userOperation = false;
    }

    private function tick(event:TimerEvent):void {
        redraw();
    }

    private function chooseContract(event:MouseEvent):void {
        if (contract==0 && Global.userOperation==false) {
            var myFormat = new TextFormat("Georgia",7);
            contract1 = new MyButton(_x * cell_size, _y * cell_size, width_button_contract, height_button_contract, name_button_contract1, myFormat);
            contract2 = new MyButton(_x * cell_size + offset_button_contract, _y * cell_size, width_button_contract, height_button_contract, name_button_contract2, myFormat);
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
        }
        Global.userOperation=false;
    }

    private function chooseContract1(event:MouseEvent):void {

        if (scene.coins>=cost_launch_contract1) {
            Global.coins.text = "Coins: " + (scene.coins-=cost_launch_contract1).toString();
            startContract(1);
        }
    }

    private function chooseContract2(event:MouseEvent):void {

        if (scene.coins>=cost_launch_contract2) {
            Global.coins.text = "Coins: " + (scene.coins-=cost_launch_contract2).toString();
            startContract(2);
        }
    }
    private function  startContract( number:int):void {
        var variables:URLVariables = new URLVariables();
        variables.id=id;
        variables.contract=number;
        Global.currentBuilding = id;
        sendRequest('http://localhost:8090/startContract', variables);
    }

    public override  function draw():void {

        if (contract==1) {
            contract_sprite = new Viewer("http://localhost:8090/images/contract_1.png",_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer("http://localhost:8090/images/contract_2.png",_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
        super.draw();
    }
}
}
