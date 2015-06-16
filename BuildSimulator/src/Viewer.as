package {
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
public class Viewer extends  Sprite{
    private var loader:Loader;
    public function Viewer(path:String, x: Number, y:Number, width: Number, height:Number) {
        loader = new Loader();
        addChild(loader);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void {
            loader.width = width;
            loader.height = height;
            loader.x = x;
            loader.y=y;
        });
        var request:URLRequest = new URLRequest(path);
        loader.load(request);
    }
}
}