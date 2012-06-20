package worlds.maps.configs.structs
{
    import flash.geom.Point;
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-26 ����7:52:44
     */
    public class GateStruct
    {
		public var id:int;
        /** 位置 */
        public var x : int;
        public var y : int;
        public var position:Point = new Point();
        /** 站立位置 */
        public var standX : int;
        public var standY : int;
        public var standPosition:Point = new Point();
        /** 前住地图ID */
        public var toMapId : uint;
    }
}
