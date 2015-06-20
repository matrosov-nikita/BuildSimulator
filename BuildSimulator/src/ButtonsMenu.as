
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.system.Security;
import flash.text.TextFormat;
import flash.ui.Mouse;

public class ButtonsMenu {

    public const button_width:int = 57;
    public const button_height:int=20;
    public const factory_cost:int = 30;
    public const  shop_cost:int = 20;
    public const cell_size:int = 50;
    var myformat:TextFormat = new TextFormat("Georgia",13);
    var btnAddShop:MyButton;
    var btnAddFactory:MyButton;
    var btnMove:MyButton;
    var btnSell:MyButton;
    var btnSave:MyButton;

    var field:Field;
    var stage:Stage;
    var cursor:Sprite;
    public function ButtonsMenu(field:Field, stage:Stage) {
        this.field=field;
        this.stage=stage;
        btnAddShop= new MyButton(this.field.field_width+10,0,button_width,button_height,"Shop",myformat);
        btnAddFactory= new MyButton(this.field.field_width+10 +button_width ,0,button_width,button_height,"Factory",myformat);
        btnMove = new MyButton(this.field.field_width+10,button_height,button_width,button_height, "Move",myformat);
        btnSell = new MyButton(this.field.field_width+10,2*button_height,button_width,button_height, "Remove",myformat);
        btnSave = new MyButton(this.field.field_width+10,3*button_height,button_width,button_height, "Save",myformat);
        Global.coins.x = this.field.field_width+10;
        Global.coins.y = field.field_height;
        Global.coins.border=true;
        Global.coins.borderColor=0xCCFF00;
        Global.coins.height = button_height;

        stage.addChild (btnAddShop);
        stage.addChild(btnAddFactory);
        stage.addChild(btnMove);
        stage.addChild(btnSell);
        stage.addChild(btnSave);
        btnAddShop.addEventListener(MouseEvent.CLICK, btn1Listener);
        btnAddFactory.addEventListener(MouseEvent.CLICK, btn2Listener);
        btnMove.addEventListener(MouseEvent.CLICK, btn3Listener);
        btnSell.addEventListener(MouseEvent.CLICK, btn4Listener);
        btnSave.addEventListener(MouseEvent.CLICK, btn5Listener);

    }

    private function btn1Listener(event:MouseEvent):void {
        if (field.coins>=20) {
            Mouse.hide();
            var p:String = "http://localhost:8090/images/auto_workshop.png";
            cursor =  new CustomCursor(p,field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation = true;
        }
    }

    private function btn2Listener(event:MouseEvent):void {
        if (field.coins>=30) {
            //Mouse.hide();
            var p:String = "http://localhost:8090/images/factory.png";
            cursor =  new CustomCursor(p,field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation = true;
        }
    }

    private function addFactory(event:MouseEvent):void {

        var x:int = Math.floor(stage.mouseX / cell_size);
        var y:int = Math.floor(stage.mouseY / cell_size);
        if (field.find_building(x, y) == -1 && insideField(event.stageX,event.stageY)) {
            {
                Global.coins.text = "Coins: " + (field.coins -= factory_cost).toString();
                field.field_sprite.removeEventListener(MouseEvent.CLICK, addFactory);
                Global.userOperation = false;
                Mouse.show();
                field.field_sprite.removeChild(cursor);
                var variables:URLVariables = new URLVariables();
                variables.id = ++Global.countInstances;
                Global.currentBuilding = Global.countInstances;
                variables.y = y;
                variables.x = x;
                variables.type = "factory";
                variables.time = 0;
                variables.contract=0;
                sendRequest('http://localhost:8090/add', variables);

            }
        }
    }


    private function addShop(event:MouseEvent):void {
        var x:int = Math.floor(stage.mouseX/cell_size);
        var y:int = Math.floor(stage.mouseY/cell_size);
        if (field.find_building(x,y)==-1 && insideField(event.stageX,event.stageY)) {

            Global.coins.text = "Coins: " + (field.coins -= shop_cost).toString();
            trace(field.coins);
            field.field_sprite.removeEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation = false;
            Mouse.show();
            field.field_sprite.removeChild(cursor);
            var variables:URLVariables = new URLVariables();
            variables.id = ++Global.countInstances;
            Global.currentBuilding = Global.countInstances;
            variables.y = y;
            variables.x = x;
            variables.type = "auto_workshop";
            variables.time = 0;
            sendRequest('http://localhost:8090/add', variables);
        }

    }

    private function btn3Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        Global.userOperation=true;
    }

    private function downHandler(event:MouseEvent):void {

        var search_index:int = field.find_building(event.target.x/cell_size, event.target.y/cell_size);
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
            var search_index:int = field.find_building(_x, _y);
            event.currentTarget.stopDrag();
            for (var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
            }
            field.buildings[search_index].sprite.removeEventListener(MouseEvent.MOUSE_UP, up);
            var new_x:Number = Math.floor(stage.mouseX / cell_size);
            var new_y:Number = Math.floor(stage.mouseY / cell_size);
            var variables:URLVariables = new URLVariables();
            variables.y = new_y;
            variables.x = new_x;
            variables.id = field.buildings[search_index].id;
            Global.currentBuilding = field.buildings[search_index].id;
            sendRequest('http://localhost:8090/move', variables);
//        field.buildings[search_index]._x = Math.floor(stage.mouseX/cell_size);
//        field.buildings[search_index]._y=Math.floor(stage.mouseY/cell_size);
            //  sendRequest();
        }
    }

    private function btn4Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
        Global.userOperation=true;
    }

    private function removeBuilding(event:MouseEvent):void {

        var search_building:int =field.find_building(Math.floor(stage.mouseX/cell_size),Math.floor(stage.mouseY/cell_size));
        if (search_building == -1) {
            trace("Building doesn't exist");
        }
        else {
            var compensation:int = ((field.buildings[search_building].build_type=="factory")?factory_cost/2:shop_cost/2);
            Global.coins.text = "Coins: " + (field.coins+=compensation).toString();
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
            var variables:URLVariables = new URLVariables();
            variables.id=field.buildings[search_building].id;
            Global.currentBuilding = field.buildings[search_building].id;
            sendRequest('http://localhost:8090/remove', variables);
        }
    }

    private function sendRequest(url,variables):void {
        var url:String = url;
        var request:URLRequest = new URLRequest(url);
        variables.xml =field.convertToXML().toXMLString();
        request.data = variables;
        request.contentType="text/xml";
        var loader:URLLoader = new URLLoader();
        loader.load(request);
        loader.addEventListener(Event.COMPLETE, function onComplete() {
            var xml:XML = XML(loader.data);
            if (xml.name()=="field")
                field.drawField(xml);
        });

    }
    private function btn5Listener(event:MouseEvent):void {
        var variables:URLVariables = new URLVariables();
        variables.xml = field.convertToXML().toXMLString();
        sendRequest('http://localhost:8090/', variables);
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
