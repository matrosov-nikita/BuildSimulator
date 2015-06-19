/**
 * Created by nik on 21.05.15.
 */
package {

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.XMLSocket;
import flash.system.Security;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
public class Building {
    public var id:int;
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
    public function Building(id:Number,_x: Number, _y:Number, scene: Field,time:int){
        this.id=id;
        this._x = _x;
        this._y = _y;
        this.scene = scene;
        this.time=time;
        if (time==0) state="Простаивает"; else state="В работе";
        sprite = new Sprite();
        t_state = new TextField();
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onMove(event:MouseEvent):void {
        sprite.buttonMode=true;
    }

    public function Draw():void{
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.INIT, onLoad);
        loader.load(new URLRequest(path));
    }

    private function onLoad(event:Event):void {

        var myFormat = new TextFormat("Georgia",7);
        t_state.height=25;
        t_state.defaultTextFormat=myFormat;
        t_state.text = state;
        t_state.selectable=false;
        t_state.x = _x*50;
        t_state.y=_y*50+30;
        sprite.addChild(t_state);
        loader.x = _x*50;
        loader.y = _y*50;
        loader.width = 40;
        loader.height=40;
        t_state.text = state;
        sprite.addChild(loader);
        scene.field_sprite.addChild(sprite);
    }

    public function Redraw():void {
        var k:int  = timer.repeatCount;
        var l:int = timer.currentCount;
        var diff:int = k-l;
        var minutes:int = diff/60;
        var seconds:int = diff%60;

        t_state.text = state+((timer!=null && state=="В работе")?("\n" +minutes+"м. " + seconds+"с." ):"");
    }

    public function sendRequest(url,variables):void {
        var url:String = url;
        var request:URLRequest = new URLRequest(url);
        //    var variables:URLVariables = new URLVariables();
        trace(variables);

        variables.xml =scene.convertToXML();
        request.data = variables;
        request.contentType="text/xml";
        var loader:URLLoader = new URLLoader();
        loader.load(request);
        loader.addEventListener(Event.COMPLETE, function onComplete() {
            trace("get");
            var xml:XML = XML(loader.data);
            trace(xml.*);

            if (xml.name()=="field")
                scene.drawField(xml);
        });

    }
}
}
