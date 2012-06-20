package worlds.apis
{
	import worlds.mediators.ToMediator;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MTo
	{
		/** 去某个点(只限当前地图,如果跨地图请用MTo.map) */
		public static function toPoint(x : int, y : int, callFun : Function = null, callFunArgs : Array = null, responseRadius : int = 30) : void
		{
			ToMediator.toPoint.call(x, y, callFun, callFunArgs, responseRadius);
		}

		public static function toNpc(npcId : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, responseRadius : int = 40, pointIndex : int = -1) : void
		{
			ToMediator.toNpc.call(npcId, mapId, callFun, callFunArgs, responseRadius, flashStep, pointIndex);
		}

		public static function toDuplNpc(toDuplMapId : int = 0, flashStep : Boolean = false) : void
		{
			ToMediator.toDuplNpc.call(toDuplMapId, flashStep);
		}

		public static function toGate(toMapId : uint, mapId : uint = 0, stand : Boolean = false, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, responseRadius : int = 50) : void
		{
			ToMediator.toGate.call(toMapId, mapId, stand, callFun, callFunArgs, responseRadius, flashStep);
		}
		
		public static function toExitGate():void
		{
			ToMediator.toExitGate.call();
		}

		public static function toMap(x : int, y : int, mapId : uint = 0, callFun : Function = null, callFunArgs : Array = null, flashStep : Boolean = false, responseRadius : int = 30) : void
		{
			ToMediator.toMap.call(x, y, mapId, callFun, callFunArgs, responseRadius, flashStep);
		}

		public static function transportTo(x : int, y : int, mapId : int = 0, callFun : Function = null, callFunArgs : Array = null) : void
		{
			ToMediator.transportTo.call(x, y, mapId, callFun, callFunArgs);
		}
	}
}
