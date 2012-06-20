package worlds.auxiliarys
{
    import flash.display.Shape;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-11
     */
    public class PointShape extends Shape
    {
        public function PointShape()
        {
            graphics.beginFill(0xFF0000);
            graphics.drawRect(0, 0, 20, 20);
            graphics.endFill();
        }
    }
}
