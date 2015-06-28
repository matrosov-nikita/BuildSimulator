package {
import flash.text.TextField;

public class Global {

    public static var userOperation:Boolean;
    public static const time_tick:int=1000;
    public static var coins:TextField = new TextField();
    public static var error_field:TextField = new TextField();
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
    public static function clearErrorField():void {
        error_field.text="";
    }

    public static function setErrorsLabel():void {
        Global.error_field.x = Field.field_width+ButtonsMenu.button_offset;
        Global.error_field.y = (ButtonsMenu.count_buttons+1)*ButtonsMenu.button_height;
        Global.error_field.width=150;
        Global.error_field.textColor= 0xFF0000;
        Global.error_field.wordWrap=true;
    }
    public static function setCoinsLabel():void {
        Global.coins.x = Field.field_width+ButtonsMenu.button_offset;
        Global.coins.y = Field.field_height;
        Global.coins.border=true;
        Global.coins.borderColor=0xCCFF00;
        Global.coins.height = ButtonsMenu.button_height;
    }


}
}
