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
    public const width_contract_image:int = 15;
    public const height_contract_image:int = 15;
    public const name_button_contract1:String="К1";
    public const name_button_contract2:String="К2";
    public const path_factory:String = "http://localhost:4567/factory.png";
    public const path_contract1:String = "http://localhost:4567/contract_1.png";
    public const path_contract2:String = "http://localhost:4567/contract_2.png";
    public const path_start_contract:String  = "http://localhost:4567/startContract";
    public const path_get_factory_income:String = "http://localhost:4567/getFactoryIncome";
    public var contract:int;
    var contract1:Sprite;
    var contract2:Sprite;
    var contract_sprite:Sprite;
    var visible_contract:Boolean = false;

    public function Factory(_x:Number, _y:Number, scene:Field,time:int, contract:int) {
        super(_x, _y, scene,time, contract);
        path=path_factory;
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

    public override function launchTimer():void {
        if (contract!=0) {
            super.launchTimer();
        }
    }

    public override function getProfit(event:MouseEvent):void {
        if (Global.userOperation==false) {
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y = _y;
            HttpHelper.sendRequest(path_get_factory_income, variables,function(data) {
                if (data=="true") {
                    if (contract == 1) {
                        Global.coins.text = "Coins: " + (scene.coins+=profit_contract1).toString();
                    }
                    else {
                        Global.coins.text = "Coins: " + (scene.coins+=profit_contract2).toString();
                    }
                    resetFactoryProperties();
                }
                else {
                    Global.error_field.text = Global.error_array["profitFactory"];
                }
            });
        }
        Global.userOperation = false;
    }

    private function resetFactoryProperties():void {
        timer.reset();
        time = 0;
        contract = 0;
        state=Global.state["stand"];
        redraw();
        clearContract();
        sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        visible_contract = false;
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

            clearContractButtons();
            startContract(1);
    }

    private function chooseContract2(event:MouseEvent):void {

            clearContractButtons();
            startContract(2);
    }
    private function  startContract( number:int):void {
        var variables:URLVariables = new URLVariables();
        variables.contract=number;
        variables.x = _x;
        variables.y=_y;
        HttpHelper.sendRequest(path_start_contract, variables,function(data) {
            if (data=="true") {
                contract = number;
                if (contract == 1) {
                    time = time_contract1;
                    Global.coins.text = "Coins: " + (scene.coins -= cost_launch_contract1).toString();
                }
                else {
                    time = time_contract2;
                    Global.coins.text = "Coins: " + (scene.coins -= cost_launch_contract2).toString();
                }
                launchTimer();
                drawContract();
            }
            else {
                Global.error_field.text = Global.state["startContract"];
            }
        });
    }

    public override  function draw():void {
        drawContract();
        super.draw();
    }

    private function drawContract():void {
        if (contract==1) {
            contract_sprite = new Viewer(path_contract1,_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer(path_contract1,_x*cell_size, _y*cell_size,width_contract_image,height_contract_image);
            sprite.addChild(contract_sprite);
        }
    }

    private function clearContract():void {
        sprite.removeChild(contract_sprite);
    }

    public override function move(index:int,new_x:int,new_y:int):void {
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
