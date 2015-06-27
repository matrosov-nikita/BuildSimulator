
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.text.TextColorType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.utils.Dictionary;

public class ButtonsMenu {
    public const button_width:int = 57;
    public const button_height:int=20;
    public const cell_size:int = 50;
    public const cost_workshop:int=20;
    public const cost_factory:int=30;
    public const button_font_size:int=13;
    public const button_offset:int = 10;
    public const cursor_for_shop:String ="http://localhost:4567/auto_workshop.png";
    public const cursor_for_factory:String="http://localhost:4567/factory.png";
    public const path_add_building = "http://localhost:4567/addBuilding";
    public const path_move_building = "http://localhost:4567/moveBuilding";
    public const path_remove_building = "http://localhost:4567/removeBuilding"
    var myformat:TextFormat = new TextFormat("Georgia",button_font_size);
    var names_button = ["Shop","Factory","Move","Remove"];
    var btnAddShop:MyButton;
    var btnAddFactory:MyButton;
    var btnMove:MyButton;
    var  btnSell:MyButton;
    var buttons:Array = new Array(btnAddShop, btnAddFactory,btnMove,btnSell);
    var listeners:Array = new Array(btnAddShopListener,btnAddFactoryListener,btnMoveListener,btnSellListener);
    var field:Field;
    var stage:Stage;
    var cursor:Sprite;
    var functiononClick:Function;
    public function ButtonsMenu(field:Field, stage:Stage) {
        this.field=field;
        this.stage=stage;
        setCoinsLabel();
        setErrorsLabel();
        setButtonList();
    }

    private function setErrorsLabel():void {
        Global.error_field.x = this.field.field_width+button_offset;
        Global.error_field.y = (buttons.length+1)*button_height;
        Global.error_field.width=150;
        Global.error_field.textColor= 0xFF0000;
        Global.error_field.wordWrap=true;
    }
    private function setCoinsLabel():void {
        Global.coins.x = this.field.field_width+button_offset;
        Global.coins.y = field.field_height;
        Global.coins.border=true;
        Global.coins.borderColor=0xCCFF00;
        Global.coins.height = button_height;
    }

    private  function setButtonList():void {
        for (var i:int=0; i < names_button.length; i++) {
            buttons[i] = new MyButton(this.field.field_width+button_offset,i*button_height,button_width,button_height,names_button[i],myformat);
            buttons[i].addEventListener(MouseEvent.CLICK,listeners[i]);
            stage.addChild(buttons[i]);
        }
    }

    private function btnAddShopListener(event:MouseEvent):void {
            Mouse.hide();
            var p:String =cursor_for_shop ;
            cursor =  new CustomCursor(p,field);
            functiononClick = createBuilding("auto_workshop",cost_workshop);
            field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
    }

    private function btnAddFactoryListener(event:MouseEvent):void {
            Mouse.hide();
            var p:String =cursor_for_factory ;
            cursor =  new CustomCursor(p,field);
            functiononClick = createBuilding("factory",cost_factory);
            field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
    }

    private function createBuilding(type:String, cost:int):Function {
        return function (event:MouseEvent):void {
            var x:int = Math.floor(stage.mouseX / cell_size);
            var y:int = Math.floor(stage.mouseY / cell_size);
            if ( insideField(event.stageX, event.stageY)) {
                {
                    field.field_sprite.removeEventListener(MouseEvent.CLICK, functiononClick);
                    Global.userOperation = false;
                    Mouse.show();
                    field.field_sprite.removeChild(cursor);
                    var variables:URLVariables = new URLVariables();
                    variables.y = y;
                    variables.x = x;
                    variables.type = type;
                    HttpHelper.sendRequest(path_add_building, variables, function(data) {
                       if (data=="true") {
                           var time:int = (type!="factory")?Workshop.time_working:0;
                           field.addBuidling(type,x,y,time,0);
                           Global.coins.text = "Coins: " + (field.coins -= cost).toString();
                       }
                        else
                       {
                           Global.error_field.text=Global.error_array["add"];
                       }
                    });
                }
            }
        }
    }

    private function btnMoveListener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        Global.userOperation=true;
    }

    private function downHandler(event:MouseEvent):void {
        var search_index:int = field.findBuilding(event.target.x/cell_size, event.target.y/cell_size);
        if (search_index!=-1) {
            field.buildings[search_index].sprite.startDrag(false,
                    new Rectangle(
                            -field.buildings[search_index]._x*cell_size-cell_size,
                            -field.buildings[search_index]._y*cell_size-cell_size,
                            field.field_width,
                            field.field_height));
            field.buildings[search_index].sprite.addEventListener(MouseEvent.MOUSE_UP,up);
        }
    }

    private function up(event:MouseEvent):void {

        var _x:int = event.target.x / cell_size;
        var _y:int = event.target.y / cell_size;
        if (insideField(event.stageX, event.stageY)) {
            var search_index:int = field.findBuilding(_x, _y);
            event.currentTarget.stopDrag();
            for (var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            }
            field.buildings[search_index].sprite.removeEventListener(MouseEvent.MOUSE_UP, up);
            var new_x:Number = Math.floor(stage.mouseX / cell_size);
            var new_y:Number = Math.floor(stage.mouseY / cell_size);
            var variables:URLVariables = new URLVariables();
            variables.new_x = new_x;
            variables.new_y = new_y;
            variables.x = _x;
            variables.y = _y;
            HttpHelper.sendRequest(path_move_building, variables,function(data) {
                if (data=="true") {
                    field.buildings[search_index].move(search_index,new_x,new_y);
                }
                else {
                    Global.error_field.text = Global.error_array["move"]
                }
            });
        }
    }

    private function btnSellListener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
        Global.userOperation=true;
    }

    private function removeBuilding(event:MouseEvent):void {

        var search_building:int =field.findBuilding(Math.floor(stage.mouseX/cell_size),Math.floor(stage.mouseY/cell_size));
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
            var variables:URLVariables = new URLVariables();
            variables.x=field.buildings[search_building]._x;
            variables.y=field.buildings[search_building]._y;
            HttpHelper.sendRequest(path_remove_building, variables, function(data) {
              if (data=="true") {
                  field.buildings[search_building].remove(search_building);
                  var compensation:int = ((field.buildings[search_building].build_type=="factory")?cost_factory/2:cost_workshop/2);
                  Global.coins.text = "Coins: " + (field.coins+=compensation).toString();
              }
                else {
                  Global.error_field.text = Global["remove"];
              }
            });
    }

    private function insideField(x:int, y:int):Boolean {
        var w:Number = 0.8556*field.field_width;
        var h:Number = 0.7492*field.field_height;
        var a:Number= 0.5*w;
        var b:Number = 0.5*h;
        var centerX:Number = field.field_width/2;
        var centerY:Number = field.field_height/2;
        return Math.abs(x-centerX)/a+Math.abs(y-centerY)/b<=0.9;

    }
}
}
