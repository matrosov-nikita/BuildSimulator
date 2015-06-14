/**
 * Created by nik on 13.06.15.
 */
package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class CustomCursor extends  Sprite{
    public function CustomCursor(name:String, field:Field) {

       var cur:Sprite = new Sprite();
        cur.addChild(new Viewer(name,0,0,50,50));
       addChild(cur);
        field.field_sprite.addChild(this);
        cur.visible=false;

        field.field_sprite.addEventListener(MouseEvent.MOUSE_MOVE,mMove);
        function mMove(event:MouseEvent):void
        {
            var coordX:int = event.stageX;
            var coordY:int = event.stageY;

            if (coordX >= 0 && coordY >= 0 && coordX <= field.field_width && coordY <= field.field_height)
            {
                cur.visible = true;
                cur.x = coordX;
                cur.y = coordY;
               // event.updateAfterEvent();
            }
        }

        field.field_sprite.addEventListener(Event.MOUSE_LEAVE, mLeave);
        function mLeave(event:Event):void
        {
            cur.visible = false;
        }

    }
}
}
