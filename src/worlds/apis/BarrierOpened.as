package worlds.apis
{
	import flash.utils.Dictionary;
	import worlds.auxiliarys.mediators.MSignal;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	// 开放的路障
	// ============================
	public class BarrierOpened
	{
		/** args=[barrierId, isOpen] */
		public static var signalState : MSignal = new MSignal(int, Boolean);
		public static var dic : Dictionary = new Dictionary();

		public static function clear() : void
		{
			signalState.clear();
			var keyArr : Array = [];
			for (var key:String in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				delete dic[keyArr.shift()];
			}
		}
		
		/** 设置路障状态 */
		public static function setState(barrierId : int, isOpen : Boolean) : void
		{
			dic[barrierId] = isOpen;
			signalState.dispatch(barrierId, isOpen);
		}

		/** 获取路障是否开放 */
		public static function getState(barrierId : int) : Boolean
		{
			return dic[barrierId];
		}
	}
}
