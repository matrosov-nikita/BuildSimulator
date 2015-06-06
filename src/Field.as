/**
 * Created by nik on 22.05.15.
 */
package {
import flash.display.Sprite;



public class Field {

    public var buildings:Array;
    public var coins:int;
    public var field_sprite:Sprite;
    public function Field(info:XML,scene:Sprite) {
        coins = 70;
        buildings = new Array();

        field_sprite = new Sprite();

        field_sprite.addChild(new Viewer("field.jpg", 0, 0, 500, 300));


        scene.addChild(field_sprite);

        for each(var child:XML in info.*) {
            var x:int = child.@x;

            var y:int = child.@y;
            var time:int = child.@time;
            if (child.name() == "auto_workshop") {
                buildings.push(new Workship(x,y,"auto_workshop","auto_workshop.png",this,time));
            }
            else {
                buildings.push(new Factory(x,y,"factory","factory.png",this,child.@contract,time));
            }
        }
    }
    public function draw():void{
        for(var i:int = 0; i < buildings.length; ++i) {
            trace(buildings[i]._x, buildings[i]._y );

            buildings[i].Draw();
        }
    }
    public function addNewBuilding(x,y,type,scene)
    {
        trace(type);
        var exist:Boolean = false;
        for(var i:int = 0; i< buildings.length; ++i) {
            if (buildings[i]._x == x && buildings[i]._y==y) {
                break; exist = true;
            }
        }
        if (!exist) {
            var create_object:Building;
            if (type=="auto_workshop") {
                create_object = new Workship(x,y,"auto_workshop","auto_workshop.png",this,0);
                buildings.push(create_object);
            }
            else {
                create_object = new Factory(x,y,"factory","factory.png",this,0,0)
                buildings.push(create_object);
            }

        create_object.Draw();

        }

    }
    public function find_building(x:int, y:int):int
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
    public function remove_building(index:int):void
    {
        field_sprite.removeChild(buildings[index].sprite);
        buildings.splice(index,1);

    }
    public function generateXMLForServer():void {}
}


}

