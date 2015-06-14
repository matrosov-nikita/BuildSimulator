/**
 * Created by ������������ on 07.06.2015.
 */
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;

import flash.events.MouseEvent;

import flash.geom.Rectangle;

import flash.net.XMLSocket;
import flash.system.Security;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class ButtonsMenu {

    public const button_width:int = 57;
    public const button_height:int=20;
    public const factory_cost:int = 30;
    public const  shop_cost:int = 20;

    var myformat:TextFormat = new TextFormat("Georgia",13);
    var btnAddShop:MyButton;
    var btnAddFactory;
    var btnMove:MyButton;
    var btnSell:MyButton;
    var btnSave:MyButton;

   public var socket:XMLSocket;
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
        stage.addChild (btnAddShop);
        stage.addChild(btnAddFactory);
        stage.addChild(btnMove);
        stage.addChild(btnSell);
        stage.addChild(btnSave);
        btnAddShop.addEventListener(MouseEvent.CLICK, btn1Listener);
        btnAddFactory.addEventListener(MouseEvent.CLICK, btn2Listener);
        btnMove.addEventListener(MouseEvent.CLICK, btn3Listener);
        btnSell.addEventListener(MouseEvent.CLICK, btn4Listener);
        Security.loadPolicyFile('xmlsocket://localhost:8080');
      socket = new XMLSocket();
        configureListeners(socket);
        socket.connect('localhost', 8080);
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(DataEvent.DATA, getData);

    }

    private function getData(event:DataEvent):void {
        trace(event.data);
       var xml:XML = XML(event.data);
       if (xml.name()=="field")
         field.draw(xml);
    }
//���������� ������
    //---------------------------------------------------------
    private function btn1Listener(event:MouseEvent):void {
        if (field.coins>=20) {
            Mouse.hide();
            new CustomCursor("auto_workshop.png",field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation = true;
        }


    }
    private function btn2Listener(event:MouseEvent):void {
        if (field.coins>=30) {
            Mouse.hide();
            new CustomCursor("factory.png",field);
            field.field_sprite.addEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation = true;
        }
    }

    private function addFactory(event:MouseEvent):void {

        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);
        if (field.addNewBuilding(x,y,"factory")==0)
        {
            socket.send(field.convert_to_xml()+"\n");
            Global.coins.text = "Coins: " + (field.coins-=factory_cost).toString();
            //socket.send("addBuilding\n");

            field.field_sprite.buttonMode=false;
            field.field_sprite.removeEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation=false;
            Mouse.show();
        }

    }



    private function addShop(event:MouseEvent):void {
        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);
        if (field.addNewBuilding(x,y,"auto_workshop")==0)
        {
            socket.send(field.convert_to_xml()+"\n");
            Global.coins.text = "Coins: " + (field.coins-=shop_cost).toString();
            field.field_sprite.removeEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation=false;
            Mouse.show();

        }
    }

    private function loLoad(event:Event):void {
        trace("cascawq");
    }

//------------------------------------------------------------------------


    //����������� ������
    //-------------------------------------------------------------------
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
//
//        field.field_sprite.removeChild( field.buildings[search_index].sprite);
//        field.buildings[search_index].sprite=new Sprite();

        field.buildings[search_index]._x = Math.floor(stage.mouseX/50);
        field.buildings[search_index]._y=Math.floor(stage.mouseY/50);
        socket.send(field.convert_to_xml()+"\n");
       // field.draw();

    }
//-------------------------------------------------------------------------------------------


//�������� ������
    //--------------------------------------------------------------------------------
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
            socket.send(field.convert_to_xml()+"\n");


            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }
          //  socket.send("removeBuilding\n");

        }

    }
}
}
