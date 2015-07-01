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
    public static const COST_FACTORY:int=30;
    public static const  CONTRACTS:Array = [];
    public const WIDTH_BUTTON_CONTRACT:int=20;
    public const HEIGHT_BUTTON_CONTRACT:int=15;
    public const OFFSET_BUTTON_CONTRACT:int=21;
    public const WIDTH_CONTRACT_IMAGE:int = 15;
    public const HEIGHT_CONTRACT_IMAGE:int = 15;
    public const NAME_BUTTON_CONTRACT1:String="К1";
    public const NAME_BUTTON_CONTRACT2:String="К2";
    public const PATH_START_CONTRACT:String  = "http://localhost:4567/startContract";
    public const PATH_GET_FACTORY_INCOME:String = "http://localhost:4567/getFactoryIncome";
    public var contract:int;
    var contract1:Sprite;
    var contract2:Sprite;
    var contract_sprite:Sprite;
    var visible_contract:Boolean = false;

    public function Factory(_x:Number, _y:Number,time:int, contract:int)
    {
        super(_x, _y,time, contract);
        path=Global.PATH_FACTORY;
        build_type="factory";
        this.contract = contract;
        if (contract==0) {
            sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        }
        timer = new Timer(Global.TIME_TICK);
        launchTimer();
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
        CONTRACTS[1] ={profit:30,cost:5,time_work:300};
        CONTRACTS[2] = {profit:50,cost:10, time_work:900};
    }

    public override function launchTimer():void
    {
        if (contract!=0) {
            super.launchTimer();
        }
    }

    public override function getProfit(event:MouseEvent):void
    {
        if (Global.userOperation==false) {
            sprite.removeEventListener(MouseEvent.CLICK, getProfit);
            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y = _y;
            successGetProfit();
            HttpHelper.sendRequest(PATH_GET_FACTORY_INCOME, variables,function(data) {
                if (data!="true") {
                    Global.field.reCreateBuiling(Global.field.findBuilding(_x,_y),XML(data));
                    Global.coins.text = "Coins: " + ( Global.field.coins-=CONTRACTS[XML(data).@contract]["profit"]).toString();
                    Global.error_field.text = Global.error_array["profitFactory"];
                }
            });
        }
        Global.userOperation = false;
    }

    private function successGetProfit():void {
        Global.coins.text = "Coins: " + ( Global.field.coins+=CONTRACTS[contract]["profit"]).toString();
        resetFactoryProperties();
        Global. clearErrorField();
    }

    private function resetFactoryProperties():void
    {
        timer.reset();
        time = 0;
        contract = 0;
        state=Global.state["stand"];
        redraw();
        clearContract();
        sprite.addEventListener(MouseEvent.CLICK, chooseContract);
        visible_contract = false;
    }

    private function chooseContract(event:MouseEvent):void
    {
        if (contract==0 && Global.userOperation==false && !visible_contract ) {
            var myFormat:TextFormat = new TextFormat("Georgia",7);
            contract1 = new Sprite();
            contract2 = new Sprite();
            var btn1:MyButton = new MyButton(_x * Global.CELL_SIZE, _y * Global.CELL_SIZE, WIDTH_BUTTON_CONTRACT, HEIGHT_BUTTON_CONTRACT, NAME_BUTTON_CONTRACT1, myFormat);
            var btn2:MyButton = new MyButton(_x * Global.CELL_SIZE + OFFSET_BUTTON_CONTRACT, _y * Global.CELL_SIZE, WIDTH_BUTTON_CONTRACT, HEIGHT_BUTTON_CONTRACT, NAME_BUTTON_CONTRACT2, myFormat);
            contract1.addChild(btn1);
            contract2.addChild(btn2);
            sprite.addChild(contract1);
            sprite.addChild(contract2);
            contract1.addEventListener(MouseEvent.CLICK, chooseContract1);
            contract2.addEventListener(MouseEvent.CLICK, chooseContract2);

        }
        Global.userOperation=false;
    }

    private function chooseContract1(event:MouseEvent):void
    {
            clearContractButtons();
            startContract(1);
    }

    private function chooseContract2(event:MouseEvent):void
    {
            clearContractButtons();
            startContract(2);
    }

    private function  startContract( number:int):void
    {
        var variables:URLVariables = new URLVariables();
        variables.contract=number;
        variables.x = _x;
        variables.y=_y;
        successStartContract(number);
        HttpHelper.sendRequest(PATH_START_CONTRACT, variables,function(data) {
            if (data!="true") {
                Global.field.reCreateBuiling(Global.field.findBuilding(_x,_y),XML(data));
                Global.error_field.text = Global.error_array["startContract"];
                Global.coins.text = "Coins: " + ( Global.field.coins += CONTRACTS[number]["cost"]).toString();
            }
        });
    }

    private function successStartContract(number:int):void
    {
        contract = number;
        time = CONTRACTS[contract]["time_work"];
        Global.coins.text = "Coins: " + ( Global.field.coins -= CONTRACTS[contract]["cost"]).toString();
        launchTimer();
        drawContract();
        Global. clearErrorField();
    }

    public override  function draw():void
    {
        drawContract();
        super.draw();
    }

    private function drawContract():void
    {
        if (contract==1) {
            contract_sprite = new Viewer(Global.PATH_CONTRACT1,_x*Global.CELL_SIZE, _y*Global.CELL_SIZE,WIDTH_CONTRACT_IMAGE,HEIGHT_CONTRACT_IMAGE);
            sprite.addChild(contract_sprite);
        }
        else if (contract==2) {
            contract_sprite = new Viewer(Global.PATH_CONTRACT2,_x*Global.CELL_SIZE, _y*Global.CELL_SIZE,WIDTH_CONTRACT_IMAGE,HEIGHT_CONTRACT_IMAGE);
            sprite.addChild(contract_sprite);
        }
    }

    private function clearContract():void
    {
        sprite.removeChild(contract_sprite);
    }

    public override function move(index:int,new_x:int,new_y:int):void
    {
        super.move(index,new_x,new_y);
         if (contract==0) sprite.addEventListener(MouseEvent.CLICK, chooseContract); else
             drawContract();
    }

    private function clearContractButtons():void
    {
        sprite.removeEventListener(MouseEvent.CLICK, chooseContract);
        if  (sprite.contains(contract1))
          sprite.removeChild(contract1);
        if  (sprite.contains(contract2))
        sprite.removeChild(contract2);
        visible_contract = true;
    }
}
}
