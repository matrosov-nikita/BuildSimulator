package {

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
public class Building {
    public const cell_size:int=50;
    public const width_building:int=40;
    public const height_building:int=40;
    public const height_label:int=25;
    public const offset_label:int=30;
    public const path_is_build:String="http://localhost:4567/isBuildComplete";
    public var _x:int;
    public var _y:int;
    public var state:String;
    public var scene: Field;
    public var loader:Loader;
    public var sprite: Sprite;
    public var timer:Timer;
    public var time:int;
    public var t_state:TextField;
    public var path:String;
    public var build_type:String;
    public function Building(_x: Number, _y:Number, scene: Field,time:int,contract:int){
        this._x = _x;
        this._y = _y;
        this.scene = scene;
        this.time=time;
        if (time==0) state=Global.state["stand"]; else state=Global.state["work"];
        sprite = new Sprite();
        t_state = new TextField();
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onMove(event:MouseEvent):void {
        sprite.buttonMode=true;
    }

    public function draw():void{
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.INIT, onLoad);
        loader.load(new URLRequest(path));
    }

    public function launchTimer():void {
        var repCount:int = time;
        if (repCount==0) ready();
        else {
            timer.repeatCount =repCount;
            state = Global.state["work"];
            timer.start();
        }
    }

    private function onLoad(event:Event):void {
        setLabelBuidling();
        loader.x = _x*cell_size;
        loader.y = _y*cell_size;
        loader.width = width_building;
        loader.height=height_building;
        sprite.addChild(loader);
        scene.field_sprite.addChild(sprite);
    }

    public function setLabelBuidling():void {
        var myFormat:TextFormat = new TextFormat("Georgia",7);
        t_state.height=height_label;
        t_state.defaultTextFormat=myFormat;
        t_state.text = state;
        t_state.selectable=false;
        t_state.x = _x*cell_size;
        t_state.y=_y*cell_size+offset_label;
        t_state.text = state;
        sprite.addChild(t_state);
    }

    public function redraw():void {
        var k:int  = timer.repeatCount;
        var l:int = timer.currentCount;
        var diff:int = k-l;
        var minutes:int = diff/60;
        var seconds:int = diff%60;
        t_state.text = state+((timer!=null && state==Global.state["work"])?("\n" +minutes+"м. " + seconds+"с." ):"");
    }

    public function tick(event:TimerEvent):void {
        redraw();
    }
    public function ready(event:TimerEvent=null):void {
        var variables:URLVariables = new URLVariables();
        variables.x = _x;
        variables.y = _y;
        HttpHelper.sendRequest(path_is_build, variables, function(data) {
            if (data=="true") {
                state = Global.state["ready"];
                redraw();
                sprite.addEventListener(MouseEvent.CLICK, getProfit);
            }
            else {
                Global.error_field.text = Global.error_array["isBuild"];
            }
        });
    }

    public function getProfit(event:MouseEvent):void {
    }

    public function  remove(index:int):void {
        scene.field_sprite.removeChild(sprite);
        scene.buildings.slice(index,1);
        timer.reset();
    }

    public function move(index:int,new_x:int,new_y:int):void {
        scene.buildings[index]._x = new_x;
        scene.buildings[index]._y = new_y;
        scene.field_sprite.removeChild(sprite);
        loader.x = new_x*cell_size;
        loader.y = new_y*cell_size;
        sprite = new Sprite();
        sprite.addChild(loader);
        t_state.x = new_x*cell_size;
        t_state.y=new_y*cell_size+offset_label;
        sprite.addChild(t_state);
        scene.field_sprite.addChild(sprite);
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);

    }
}
}
