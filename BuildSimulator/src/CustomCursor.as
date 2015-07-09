package {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class CustomCursor extends Sprite {
    public const WIDTH_CURSOR:int = 50;
    public const HEIGHT_CURSOR:int = 50;

    public function CustomCursor(name:String) {
        var cur:Sprite = new Sprite();
        cur.addChild(new Viewer(name, 0, 0, WIDTH_CURSOR, HEIGHT_CURSOR));
        addChild(cur);
        cur.visible = false;
        Global.field.field_sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        function onMove(event:MouseEvent):void {
            var coordX:int = event.stageX;
            var coordY:int = event.stageY;

            if (coordX >= 0 && coordY >= 0 && coordX <= Field.FIELD_WIDTH - WIDTH_CURSOR && coordY <= Field.FIELD_HEIGHT - HEIGHT_CURSOR) {
                cur.visible = true;
                cur.x = coordX;
                cur.y = coordY;
            }
        }

        Global.field.field_sprite.addEventListener(Event.MOUSE_LEAVE, onLeave);
        function onLeave(event:Event):void {
            cur.visible = false;
        }
    }
}
}
