package worlds.auxiliarys
{
	import flash.display.BitmapData;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class Mask
	{
		private var PATH_PERCENT : int = 16;
		private var bitmapData : BitmapData;
		public var isMask : Function;

		function Mask() : void
		{
			isMask = emptyIsMask;
		}

		public function reset(bitmapData : BitmapData, percent : int = 16) : void
		{
			clear();
			PATH_PERCENT = percent;
			this.bitmapData = bitmapData;
			if (bitmapData)
			{
				isMask = isMaskHander;
			}
		}

		private function clear() : void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			isMask = emptyIsMask;
		}

		private function mapToMaskX(mapX : int) : int
		{
			return mapX / PATH_PERCENT;
		}

		private function mapToMaskY(mapY : int) : int
		{
			return mapY / PATH_PERCENT;
		}

		private function emptyIsMask(x : int, y : int) : Boolean
		{
			x;
			y;
			return false;
		}

		private function isMaskHander(x : int, y : int) : Boolean
		{
			return bitmapData.getPixel32(mapToMaskX(x), mapToMaskY(y)) != 0xFFFFFFFF;
		}
	}
}
