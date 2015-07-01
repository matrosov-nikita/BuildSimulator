package {
import flash.display.Sprite;
import flash.display.Stage;

public class Field {
    public static const FIELD_WIDTH:int = 550;
    public static const FIELD_HEIGHT:int = 350;
    public var buildings:Array;
    public var coins:int;
    public var field_sprite:Sprite;

    public function Field(stage:Stage)
    {
        coins = Global.START_COINS;
        buildings = [];
        field_sprite = new Sprite();
        field_sprite.addChild(new Viewer(Global.FIELD_PATH,0, 0, FIELD_WIDTH, FIELD_HEIGHT));
        stage.addChild(field_sprite);
    }

    public function getObjectType(type: String):Object
    {
        var object_types:Object = {auto_workshop: Workshop, factory: Factory};
        return object_types[type]
    }

    public function getObject(type:String, x:int,y:int,time:int,contract:int=0):Object
    {
        var object:Object = getObjectType(type);
        return new object(x,y,time,contract);
    }

    public function addBuilding(object:Object):void
    {
        buildings.push(object);
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

    public function getField(xmlStr:XML):void
    {
        coins = xmlStr.@coins;
        Global.coins.text = "Coins: " + coins;
        for each(var child:XML in xmlStr.*) {
            addBuilding(createBuidlingByXML(child));
        }
    }

    public function createBuidlingByXML(xml:XML):Object
    {
        var x:int = xml.@x;
        var y:int = xml.@y;
        var contract:int = xml.@contract;
        var state:String = xml.@state;
        var time:int = getTimeByState(state,contract);
        return getObject(xml.name(),x,y,time,contract);
    }

    public function reCreateBuiling(index:int, data:XML):void
    {
        Global.field.buildings[index].remove(index);
        Global.field.addBuilding(Global.field.createBuidlingByXML(data));
    }

    public function getTimeByState(state:String,contract:int):int
    {
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

