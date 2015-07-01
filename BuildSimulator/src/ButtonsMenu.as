
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLVariables;
import flash.text.TextFormat;
import flash.ui.Mouse;
public class ButtonsMenu {
    public static const BUTTON_WIDTH:int = 57;
    public static const BUTTON_HEIGHT:int=20;
    public static const BUTTON_OFFSET:int = 10;
    public static const COUNT_BUTTONS:int=4;
    public const BUTTON_FONT_SIZE:int=13;
    public const COEFF1:Number = 0.8556;
    public const COEFF2:Number = 0.7492;
    public const PATH_ADD_BUILDING:String = "http://localhost:4567/addBuilding";
    public const PATH_MOVE_BUILDING:String = "http://localhost:4567/moveBuilding";
    public const PATH_REMOVE_BUILDING:String = "http://localhost:4567/removeBuilding";
    var myformat:TextFormat = new TextFormat("Georgia",BUTTON_FONT_SIZE);
    var names_button = ["Shop","Factory","Move","Remove"];
    var type_cost:Array=[]
    var btnAddShop:MyButton;
    var btnAddFactory:MyButton;
    var btnMove:MyButton;
    var btnSell:MyButton;
    var buttons:Array = new Array(btnAddShop, btnAddFactory,btnMove,btnSell);
    var listeners:Array = new Array(btnAddShopListener,btnAddFactoryListener,btnMoveListener,btnSellListener);
    var stage:Stage;
    var cursor:Sprite;
    var functiononClick:Function;
    var index:int;
    public function ButtonsMenu( stage:Stage)
    {
        this.stage=stage;
        Global.setCoinsLabel();
        Global.setErrorsLabel();
        setButtonList();
        type_cost["factory"] = Factory.COST_FACTORY;
        type_cost["auto_workshop"] = Workshop.COST_WORKSHOP;
    }

    private  function setButtonList():void
    {
        for (var i:int=0; i < names_button.length; i++) {
            buttons[i] = new MyButton(Field.FIELD_WIDTH+BUTTON_OFFSET,i*BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT,names_button[i],myformat);
            buttons[i].addEventListener(MouseEvent.CLICK,listeners[i]);
            stage.addChild(buttons[i]);
        }
    }

    private function btnAddShopListener(event:MouseEvent):void
    {
            Mouse.hide();
            var p:String =Global.CURSOR_FOR_SHOP ;
            cursor =  new CustomCursor(p, Global.field);
            functiononClick = createBuilding("auto_workshop",type_cost["auto_workshop"]);
            Global.field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
    }

    private function btnAddFactoryListener(event:MouseEvent):void
    {
            Mouse.hide();
            var p:String =Global.CURSOR_FOR_FACTORY ;
            cursor =  new CustomCursor(p, Global.field);
            functiononClick = createBuilding("factory",type_cost["factory"]);
            Global.field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
    }

    private function createBuilding(type:String, cost:int):Function
    {
        return function (event:MouseEvent):void {
            var x:int = Math.floor(stage.mouseX / Global.CELL_SIZE);
            var y:int = Math.floor(stage.mouseY / Global.CELL_SIZE);
            if ( insideField(event.stageX, event.stageY)) {
                {
                    Global.field.field_sprite.removeEventListener(MouseEvent.CLICK, functiononClick);
                    Global.userOperation = false;
                    Mouse.show();
                    Global.field.field_sprite.removeChild(cursor);
                    var variables:URLVariables = new URLVariables();
                    variables.y = y;
                    variables.x = x;
                    variables.type = type;
                    successAdd(x,y,type,cost);
                    HttpHelper.sendRequest(PATH_ADD_BUILDING, variables, function(data) {
                       if (data=="false")
                       {
                           Global.coins.text = "Coins: " + ( Global.field.coins += cost).toString();
                           wrongAdd();
                       }
                    });
                }
            }
        }
    }

    public function  successAdd(x:int,y:int,type:String,cost:int):void
    {
        var time:int = (type!="factory")?Workshop.TIME_WORKING:0;
        Global.field.addBuilding(Global.field.getObject(type,x,y,time,0));
        Global.coins.text = "Coins: " + ( Global.field.coins -= cost).toString();
        Global. clearErrorField();
    }
    public function wrongAdd():void
    {
        var position:int =  Global.field.buildings.length-1;
        Global.field.buildings[position].remove(position);
        Global.error_field.text=Global.error_array["add"];
    }

    private function btnMoveListener(event:MouseEvent):void
    {
        for(var i:int = 0; i <  Global.field.buildings.length; i++) {
            Global.field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        Global.userOperation=true;
    }

    private function downHandler(event:MouseEvent):void
    {
        index =  Global.field.findBuilding(Math.floor(stage.mouseX / Global.CELL_SIZE), Math.floor(stage.mouseY / Global.CELL_SIZE));
        if (index!=-1) {
            Global.field.buildings[index].sprite.startDrag(false,
                    new Rectangle(
                            - Global.field.buildings[index]._x*Global.CELL_SIZE-Global.CELL_SIZE,
                            - Global.field.buildings[index]._y*Global.CELL_SIZE-Global.CELL_SIZE,
                            Field.FIELD_WIDTH,
                            Field.FIELD_HEIGHT));
            Global.field.buildings[index].sprite.addEventListener(MouseEvent.MOUSE_UP,up);
        }
    }

    private function up(event:MouseEvent):void
    {
        var _x:int = Global.field.buildings[index]._x;
        var _y:int = Global.field.buildings[index]._y;
        if (insideField(event.stageX, event.stageY)) {
            var new_x:Number = Math.floor(stage.mouseX / Global.CELL_SIZE);
            var new_y:Number = Math.floor(stage.mouseY / Global.CELL_SIZE);
            event.currentTarget.stopDrag();
            Global.field.buildings[index].sprite.removeEventListener(MouseEvent.MOUSE_UP, up);
            for (var i:int = 0; i < Global.field.buildings.length; i++) {
                Global.field.buildings[i].sprite.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            }
            var variables:URLVariables = new URLVariables();
            variables.new_x = new_x;
            variables.new_y = new_y;
            variables.x = _x;
            variables.y = _y;
            Global.field.buildings[index].move(index, new_x, new_y);
            Global.clearErrorField();
            HttpHelper.sendRequest(PATH_MOVE_BUILDING, variables, function (data) {
                if (data != "true") {
                   Global.field.reCreateBuiling(index,XML(data));
                    Global.error_field.text = Global.error_array["move"];
                }
            });
        }
        else
        {
            Global.field.buildings[index].move(index, _x, _y);
            Global.error_field.text = Global.error_array["move"];
        }
    }

    private function btnSellListener(event:MouseEvent):void
    {
        for(var i:int = 0; i <  Global.field.buildings.length; i++) {
            Global.field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
        Global.userOperation=true;
    }

    private function removeBuilding(event:MouseEvent):void
    {
        var search_building:int = Global.field.findBuilding(Math.floor(stage.mouseX/Global.CELL_SIZE),Math.floor(stage.mouseY/Global.CELL_SIZE));
            for(var i:int = 0; i <  Global.field.buildings.length; i++) {
                Global.field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
            var variables:URLVariables = new URLVariables();
            variables.x= Global.field.buildings[search_building]._x;
            variables.y= Global.field.buildings[search_building]._y;
            successRemove(search_building);
            HttpHelper.sendRequest(PATH_REMOVE_BUILDING, variables, function(data) {
              if (data!="true") {
                wrongRemove(data,search_building)
              }
            });
    }
    private function wrongRemove(data:String,search_building:int):void
    {
        Global.coins.text = "Coins: " + ( Global.field.coins-=type_cost[Global.field.buildings[search_building].build_type]/2).toString();
        Global.field.addBuilding(Global.field.createBuidlingByXML(XML(data)));
        Global.error_field.text = Global.error_array["remove"];
    }

    private function successRemove(search_building:int):void {
        Global.field.buildings[search_building].remove(search_building);
        Global.coins.text = "Coins: " + ( Global.field.coins+=type_cost[Global.field.buildings[search_building].build_type]/2).toString();
        Global. clearErrorField();
    }

    //dummy to enter into field
    private function insideField(x:int, y:int):Boolean
    {
        var w:Number = COEFF1*Field.FIELD_WIDTH;
        var h:Number = COEFF2*Field.FIELD_HEIGHT;
        var a:Number= 0.5*w;
        var b:Number = 0.5*h;
        var centerX:Number = Field.FIELD_WIDTH/2;
        var centerY:Number = Field.FIELD_HEIGHT/2;
        return Math.abs(x-centerX)/a+Math.abs(y-centerY)/b<=0.8;
    }
}
}
