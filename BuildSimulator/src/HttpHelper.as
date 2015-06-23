package {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;

public class HttpHelper {
    public static function sendRequest(url:String, variables:URLVariables, field:Field) {
        var request:URLRequest = new URLRequest(url);
        variables.xml =field.convertToXML().toXMLString();
        request.data = variables;
        request.contentType = "text/xml";
        var loader:URLLoader = new URLLoader();
        loader.load(request);
        loader.addEventListener(Event.COMPLETE, function onComplete() {
            var xml:XML = XML(loader.data);
            if (xml.name() == "field")
                field.drawField(xml);
        });
    }
}
}
