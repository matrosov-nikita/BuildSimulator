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
    public static const time_contract1:int = 300;
    public static const time_contract2:int = 900;
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
    var contract1:Sprite;
    var contract2:Sprite;
    var contract_sprite:Sprite;
      var visible_contract:Boolean = false;
    public function Factory(_x:Number, _y:Number, scene:Field,time:int, contract:int) {
        super(_x, _y, scene,time, contract);
        path="http://localhost:4567/factory.png";
        build_type="factory";

        this.contract = contract;
        if (contract==0) {
            sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        }
        timer = new Timer(Global.time_tick);
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
    }

    private function launchTimer():void {
        if (contract!=0) {
            var repCount:int = time;
            if (repCount==0)
            {
                ready();
            }
            else {
                trace(time);
                timer.repeatCount =repCount;
                state="В работе";
                timer.start();
            }
        }
    }

    public override function getProfit(event:MouseEvent):void {

        if (Global.userOperation==false) {
            if (contract == 1) {
                Global.coins.text = "Coins: " + (scene.coins+=profit_contract1).toString();
            }
            else {
                Global.coins.text = "Coins: " + (scene.coins+=profit_contract2).toString();

            }
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);

            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y=_y;
            HttpHelper.sendRequest2('http://localhost:4567/getFactoryIncome', variables,function(data) {
                trace(data);
                if (data=="true") {
                    timer.reset();
                    time = 0;
                    contract = 0;
                    state="Простаивает";
                    redraw();
                    clearContract();
                    sprite.addEventListener(MouseEvent.CLICK, chooseContract);
                    visible_contract = false;
                }
            });
        }
        Global.userOperation = false;
    }



    private function chooseContract(event:MouseEvent):void {

        if (contract==0 && Global.userOperation==false && !visible_contract ) {
            var myFormat:TextFormat = new TextFormat("Georgia",7);
            contract1 = new Sprite();
            contract2 = new Sprite();
            var btn1:MyButton = new MyButton(_x * cell_size, _y * cell_size, width_button_contract, height_button_contract, name_button_contract1, myFormat);
            var btn2:MyButton = new MyButton(_x * cell_size + offset_button_contract, _y * cell_size, width_button_contract, height_button_contract, name_button_contract2, myFormat);
            contract1.addChild(btn1);
            contract2.addChild(btn2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);

        }
        Global.userOperation=false;
    }

    private function chooseContract1(event:MouseEvent):void {

        if (scene.coins>=cost_launch_contract1) {
            Global.coins.text = "Coins: " + (scene.coins-=cost_launch_contract1).toString();
            clearContractButtons();
            startContract(1);
        }
    }

    private function chooseContract2(event:MouseEvent):void {

        if (scene.coins>=cost_launch_contract2) {
            Global.coins.text = "Coins: " + (scene.coins-=cost_launch_contract2).toString();
            clearContractButtons();
            startContract(2);
        }
    }
    private function  startContract( number:int):void {
        var variables:URLVariables = new URLVariables();
        variables.contract=number;
        variables.x = _x;
        variables.y=_y;
        HttpHelper.sendRequest2('http://localhost:4567/startContract', variables,function(data) {
            contract = number;
            time = (contract==1)?time_contract1:time_contract2;
            launchTimer();
            drawContract();
        });
    }

    public override  function draw():void {
        drawContract();
        super.draw();
    }

    private function drawContract():void {
        if (contract==1) {
            contract_sprite = new Viewer("http://localhost:4567/contract_1.png",_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer("http://localhost:4567/contract_2.png",_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
    }

    private function clearContract():void {
        sprite.removeChild(contract_sprite);
    }

    public override function move(index,new_x,new_y):void {
        super.move(index,new_x,new_y);
         if (contract==0) sprite.addEventListener(MouseEvent.CLICK, chooseContract); else
             drawContract();
    }

    private function clearContractButtons():void {
        sprite.removeEventListener(MouseEvent.CLICK, chooseContract);
        if  (sprite.contains(contract1))
          sprite.removeChild(contract1);
        if  (sprite.contains(contract2))
        sprite.removeChild(contract2);
        visible_contract = true;
    }
}
}
