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
        }
    public static var state:Object  =
    {
            stand: "Простаивает",
            work: "В работе",
            ready: "Готов к сбору"
    }


}
}
