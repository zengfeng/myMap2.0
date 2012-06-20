package worlds.auxiliarys
{
	import flash.geom.Point;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// ============================
	public class MapMath
	{
		public static function randomNumber(max : Number, min : Number = 0) : Number
		{
			return int(Math.random() * (max - min)) + min;
		}

		public static function randomInt(max : int, min : int = 0) : uint
		{
			return int(Math.random() * (max - min)) + min;
		}

		public static function randomPlusMinus(num : int) : int
		{
			return Math.random() * num * (Math.random() > 0.5 ? 1 : -1);
		}

		public static function radian(fromX : Number, fromY : Number, toX : Number, toY : Number) : Number
		{
			var dx : Number = toX - fromX;
			var dy : Number = toY - fromY;
			return Math.atan2(dy, dx);
		}

		public static function angle(fromX : Number, fromY : Number, toX : Number, toY : Number) : Number
		{
			return radian(fromX, fromY, toX, toY) * 180 / Math.PI ;
		}

		public static function distance(fromX : Number, fromY : Number, toX : Number, toY : Number) : Number
		{
			var dx : Number = toX - fromX;
			var dy : Number = toY - fromY;
			return Math.sqrt(dx * dx + dy * dy);
		}

		public static function directionPoint(fromX : Number, fromY : Number, toX : Number, toY : Number, length : Number) : Point
		{
			var angle : Number = radian(fromX, fromY, toX, toY);
			var point : Point = new Point();

			point.x = Math.cos(angle) * length;
			point.y = Math.sin(angle) * length;
			point.x += fromX;
			point.y += fromY;
			return point;
		}

		public static function directionPointX(fromX : Number, fromY : Number, toX : Number, toY : Number, length : Number) : Number
		{
			return Math.cos(radian(fromX, fromY, toX, toY)) * length + fromX ;
		}

		public static function directionPointY(fromX : Number, fromY : Number, toX : Number, toY : Number, length : Number) : Number
		{
			return Math.sin(radian(fromX, fromY, toX, toY)) * length + fromY ;
		}

		public static function radianPointX(radian : Number, length : Number, fromX : Number) : Number
		{
			return Math.cos(radian) * length + fromX ;
		}

		public static function radianPointY(radian : Number, length : Number, fromY : Number) : Number
		{
			return Math.sin(radian) * length + fromY ;
		}
	}
}
