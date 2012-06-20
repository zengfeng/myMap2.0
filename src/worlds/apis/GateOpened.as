package worlds.apis
{
	import flash.utils.Dictionary;
	import worlds.auxiliarys.mediators.MSignal;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	// 开放的传送阵
	// ============================
	public class GateOpened
	{
		/** args=[gateId, isOpen] */
		public static var signalState : MSignal = new MSignal(int, Boolean);
		private static var dic : Dictionary = new Dictionary();

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
		public static function setState(gateId : int, isOpen : Boolean) : void
		{
			dic[gateId] = isOpen;
			signalState.dispatch(gateId, isOpen);
		}

		/** 获取路障是否开放 */
		public static function getState(gateId : int) : Boolean
		{
			return dic[gateId] == true;
		}
	}
}