package {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;

public class HttpHelper
{
        public static function sendRequest(url:String, variables:URLVariables, func:Function):void {
            var request:URLRequest = new URLRequest(url);
            request.data = variables;
            request.contentType="text/xml";
            var loader:URLLoader = new URLLoader();
            loader.load(request);
            loader.addEventListener(Event.COMPLETE, function onComplete() {
                func(loader.data);
            });
    }
}
}
