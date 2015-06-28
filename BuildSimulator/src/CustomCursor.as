package {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
public class CustomCursor extends  Sprite{
    public const width_cursor:int=50;
    public const height_cursor:int=50;
    public function CustomCursor(name:String, field:Field) {
       var cur:Sprite = new Sprite();
        cur.addChild(new Viewer(name,0,0,width_cursor,height_cursor));
        addChild(cur);
        field.field_sprite.addChild(this);
        cur.visible=false;
        field.field_sprite.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
        function onMove(event:MouseEvent):void
        {
            var coordX:int = event.stageX;
            var coordY:int = event.stageY;

            if (coordX >= 0 && coordY >= 0 && coordX <= Field.field_width-width_cursor && coordY <= Field.field_height-height_cursor)
            {
                cur.visible = true;
                cur.x = coordX;
                cur.y = coordY;
            }
        }
        field.field_sprite.addEventListener(Event.MOUSE_LEAVE, onLeave);
        function onLeave(event:Event):void
        {
            cur.visible = false;
        }
    }
}
}
