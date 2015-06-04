/**
 * Created by nik on 21.05.15.
 */
package {


import flash.display.Loader;


import flash.display.Sprite;
import flash.events.Event;

import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;


public class Building {
    public var _x:int;
    public var _y:int;
    public var build_type:String;
    public var path:String;
    public var state:String;
    public var scene: Field;
    public var loader:Loader;
    public var sprite: Sprite;
    public var t:TextField;
    public var timer:Timer;
    public function Building(_x: Number, _y:Number, build_type:String, path:String, scene: Field){
        this._x = _x;
        this._y = _y;
        this.build_type = build_type;
        this.path = path;
        this.scene = scene;
        sprite = new Sprite();
        state="Простаивает";
        t = new TextField();
        var myFormat:TextFormat = new TextFormat();
        myFormat.size=7;
        myFormat.font="Georgia";
        t.height=25;
        t.defaultTextFormat=myFormat;
        t.text = state;
        t.selectable=false;
        t.x = _x*50;
        t.y=_y*50+40;
        sprite.addChild(t);
    }

    public function Draw():void{
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.INIT, addIntoSprite);
        loader.load(new URLRequest(path));
    }

    private function addIntoSprite(event:Event):void {
        loader.x = _x*50;
        loader.y = _y*50;
        loader.width = 50;
        loader.height=50;
        t.text = state;
        sprite.addChild(loader);
        scene.field_sprite.addChild(sprite);
    }
    public function Redraw():void {
        trace(state);
        t.text = state+((timer!=null && state=="В работе")?("\n" + timer.currentCount.toString()):"");
    }

}
}
