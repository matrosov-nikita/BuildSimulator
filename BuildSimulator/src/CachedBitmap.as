package {
import flash.display.BitmapData;
public class CachedBitmap {
    public var bitmapArray:Array = [];
    public function hasResource(path:String):Boolean
    {
        return bitmapArray[path]!=undefined;
    }
    public function addResource(path:String, content:BitmapData ):void
    {
        bitmapArray[path] = content;
    }
    public function getResource(path:String):BitmapData
    {
        return bitmapArray[path];
    }
}
}
