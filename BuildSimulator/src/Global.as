package {
import flash.text.TextField;

public class Global {
    public static var field:Field;
    public static var bitmapArray:CachedBitmap  = new CachedBitmap();
    public static var userOperation:Boolean;
    public static var coins:TextField = new TextField();
    public static var error_field:TextField = new TextField();
    public static const TIME_TICK:int=1000;
    public static const CELL_SIZE:int = 50;
    public static const START_COINS:int = 70;
    public static const FIELD_PATH:String = "http://localhost:4567/field.jpg";
    public static const PATH_FACTORY:String = "http://localhost:4567/factory.png";
    public static const PATH_CONTRACT1:String = "http://localhost:4567/contract_1.png";
    public static const PATH_CONTRACT2:String = "http://localhost:4567/contract_2.png";
    public static const CURSOR_FOR_SHOP:String ="http://localhost:4567/auto_workshop.png";
    public static const CURSOR_FOR_FACTORY:String="http://localhost:4567/factory.png";
    public static const PATH_WORKSHOP:String ="http://localhost:4567/auto_workshop.png";
    public static var error_array:Object  =
        {
            add:"Невозможно добавить постройку",
            move: "Перемещение в эти координаты невозможно",
            remove: "Постройка не может быть удалена",
            profitFactory: "Не удалось собрать прибыль с фабрики",
            profitShop: "Не удалось собрать прибыль с инфраструктуры",
            startContract: "Не удалось запустить контракт",
            isBuild: "Построение не завершено"
        };

    public static var state:Object  =
    {
            stand: "Простаивает",
            work: "В работе",
            ready: "Готов к сбору"
    };

    public static function clearErrorField():void
    {
        error_field.text="";
    }

    public static function setErrorsLabel():void
    {
        Global.error_field.x = Field.FIELD_WIDTH+ButtonsMenu.BUTTON_OFFSET;
        Global.error_field.y = (ButtonsMenu.COUNT_BUTTONS+1)*ButtonsMenu.BUTTON_HEIGHT;
        Global.error_field.width=150;
        Global.error_field.textColor= 0xFF0000;
        Global.error_field.wordWrap=true;
    }

    public static function setCoinsLabel():void
    {
        Global.coins.x = Field.FIELD_WIDTH+ButtonsMenu.BUTTON_OFFSET;
        Global.coins.y = Field.FIELD_HEIGHT;
        Global.coins.border=true;
        Global.coins.borderColor=0xCCFF00;
        Global.coins.height = ButtonsMenu.BUTTON_HEIGHT;
    }
}
}
