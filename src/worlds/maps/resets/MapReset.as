package worlds.maps.resets
{
	import worlds.auxiliarys.loads.expands.MaskLoader;
	import worlds.maps.MaskInstance;
	import worlds.maps.LoadingPanel;
	import worlds.maps.layers.gates.GateControl;
	import worlds.apis.MapUtil;
	import worlds.auxiliarys.MapStage;
	import worlds.auxiliarys.loads.expands.PathLoader;
	import worlds.maps.PathInstance;
	import worlds.maps.configs.structs.MapStruct;
	import worlds.maps.layers.LayerContainer;
	import worlds.maps.layers.RoleLayer;
	import worlds.maps.layers.lands.LandInstall;
	import worlds.maps.preloads.MapPreload;
	import worlds.mediators.MapMediator;
	import worlds.roles.animations.depths.RoleLinkList;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class MapReset
	{
		/** 单例对像 */
		private static var _instance : MapReset;

		/** 获取单例对像 */
		static public function get instance() : MapReset
		{
			if (_instance == null)
			{
				_instance = new MapReset(new Singleton());
			}
			return _instance;
		}

		function MapReset(singleton : Singleton) : void
		{
			singleton;
			mapPreload = MapPreload.instance;
			roleLayer = RoleLayer.instance;
			landInstall = LandInstall.instance;
			layerContainer = LayerContainer.instance;
			MapMediator.sInstall.add(reset);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		// ======================
		// 地图基本信息
		// ======================
		public var mapId : int;
		public var mapAssetId : int;
		public var selfInitX : int;
		public var selfInitY : int;
		public var mapInitX : int;
		public var mapInitY : int;
		public var mapWidth : int;
		public var mapHeight : int;
		private var landIsFullMode : Boolean;
		private var hasMsk : Boolean;
		// ======================
		// 功能类
		// ======================
		private var module : IReset;
		private var mapPreload : MapPreload;
		private var landInstall : LandInstall;
		private var roleLayer : RoleLayer;
		private var layerContainer : LayerContainer;

		// ===============
		// 重设
		// ===============
		public function reset(mapId : int, selfInitX : int, selfInitY : int) : void
		{
			this.mapId = mapId;
			this.selfInitX = selfInitX;
			this.selfInitY = selfInitY;
			MapUtil.setCurrentMapId(mapId);
			var mapStruct : MapStruct = MapUtil.currentMapStruct;
			landIsFullMode = mapId > 20;
			hasMsk = mapStruct.hasMask;
			mapAssetId = mapStruct.assetId;
			mapWidth = mapStruct.mapWidth;
			mapHeight = mapStruct.mapHeight;
			mapInitX = MapUtil.selfToMapX(selfInitX);
			mapInitY = MapUtil.selfToMapY(selfInitY);

			uninstall();
			setModule();
			setPreloadData();
			startPreload();
		}

		private function setModule() : void
		{
			if (MapUtil.isCapitalMap(mapId))
			{
				module = ResetCapital.instance;
			}
			else if (MapUtil.isNormalMap(mapId))
			{
				module = ResetNormal.instance;
			}
			else
			{
				module = ResetNormal.instance;
			}
		}

		// ===============
		// 卸载
		// ===============
		public function uninstall() : void
		{
			if (module) module.uninstall();
			landInstall.preset(mapId, mapWidth, mapHeight, landIsFullMode);
			roleLayer.reset(mapWidth, mapHeight);
			RoleLinkList.instance.clear();
			GateControl.instance.uninstall();
			MapMediator.sUnstallComplete.dispatch();
		}

		// ===============
		// 设置预加载数据
		// ===============
		public function setPreloadData() : void
		{
			mapPreload.reset(mapId, -mapInitX, -mapInitY, mapWidth, mapHeight, MapStage.stageWidth, MapStage.stageHeight, mapAssetId, landIsFullMode, hasMsk);
			layerContainer.initPosition(mapInitX, mapInitY);
		}

		// ===============
		// 开始预加载
		// ===============
		public function startPreload() : void
		{
			LoadingPanel.instance.show();
			mapPreload.signalComplete.add(preloadComplete);
			mapPreload.startLoad();
		}

		// ===============
		// 预加载完成
		// ===============
		public function preloadComplete() : void
		{
			startInstall();
		}

		// ===============
		// 开始安装
		// ===============
		public function startInstall() : void
		{
			PathInstance.signalWriteComplete.add(finish);
			PathInstance.reset(PathLoader.instance.getData());
			if (hasMsk)
			{
				MaskInstance.reset(MaskLoader.instance.getBitmapData());
			}
			else
			{
				MaskInstance.reset(null);
			}
			landInstall.install();
			module.startInstall();
			GateControl.instance.install();
		}

		// ===============
		// 安装完成
		// ===============
		public function finish() : void
		{
			MapMediator.sInstallComplete.dispatch();
			trace("安装完成");
		}
	}
}
class Singleton
{
}