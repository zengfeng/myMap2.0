package worlds.apis
{
	import worlds.mediators.MapMediator;
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MMouse
	{
		private static var _enableWalk:Boolean = true;
		public static function get enableWalk():Boolean
		{
			return _enableWalk;
		}
		
		/** 是否能点击走路 */
		public static function set enableWalk(value : Boolean) : void
		{
			_enableWalk = value;
			MapMediator.cMouseEnabled.call(value);
		}

		/** 模拟鼠标点击 */
		public static function walkTo(toX : int, toY : int) : void
		{
			MapMediator.sMouseWalk.dispatch(toX, toY);
		}
	}
}
