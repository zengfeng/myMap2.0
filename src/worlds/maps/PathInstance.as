package worlds.maps
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import worlds.apis.BarrierOpened;
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.Path;
	import worlds.auxiliarys.mediators.MSignal;




	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-30
	// ============================
	public class PathInstance
	{
		/** 单例对像 */
		private static var _instance : PathInstance;

		/** 获取单例对像 */
		private static  function get instance() : PathInstance
		{
			if (_instance == null)
			{
				_instance = new PathInstance(new Singleton());
			}
			return _instance;
		}

		function PathInstance(singleton : Singleton) : void
		{
			singleton;
			path.signalWriteProgress.add(signalWriteProgress.dispatch);
			path.signalWriteComplete.add(signalWriteComplete.dispatch);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		
		private var path:Path = new Path();
		public static  var signalWriteProgress : MSignal = new MSignal(uint, uint);
		public  static var signalWriteComplete : MSignal = new MSignal();
		/** 重设 */
		public function reset(byteArray : ByteArray) : void
		{
			path.reset(byteArray);
			path.signalWriteComplete.add(initBarrier);
		}

		/** 初始化路障 */
		private function initBarrier() : void
		{
			path.setBarrier(255, true);
			var dic : Dictionary = BarrierOpened.dic;
			for (var key:String in dic)
			{
				path.setBarrier(parseInt(key), dic[key]);
			}
			BarrierOpened.signalState.add(path.setBarrier);
		}
		
		// =========================
		// 静态方法
		// =========================
		/** 重设 */
		public static function reset(byteArrray : ByteArray) : void
		{
			instance.reset(byteArrray);
		}

		/** 设置路障 */
		public static function setBarrier(barrierId : uint, isOpen : Boolean) : void
		{
			instance.path.setBarrier(barrierId, isOpen);
		}

		/** 寻路 */
		public static function find(mapFromX : int, mapFromY : int, mapToX : int, mapToY : int, pushList : Vector.<MapPoint> = null) : Vector.<MapPoint>
		{
			return instance.path.find(mapFromX, mapFromY, mapToX, mapToY, pushList);
		}
	}
}
class Singleton
{
}