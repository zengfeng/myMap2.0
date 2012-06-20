package worlds.auxiliarys
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-30
	// ============================
	public class MapPoint
	{
		public var x : Number;
		public var y : Number;

		function MapPoint(x : Number = 0, y : Number = 0) : void
		{
			this.x = x;
			this.y = y;
		}

		public function destory() : void
		{
			x = NaN;
			y = NaN;
			MapPointPool.instance.destoryObject(this, true);
		}

		public function toString() : String
		{
			return "MapPoint(" + x + ", " + y + ")";
		}
	}
}
