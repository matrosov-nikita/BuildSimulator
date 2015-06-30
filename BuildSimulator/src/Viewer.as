package {
import flash.display.*;
import flash.events.Event;
import flash.net.URLRequest;
public class Viewer extends  Sprite{
    public var bitmap:Bitmap;
    public function Viewer(path:String, x: Number, y:Number, width: Number, height:Number)
    {
        if (!Global.bitmapArray.hasResource(path)) {
            var loader:Loader = new Loader();
            var request:URLRequest = new URLRequest(path);
            loader.load(request);

            loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void {
                var bmp:Bitmap = loader.content as Bitmap;
                bitmap = new Bitmap(bmp.bitmapData);
                Global.bitmapArray.addResource(path,bmp.bitmapData);
                transformBitmap(x, y, width, height);
                addChild(bitmap);
            });
        }
        else {
            bitmap = new Bitmap(Global.bitmapArray.getResource(path));
            transformBitmap(x, y, width, height);
            addChild(bitmap);
        }
    }
    public function transformBitmap(x:int, y:int, width:int, height:int) {
        bitmap.width = width;
        bitmap.height = height;
        bitmap.x = x;
        bitmap.y = y;
    }
}
}