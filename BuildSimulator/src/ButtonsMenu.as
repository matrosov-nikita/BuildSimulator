
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.text.TextFormat;
import flash.ui.Mouse;

public class ButtonsMenu {
    public const button_width:int = 57;
    public const button_height:int=20;
    public const cell_size:int = 50;
    public const cost_workshop:int=20;
    public const cost_factory:int=30;
    var myformat:TextFormat = new TextFormat("Georgia",13);
    var btnAddShop:MyButton;
    var btnAddFactory:MyButton;
    var btnMove:MyButton;
    var btnSell:MyButton;
    var btnSave:MyButton;

    var field:Field;
    var stage:Stage;
    var cursor:Sprite;
    var functiononClick:Function;
    public function ButtonsMenu(field:Field, stage:Stage) {
        this.field=field;
        this.stage=stage;
        setButtonList();
        setCoinsLabel();
    }
    private function setCoinsLabel():void {
        Global.coins.x = this.field.field_width+10;
        Global.coins.y = field.field_height;
        Global.coins.border=true;
        Global.coins.borderColor=0xCCFF00;
        Global.coins.height = button_height;
    }

    private  function setButtonList():void {
        btnAddShop= new MyButton(this.field.field_width+10,0,button_width,button_height,"Shop",myformat);
        btnAddFactory= new MyButton(this.field.field_width+10 +button_width ,0,button_width,button_height,"Factory",myformat);
        btnMove = new MyButton(this.field.field_width+10,button_height,button_width,button_height, "Move",myformat);
        btnSell = new MyButton(this.field.field_width+10,2*button_height,button_width,button_height, "Remove",myformat);
        stage.addChild (btnAddShop);
        stage.addChild(btnAddFactory);
        stage.addChild(btnMove);
        stage.addChild(btnSell);
        btnAddShop.addEventListener(MouseEvent.CLICK, btn1Listener);
        btnAddFactory.addEventListener(MouseEvent.CLICK, btn2Listener);
        btnMove.addEventListener(MouseEvent.CLICK, btn3Listener);
        btnSell.addEventListener(MouseEvent.CLICK, btn4Listener);
    }
    private function btn1Listener(event:MouseEvent):void {
        if (field.coins>=cost_workshop) {
            Mouse.hide();
            var p:String = "http://localhost:4567/auto_workshop.png";
            cursor =  new CustomCursor(p,field);
            functiononClick = createBuilding("auto_workshop",cost_workshop);
            field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
        }
    }

    private function btn2Listener(event:MouseEvent):void {
        if (field.coins>=cost_factory) {
            //Mouse.hide();
            var p:String = "http://localhost:4567/factory.png";
            cursor =  new CustomCursor(p,field);
            functiononClick = createBuilding("factory",cost_factory);
            field.field_sprite.addEventListener(MouseEvent.CLICK, functiononClick);
            Global.userOperation = true;
        }
    }

    private function createBuilding(type:String, cost:int):Function {
        return function (event:MouseEvent):void {
            var x:int = Math.floor(stage.mouseX / cell_size);
            var y:int = Math.floor(stage.mouseY / cell_size);
            if ( insideField(event.stageX, event.stageY)) {
                {
                    Global.coins.text = "Coins: " + (field.coins -= cost).toString();
                    field.field_sprite.removeEventListener(MouseEvent.CLICK, functiononClick);
                    Global.userOperation = false;
                    Mouse.show();
                    field.field_sprite.removeChild(cursor);
                    var variables:URLVariables = new URLVariables();
                    variables.y = y;
                    variables.x = x;
                    variables.type = type;
                    HttpHelper.sendRequest2('http://localhost:4567/addBuilding', variables, function(data) {
                       if (data=="true") {
                           var time:int = (type!="factory")?Workshop.time_working:0;
                        field.addBuidling(type,x,y,time,0);
                       }
                    });
                }
            }
        }
    }

    private function btn3Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            trace("add");
            field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        Global.userOperation=true;
    }

    private function downHandler(event:MouseEvent):void {
    trace("зашли");
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
            HttpHelper.sendRequest2('http://localhost:4567/moveBuilding', variables,function(data) {
                if (data=="true") {
                    field.buildings[search_index].move(search_index,new_x,new_y);
                }
            });
        }
    }

    private function btn4Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
        Global.userOperation=true;
    }

    private function removeBuilding(event:MouseEvent):void {

        var search_building:int =field.findBuilding(Math.floor(stage.mouseX/cell_size),Math.floor(stage.mouseY/cell_size));
            var compensation:int = ((field.buildings[search_building].build_type=="factory")?cost_factory/2:cost_workshop/2);
            Global.coins.text = "Coins: " + (field.coins+=compensation).toString();
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
            var variables:URLVariables = new URLVariables();
            variables.x=field.buildings[search_building]._x;
            variables.y=field.buildings[search_building]._y;
            HttpHelper.sendRequest2('http://localhost:4567/removeBuilding', variables, function(data) {
              if (data=="true") {
                  field.buildings[search_building].remove(search_building);
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
