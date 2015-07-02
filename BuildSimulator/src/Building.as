package {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLVariables;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
public class Building {
    public const WIDTH_BUILDING:int=40;
    public const HEIGHT_BUILDING:int=40;
    public const HEIGHT_LABEL:int=25;
    public const OFFSET_LABEL:int=30;
    public const PATH_IS_BUILD:String="http://localhost:4567/isBuildComplete";
    public var _x:int;
    public var _y:int;
    public var state:String;
    public var sprite: Sprite;
    public var timer:Timer;
    public var time:int;
    public var t_state:TextField;
    public var path:String;
    public var viewer:Viewer;
    public var build_type:String;
    public function Building(_x: Number, _y:Number,time:int,contract:int)
    {
        this._x = _x;
        this._y = _y;
        this.time=time;
        if (time==0) state=Global.state["stand"]; else state=Global.state["work"];
        sprite = new Sprite();
        t_state = new TextField();
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onMove(event:MouseEvent):void
    {
        sprite.buttonMode=true;
    }

    public function draw():void
    {
        var viewer:Viewer = new Viewer(path,_x*Global.CELL_SIZE,_y*Global.CELL_SIZE,WIDTH_BUILDING,HEIGHT_BUILDING);
        setLabelBuidling();
        sprite.addChild(viewer);
        Global.field.field_sprite.addChild(sprite);
    }

    public function launchTimer():void
    {
        var repCount:int = time;
        if (repCount==0) ready();
        else {
            timer.repeatCount =repCount;
            state = Global.state["work"];
            timer.start();
        }
    }

    public function setLabelBuidling():void
    {
        var myFormat:TextFormat = new TextFormat("Georgia",7);
        t_state.height=HEIGHT_LABEL;
        t_state.defaultTextFormat=myFormat;
        t_state.text = state;
        t_state.selectable=false;
        t_state.x = _x*Global.CELL_SIZE;
        t_state.y=_y*Global.CELL_SIZE+OFFSET_LABEL;
        t_state.text = state;
        sprite.addChild(t_state);
    }

    public function redraw():void
    {
        var k:int  = timer.repeatCount;
        var l:int = timer.currentCount;
        var diff:int = k-l;
        var minutes:int = diff/60;
        var seconds:int = diff%60;
        t_state.text = state+((timer!=null && state==Global.state["work"])?("\n" +minutes+"м. " + seconds+"с." ):"");
    }

    public function tick(event:TimerEvent):void
    {
        redraw();
    }
    public function ready(event:TimerEvent=null):void
    {
        if (time==0)
        {
            giveProfit()
        }
        else {
            var variables:URLVariables = new URLVariables();
            variables.x = _x;
            variables.y = _y;
            giveProfit();
            HttpHelper.sendRequest(PATH_IS_BUILD, variables, function(data)
            {
                if (data != "true") {
                    time = (build_type=="factory")?Factory.CONTRACTS[this.contract]["time_working"]:Workshop.TIME_WORKING;
                    timer.reset();
                    launchTimer();
                    Global.error_field.text = Global.error_array["isBuild"];
                }
            });
        }
    }

    public function giveProfit():void
    {
        state = Global.state["ready"];
        redraw();
        sprite.addEventListener(MouseEvent.CLICK, getProfit);
    }

    public function getProfit(event:MouseEvent):void
    {
    }

    public function  remove(index:int):void
    {
        Global.field.field_sprite.removeChild(sprite);
        Global.field.buildings.slice(index,1);
        timer.reset();
    }

    public function move(index:int,new_x:int,new_y:int):void
    {
        Global.field.buildings[index]._x = new_x;
        Global.field.buildings[index]._y = new_y;
        Global.field.field_sprite.removeChild(sprite);
        viewer = new Viewer(path,new_x*Global.CELL_SIZE,new_y*Global.CELL_SIZE,WIDTH_BUILDING,HEIGHT_BUILDING);
        sprite = new Sprite();
        sprite.addChild(viewer);
        t_state.x = new_x*Global.CELL_SIZE;
        t_state.y=new_y*Global.CELL_SIZE+OFFSET_LABEL;
        sprite.addChild(t_state);
        Global.field.field_sprite.addChild(sprite);
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }
}
}
