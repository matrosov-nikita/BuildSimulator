package {
import flash.display.Sprite;
import flash.display.Stage;

public class Field {
    public static const field_width:int = 550;
    public static const field_height:int = 350;
    public const start_coins:int = 70;
    public const path:String = "http://localhost:4567/field.jpg";
    public var buildings:Array;
    public var coins:int;
    public var field_sprite:Sprite;

    public function Field(stage:Stage) {
        coins = start_coins;
        buildings = new Array();
        field_sprite = new Sprite();
        field_sprite.addChild(new Viewer(path,0, 0, field_width, field_height));
        field_sprite.cacheAsBitmap=true;
        stage.addChild(field_sprite);
    }

    public function getObject(type: String):Object{
        var object_types:Object = {auto_workshop: Workshop, factory: Factory};
        return object_types[type]
    }

    public function addBuidling(type:String, x:int,y:int,time:int,contract:int=0):void
    {
       var object:Object = getObject(type);
        buildings.push(new object(x,y,this,time,contract));
        buildings[buildings.length-1].draw();
    }


    public function findBuilding(x:int, y:int):int
    {
        for(var i:int = 0; i < buildings.length; ++i)
        {
            if (buildings[i]._x==x && buildings[i]._y==y)
            {
                return i;
            }
        }
        return -1;
    }

    public function getField(xmlStr:XML):void {
        coins = xmlStr.@coins;
        Global.coins.text = "Coins: " + coins;
        trace(coins);
        for each(var child:XML in xmlStr.*) {
            var x:int = child.@x;
            var y:int = child.@y;
            var contract:int = child.@contract;
            var state:String = child.@state;
            var time:int = getTimeByState(state,contract);

            addBuidling(child.name(),x,y,time,contract);
        }
    }

    public function getTimeByState(state:String,contract:int):int {
            var time:int=0;
            switch(state) {
            case "collect":
                case "stand":
                   time=0;break;
            default:
               time = Math.floor(Number(state));

        }
        return time;
    }

}
}

