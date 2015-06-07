/**
 * Created by Пользователь on 07.06.2015.
 */
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.text.TextFormat;

public class ButtonsMenu {

    public const button_width:int = 50;
    public const button_height:int=20;
    public const factory_cost:int = 30;
    public const  shop_cost:int = 20;

    var myformat:TextFormat = new TextFormat("Georgia",13);
    var btnAddShop:MyButton;
    var btnAddFactory;
    var btnMove:MyButton;
    var btnSell:MyButton;

    var field:Field;
    var stage:Stage;
    public function ButtonsMenu(field:Field, stage:Stage) {
        this.field=field;
        this.stage=stage;

        btnAddShop= new MyButton(this.field.field_width+10,0,button_width,button_height,"Shop",myformat);
        btnAddFactory= new MyButton(this.field.field_width+10 +button_width ,0,button_width,button_height,"Factory",myformat);
        btnMove = new MyButton(this.field.field_width+10,button_height+5,button_width,button_height, "Move",myformat);
        btnSell = new MyButton(this.field.field_width+10,2*button_height+10,button_width,button_height, "Remove",myformat);

        stage.addChild (btnAddShop);
        stage.addChild(btnAddFactory);
        stage.addChild(btnMove);
        stage.addChild(btnSell);
        btnAddShop.addEventListener(MouseEvent.CLICK, btn1Listener);
        btnAddFactory.addEventListener(MouseEvent.CLICK, btn2Listener);
        btnMove.addEventListener(MouseEvent.CLICK, btn3Listener);
        btnSell.addEventListener(MouseEvent.CLICK, btn4Listener);
    }
//добавление здания
    //---------------------------------------------------------
    private function btn1Listener(event:MouseEvent):void {
        if (field.coins>=20) {
            field.field_sprite.buttonMode = true;
            field.field_sprite.addEventListener(MouseEvent.CLICK, addShop);
            Global.userOperation = true;
        }
    }
    private function btn2Listener(event:MouseEvent):void {
        if (field.coins>=30) {
            field.field_sprite.buttonMode = true;
            field.field_sprite.addEventListener(MouseEvent.CLICK, addFactory);
            Global.userOperation = true;
        }
    }

    private function addFactory(event:MouseEvent):void {
        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);

        field.addNewBuilding(x,y,"factory",stage);
        Global.coins.text = "Coins: " + (field.coins-=factory_cost).toString();


        field.field_sprite.buttonMode=false;
        field.field_sprite.removeEventListener(MouseEvent.CLICK, addFactory);
        Global.userOperation=false;
    }

    private function addShop(event:MouseEvent):void {
        var x:int = Math.floor(stage.mouseX/50);
        var y:int = Math.floor(stage.mouseY/50);

        field.addNewBuilding(x,y,"auto_workshop",stage);
        Global.coins.text = "Coins: " + (field.coins-=shop_cost).toString();

        field.field_sprite.buttonMode=false;
        field.field_sprite.removeEventListener(MouseEvent.CLICK, addShop);
        Global.userOperation=false;
    }
//------------------------------------------------------------------------


    //перемещение здания
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
            field.buildings[search_index].sprite.startDrag(false);

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

        field.field_sprite.removeChild( field.buildings[search_index].sprite);
        field.buildings[search_index].sprite=new Sprite();
        field.buildings[search_index]._x = Math.floor(stage.mouseX/50);
        field.buildings[search_index]._y=Math.floor(stage.mouseY/50);
        field.draw();

    }
//-------------------------------------------------------------------------------------------


//удаление здания
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
            Global.coins.text = "Coins: " + (field.coins+=compensation).toString();

            field.remove_building(search_building);
            for(var i:int = 0; i < field.buildings.length; i++) {
                field.buildings[i].sprite.removeEventListener(MouseEvent.CLICK, removeBuilding);
            }

        }

    }
}
}
