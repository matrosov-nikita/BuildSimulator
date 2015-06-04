/**
 * Created by nik on 20.05.15.
 */
package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;



public class Test extends  Sprite{

    var  field:Field;
    var myformat:TextFormat = new TextFormat("Georgia",13);

   var btnAddShop:MyButton = new MyButton(510,0,50,20,"Shop",myformat);
    var btnAddFactory:MyButton = new MyButton(561,0,50,20,"Factory",myformat);
    var btnMove:MyButton = new MyButton(510,25,50,20, "Move",myformat);
    var btnSell:MyButton = new MyButton(510,50,50,20, "Remove",myformat);

    var coins:TextField = new TextField();
    private var info: XML = <field coins="50">
        <auto_workshop x="5" y="2" time="234234"/>

        <factory x="6" y="1" contract="1" time="234234"/>
        <factory x="3" y="0" contract="2" time="234234"/>

        <factory x="4" y="0" contract="1" time="234234"/>
        <factory x="9" y="5" contract="2" time="Ё"/>
    </field>;
    public function Test() {
        stage.align = StageAlign.TOP_LEFT;
   //     stage.scaleMode = StageScaleMode.NO_SCALE;
        field = new Field(info,this);
        field.draw();
        addChild (btnAddShop);
        addChild(btnAddFactory);
        addChild(btnMove);
        addChild(btnSell);
        coins.x = 650;
        coins.text = "Coins: " + field.coins.toString();
        coins.selectable=false;
        addChild(coins);

        btnAddShop.addEventListener(MouseEvent.CLICK, btn1Listener);
        btnAddFactory.addEventListener(MouseEvent.CLICK, btn2Listener);
        btnMove.addEventListener(MouseEvent.CLICK, btn3Listener);
        btnSell.addEventListener(MouseEvent.CLICK, btn4Listener);
    }

    //добавление здания
    //---------------------------------------------------------
    private function btn1Listener(event:MouseEvent):void {

        field.field_sprite.buttonMode=true;
        field.field_sprite.addEventListener(MouseEvent.CLICK, addShop);
    }
    private function btn2Listener(event:MouseEvent):void {
        field.field_sprite.buttonMode=true;
        field.field_sprite.addEventListener(MouseEvent.CLICK, addFactory);
    }

    private function addFactory(event:MouseEvent):void {
        trace(event.localX, event.localY);
        var x:int = Math.floor(event.localX/50);
        var y:int = Math.floor(event.localY/50);

        field.addNewBuilding(x,y,"factory",this);
        field.coins-=30;

        coins.text = "Coins: " + field.coins.toString();
        field.field_sprite.buttonMode=false;
        field.field_sprite.removeEventListener(MouseEvent.CLICK, addFactory);
    }

    private function addShop(event:MouseEvent):void {
       // trace(building_type);

        trace(Math.floor(event.localX/50),Math.floor(event.localY/50) );
        var x:int = Math.floor(event.localX/50);
        var y:int = Math.floor(event.localY/50);

            field.addNewBuilding(x,y,"auto_workshop",this);
            field.coins-=20;


        coins.text = "Coins: " + field.coins.toString();
        field.field_sprite.buttonMode=false;
        field.field_sprite.removeEventListener(MouseEvent.CLICK, addShop);
    }
//------------------------------------------------------------------------


    //перемещение здания
    //-------------------------------------------------------------------
    private function btn3Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
        }
    }

    private function downHandler(event:MouseEvent):void {

     var search_index:int = field.find_building(event.target.x/50, event.target.y/50);
        if (search_index!=-1) {
            field.buildings[search_index].sprite.startDrag(false);

            field.buildings[search_index].sprite.addEventListener(MouseEvent.MOUSE_UP,up);
        }
    }

    private function up(event:MouseEvent):void {


        var _x:int = event.target.x/50;
        var _y:int =  event.target.y/50;
        var search_index:int = field.find_building(_x, _y);

        event.currentTarget.stopDrag();
        field.buildings[search_index]._x=Math.floor(stage.mouseX/50);
      field.buildings[search_index]._y=Math.floor(stage.mouseY/50);

       for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
      }
       field.buildings[search_index].sprite.removeEventListener(MouseEvent.MOUSE_UP,up);
        field.field_sprite.removeChild( field.buildings[search_index].sprite);
        field.buildings[search_index].Draw();
      //  field.buildings[search_index].Redraw();
    }
//-------------------------------------------------------------------------------------------


//удаление здания
    //--------------------------------------------------------------------------------
    private function btn4Listener(event:MouseEvent):void {
        for(var i:int = 0; i < field.buildings.length; i++) {
            field.buildings[i].sprite.addEventListener(MouseEvent.CLICK, removeBuilding);
        }
    }

    private function removeBuilding(event:MouseEvent):void {

      var search_building:int =field.find_building(event.target.x/50,event.target.y/50 );
        if (search_building == -1) {
            trace("Building isn't existed");
        }
        else {
            field.coins+=50;
            coins.text = "Coins: " + field.coins.toString();
            field.remove_building(search_building);
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }

        }
    }
//----------------------------------------------------------------------------------------
}
}
