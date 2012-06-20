package worlds.maps
{
	import flash.display.BitmapData;

	import worlds.auxiliarys.Mask;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class MaskInstance
	{
		private static var mask : Mask = new Mask();

		/** 重设 */
		public static function reset(bitmapData : BitmapData, percent : int = 16) : void
		{
			mask.reset(bitmapData, percent);
		}

		/** 是否是遮罩 */
		public static function isMask(mapX : int, mapY : int) : Boolean
		{
			return mask.isMask(mapX, mapY);
		}
	}
}
class Singleton
{
}