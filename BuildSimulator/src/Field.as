/**
 * Created by nik on 22.05.15.
 */
package {
import flash.display.Sprite;



public class Field {

    public var buildings:Array;
    public var coins:int;
    public var field_sprite:Sprite;
    public const field_width:int = 550;
    public const field_height:int = 350;
    public function Field(scene:Sprite) {
        coins = 700;
        buildings = new Array();
        field_sprite = new Sprite();
        field_sprite.addChild(new Viewer("field.jpg", 0, 0, field_width, field_height));

        scene.addChild(field_sprite);

    }
    public function draw(info:XML):void{

        while (field_sprite.numChildren > 1) {
            field_sprite.removeChildAt(1);
            trace("remove")
        }
        buildings=[];
        if (info != null) {
            for each(var child:XML in info.*) {
                var x:int = child.@x;

                var y:int = child.@y;
                var time:int = child.@time;
                if (child.name() == "auto_workshop") {
                    buildings.push(new Workship(x, y, "auto_workshop", "auto_workshop.png", this, time));
                }
                else {
                    buildings.push(new Factory(x, y, "factory", "factory.png", this, child.@contract, time));
                }
            }
        }

        for(var i:int = 0; i < buildings.length; ++i) {
            buildings[i].Draw();
        }

    }
    public function addNewBuilding(x,y,type):int
    {
        var exist:int = find_building(x,y);

        if (exist==-1) {


            var create_object:Building;
            if (type=="auto_workshop") {
                create_object = new Workship(x,y,"auto_workshop","auto_workshop.png",this,0);
                buildings.push(create_object);
            }
            else {
                create_object = new Factory(x,y,"factory","factory.png",this,0,0);
                buildings.push(create_object);
            }
            return 0;
        }
        return 1;
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
    public function convert_to_xml():XML {
        var buidling:XML = <field/>;

        for(var i:int = 0; i < buildings.length; ++i)
        {
            var build:Building = buildings[i];
        if (build.build_type=="factory")
        {

             buidling.appendChild(<{build.build_type} x = {build._x} y = {build._y} contract={(build as Factory).contract} time={build.time + build.timer.currentCount*1000} />);
        }
        else
        {
               buidling.appendChild(<{build.build_type} x = {build._x} y = {build._y} time={build.time + build.timer.currentCount*1000} />);
        }
            }

        return buidling;
    }
    public function remove_building(index:int):void
    {
        buildings.splice(index,1);
    }

}


}

