/**
 * Created by nik on 22.05.15.
 */
package {


import flash.display.Sprite;
import flash.display.Stage;

public class Field {
    public const field_width:int = 550;
    public const field_height:int = 350;
    public const start_coins = 700;
    public const path = "http://localhost:8090/images/field.jpg";
    public var buildings:Array;
    public var coins:int;
    public var field_sprite:Sprite;

    public function Field(stage:Stage) {
        coins = start_coins;
        buildings = new Array();
        field_sprite = new Sprite();
        field_sprite.addChild(new Viewer(path,0, 0, field_width, field_height));
        stage.addChild(field_sprite);
    }

    public function removeAllBuildings():void {
        while (field_sprite.numChildren > 1) {
            field_sprite.removeChildAt(1);
        }
        buildings=[];
    }

    public function drawAllBuildings():void {
        for(var i:int = 0; i < buildings.length; ++i) {
            buildings[i].Draw();
        }
    }

    public function drawField(info:XML):void{

        var find:Boolean = false;

        if (info != null) {
           // removeAllBuildings();
            coins = info.@coins;
            for each(var child:XML in info.*) {
                var id:int = child.@id;
                if (id == Global.currentBuilding)
                {
                    var x:int = child.@x;
                    var y:int = child.@y;
                    var time:int = child.@time;
                    var contract:int = child.@contract;
                    var index:int = findBuildingById(id);
                    if (index!=-1)
                    {
                        field_sprite.removeChild(buildings[index].sprite);
                        buildings[index]=null;
                        if (child.name() == "auto_workshop") {
                            buildings[index] = new Workship(id,x, y, this, time);
                        }
                        else {
                            buildings[index] =  new Factory(id,x, y, this, contract, time);
                        }
                        buildings[index].Draw();
                    }
                    else {
                        if (child.name() == "auto_workshop") {
                            buildings.push(new Workship(id,x, y, this, time));
                        }
                        else {
                            buildings.push(new Factory(id,x, y, this, contract, time));
                        }
                        buildings[buildings.length-1].Draw();
                    }
                    find = true; break;
                }
            }
           if (find==false) {
                var r_index:Number = findBuildingById(Global.currentBuilding);
                field_sprite.removeChild(buildings[r_index].sprite);
               buildings.slice(r_index,1);
            }
        }
      //  drawAllBuildings();
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
    public function findBuildingById(id:int) {
        for(var i:int = 0; i < buildings.length; ++i)
        {
            if (buildings[i].id==id)
            {
                return i;
            }
        }
        return -1;
    }

    public function convertToXML():XML {
        var buidling:XML = <field coins={coins}> </field>;

        for(var i:int = 0; i < buildings.length; ++i)
        {
            var build:Building = buildings[i];
            if (build.build_type=="factory")
            {
                buidling.appendChild(<{build.build_type}
                        id={build.id}
                        x = {build._x}
                        y = {build._y}
                        contract={(build as Factory).contract}
                        time={build.time + build.timer.currentCount*1000} />);
            }
            else
            {
                buidling.appendChild(<{build.build_type}
                        id={build.id}
                        x = {build._x}
                        y = {build._y}
                        time={build.time + build.timer.currentCount*1000} />);
            }
        }

        return buidling;
    }
}
}

