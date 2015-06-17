
package {
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

    var myformat:TextFormat = new TextFormat("Georgia",13);
    var btnAddShop:MyButton;
    var btnAddFactory:MyButton;
    var btnMove:MyButton;
    var btnSell:MyButton;
    var btnSave:MyButton;

    var field:Field;
    var stage:Stage;
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
            new CustomCursor(p,field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation = true;
        }
    }

    private function btn2Listener(event:MouseEvent):void {
        if (field.coins>=30) {
            Mouse.hide();
            var p:String = "http://localhost:8090/images/factory.png";
            new CustomCursor(p,field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation = true;
        }
    }

    private function addFactory(event:MouseEvent):void {

        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);
        if (field.addNewBuilding(x,y,"factory")==0)
        {
            Global.coins.text = "Coins: " + (field.coins-=factory_cost).toString();
            field.field_sprite.buttonMode=false;
            field.field_sprite.removeEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation=false;
            Mouse.show();
        }
        sendRequest();
    }


    private function addShop(event:MouseEvent):void {
        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);
        if (field.addNewBuilding(x,y,"auto_workshop")==0)
        {

            Global.coins.text = "Coins: " + (field.coins-=shop_cost).toString();
            field.field_sprite.removeEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation=false;
            Mouse.show();
        }

        sendRequest();
    }

    private function btn3Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        Global.userOperation=true;
    }

    private function downHandler(event:MouseEvent):void {

        var search_index:int = field.find_building(event.target.x/50, event.target.y/50);
        if (search_index!=-1) {
            field.buildings[search_index].sprite.startDrag(false,new Rectangle(-field.buildings[search_index]._x*50-50,-field.buildings[search_index]._y*50-50,550,350));
            field.buildings[search_index].sprite.addEventListener(MouseEvent.MOUSE_UP,up);
        }
    }

    private function up(event:MouseEvent):void {

        var _x:int = event.target.x/50;
        var _y:int =  event.target.y/50;
        var search_index:int = field.find_building(_x, _y);
        event.currentTarget.stopDrag();
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
        field.buildings[search_index].sprite.removeEventListener(MouseEvent.MOUSE_UP,up);
        field.buildings[search_index]._x = Math.floor(stage.mouseX/50);
        field.buildings[search_index]._y=Math.floor(stage.mouseY/50);
        sendRequest();
    }

    private function btn4Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
        Global.userOperation=true;
    }

    private function removeBuilding(event:MouseEvent):void {

        var search_building:int =field.find_building(Math.floor(stage.mouseX/50),Math.floor(stage.mouseY/50));
        if (search_building == -1) {
            trace("Building doesn't exist");
        }
        else {
            var compensation:int = ((field.buildings[search_building].build_type=="factory")?factory_cost/2:shop_cost/2);
            field.remove_building(search_building);
            Global.coins.text = "Coins: " + (field.coins+=compensation).toString();
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
            sendRequest();
        }
    }

    private function sendRequest():void {
       // Security.loadPolicyFile('http://localhost:8090/crossdomain.xml');
        var url:String = 'http://localhost:8090/';
        var request:URLRequest = new URLRequest(url);
        var variables:URLVariables = new URLVariables();
        variables.xml =field.convertToXML();
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
        sendRequest();
    }
}
}
