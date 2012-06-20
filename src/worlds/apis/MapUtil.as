package worlds.apis
{
	import worlds.WorldStartup;
	import worlds.maps.configs.MapConfig;
	import worlds.maps.configs.MapConfigData;
	import worlds.maps.configs.MapId;
	import worlds.maps.configs.structs.GateStruct;
	import worlds.maps.configs.structs.MapStruct;
	import worlds.maps.layers.lands.LandLayer;
	import worlds.roles.structs.NpcStruct;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class MapUtil
	{
		// =========================
		// 静态对像
		// =========================
		private static var landLayer : LandLayer = LandLayer.instance;
		private static var mapConfigData : MapConfigData = MapConfigData.instance;
		// =========================
		// 当前常用属性
		// =========================
		private static var stageWidth : int;
		private static var stageHeight : int;
		private static var stageWidthHalf : int;
		private static var stageHeightHalf : int;
		public static var mapWidth : int;
		public static var mapHeight : int;

		public static function setStage(stage : Stage) : void
		{
			MapUtil.stageWidth = stage.stageWidth;
			MapUtil.stageHeight = stage.stageHeight;
			MapUtil.stageWidthHalf = stage.stageWidth >> 1;
			MapUtil.stageHeightHalf = stage.stageHeight >> 1;
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		private static function onStageResize(event : Event) : void
		{
			var stage : Stage = event.target as Stage;
			MapUtil.stageWidth = stage.stageWidth;
			MapUtil.stageHeight = stage.stageHeight;
			MapUtil.stageWidthHalf = stage.stageWidth >> 1;
			MapUtil.stageHeightHalf = stage.stageHeight >> 1;
		}

		// =========================
		// 判断地图
		// =========================
		/** 当前地图ID */
		public static var currentMapId : int;
		/** 当前地图资源ID */
		public static var currentMapAssetId : int;
		
		/** 获取父地图ID */
		public static function getParentMapId(mapId:int):int
		{
			if(isNormalMap(mapId)) return mapId;
			if(isDuplMap(mapId)) return int(mapId / 100);
			if(isClanHkeeMap(mapId)) return MapId.CAPITAL;
			if(isClanBossMap(mapId)) return MapId.CAPITAL;
			if(isClanEscortMap(mapId)) return MapId.CAPITAL;
			if(isBossWarMap(mapId)) return MapId.CAPITAL;
			if(isFeastMap(mapId)) return MapId.CAPITAL;
			if(isGroupBattleMap(mapId)) return MapId.CAPITAL;
			return mapId;
		}

		/** 判断是不是当前地图 */
		public static function isCurrentMapId(mapId : int) : Boolean
		{
			return mapId == currentMapId || mapId <= 0;
		}

		/** 是否是 返回地图 */
		public static function isBackMap(mapId : int) : Boolean
		{
			return  mapId == MapId.BACK;
		}

		/** 是否是 首都地图 */
		public static function isCapitalMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.CAPITAL;
		}

		/** 是否是 普通地图*/
		public static function isNormalMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId >= MapId.MIN_NORMAL && mapId <= MapId.MAX_NORMAL;
		}

		/** 是否是 副本地图 */
		public static function isDuplMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId >= MapId.MIN_DUPL && mapId <= MapId.MAX_DUPL;
		}

		/** 是否是 家族主城 */
		public static function isClanHkeeMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.CLAN_HKEE;
		}

		/** 是否是  家族BOSS */
		public static function isClanBossMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.CLAN_BOSS;
		}

		/** 是否是  家族护送 */
		public static function isClanEscortMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.CLAN_ESCORT;
		}

		/** 是否是  BOSS战 */
		public static function isBossWarMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.BOSSWAR;
		}

		/** 是否是  派对 */
		public static function isFeastMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.FEAST;
		}

		/** 是否是  国战 */
		public static function isGroupBattleMap(mapId : int = 0) : Boolean
		{
			if (mapId == 0) mapId = currentMapId;
			return  mapId == MapId.GROUPBATTLE;
		}

		// =========================
		// 位置转换
		// =========================
		/** 路径位置转地图位置X */
		public static function pathToMapX(pathX : int) : int
		{
			return pathX * MapConfig.PATH_PERCENT;
		}

		/** 路径位置转地图位置Y */
		public static function pathToMapY(pathY : int) : int
		{
			return pathY * MapConfig.PATH_PERCENT;
		}

		/** 地图位置转路径位置X */
		public static function mapToPathX(mapX : int) : int
		{
			return mapX / MapConfig.PATH_PERCENT;
		}

		/** 地图位置转路径位置Y */
		public static function mapToPathY(mapY : int) : int
		{
			return mapY / MapConfig.PATH_PERCENT;
		}

		/** 屏幕位置转地图位置 */
		public static function stageToMap(postion : Point, replace : Boolean = false) : Point
		{
			var toPostion : Point;
			toPostion = landLayer.globalToLocal(postion);
			if (replace)
			{
				postion.x = toPostion.x;
				postion.y = toPostion.y;
				return postion;
			}
			return toPostion;
		}

		/** 地图位置转屏幕位置 */
		public static function mapToStage(postion : Point, replace : Boolean = false) : Point
		{
			var toPostion : Point;
			toPostion = landLayer.localToGlobal(postion);
			if (replace)
			{
				postion.x = toPostion.x;
				postion.y = toPostion.y;
				return postion;
			}
			return toPostion;
		}

		/** 根据自己的位置X,获取地图位置X */
		public static function selfToMapX(selfX : int) : int
		{
			var mapX : int;
			// 如果地图宽度小场景
			if (mapWidth <= stageWidth)
			{
				mapX = (stageWidth - mapX) >> 1;
			}
			else
			{
				// 左边沿
				if (selfX <= stageWidthHalf)
				{
					mapX = 0;
				}
				// 右边沿
				else if (selfX > mapWidth - stageWidthHalf )
				{
					mapX = stageWidth - mapWidth;
				}
				else
				{
					mapX = stageWidthHalf - selfX;
				}
			}

			return mapX;
		}

		/** 根据自己的位置X,获取地图位置X */
		public static function selfToMapY(selfY : int) : int
		{
			var mapY : int;
			// 如果地图宽度小场景
			if (mapHeight <= stageHeight)
			{
				mapY = (stageHeight - selfY) >> 1;
			}
			else
			{
				// 上边沿
				if (selfY <= stageHeightHalf)
				{
					mapY = 0;
				}
				// 下边沿
				else if (selfY > mapHeight - stageHeightHalf )
				{
					mapY = stageHeight - mapHeight;
				}
				else
				{
					mapY = stageHeightHalf - selfY;
				}
			}

			return mapY;
		}

		// =========================
		// Map数据
		// =========================
		public static var currentMapStruct : MapStruct;

		public static function setCurrentMapId(mapId : int) : void
		{
			currentMapId = mapId;
			currentMapStruct = getMapStruct(mapId);
			currentMapAssetId = currentMapStruct.assetId;
			mapWidth = currentMapStruct.mapWidth;
			mapHeight = currentMapStruct.mapHeight;
		}


		/** 地图数据结构 */
		public static function getMapStruct(mapId : uint = 0) : MapStruct
		{
			var mapStruct : MapStruct;
			if (mapId <= 0)
			{
				mapStruct = currentMapStruct;
				if (mapStruct == null) mapStruct = mapConfigData.getMapStruct(WorldStartup.loginMapId);
			}
			else
			{
				mapStruct = mapConfigData.getMapStruct(mapId);
			}
			return mapStruct;
		}

		// =========================
		// NPC数据
		// =========================
		/** 获取地图NPC数据结构 */
		public static function getNpcStruct(npcId : int, mapId : int = 0) : NpcStruct
		{
			var mapStruct : MapStruct = getMapStruct(mapId);
			if (mapStruct == null) return null;
			return mapStruct.npcDic[npcId];
		}

		/** 获取地图NPC位置 */
		public static function getNpcPosition(npcId : int, mapId : int = 0) : Point
		{
			var npcStruct : NpcStruct = getNpcStruct(npcId, mapId);
			if (npcStruct == null) return null;
			return npcStruct.position;
		}

		/** 获取地图NPC站立位置 */
		public static function getNpcStandPosition(npcId : int, mapId : int = 0, index : int = -1) : Point
		{
			var npcStruct : NpcStruct = getNpcStruct(npcId, mapId);
			if (npcStruct == null) return null;
			if (index == -1 || index > npcStruct.standPostion.length)
			{
				index = Math.floor(npcStruct.standPostion.length * Math.random());
			}
			return npcStruct.standPostion[index];
		}

		// =========================
		// Gate数据
		// =========================
		/** 获取地图八卦阵(出口入口)字典 */
		public static function getGateStructDic(mapId : int = 0) : Dictionary
		{
			var mapStruct : MapStruct = getMapStruct(mapId);
			return mapStruct.linkGates;
		}

		/** 获取地图去某地图的八卦阵(出入口) */
		public static function getGateStruct(toMapId : int = 0, mapId : int = 0) : GateStruct
		{
			var mapStruct : MapStruct = getMapStruct(mapId);
			if (toMapId == mapId || toMapId <= 0 || toMapId == mapStruct.id)
			{
				return mapStruct.freeGate;
			}
			else
			{
				return mapStruct.linkGates[toMapId];
			}
		}
		
		
		/** 获取八卦阵(出入口)根据gateId */
		public static function getGateStructById(gateId : int, mapId : int = 0) : GateStruct
		{
			var mapStruct : MapStruct = getMapStruct(mapId);
				return mapStruct.gateDic[gateId];
		}

		/** 获取地图八卦阵(出入口)位置 */
		public static function getGatePosition(toMapId : int = 0, mapId : int = 0) : Point
		{
			var gateStruct : GateStruct = getGateStruct(toMapId, mapId);
			if (gateStruct == null) return null;
			return gateStruct.position;
		}

		/** 获取地图八卦阵(出入口)位置 */
		public static function getGateCenter(toMapId : int = 0, mapId : int = 0) : Point
		{
			var position : Point = getGatePosition(toMapId, mapId);
			if (position == null) return null;
			return new Point(position.x + 70, position.y + 40);
		}

		/** 获取地图八卦阵(出入口)站立位置 */
		public static function getGateStandPosition(toMapId : int = 0, mapId : int = 0) : Point
		{
			var gateStruct : GateStruct = getGateStruct(toMapId, mapId);
			if (gateStruct == null) return null;
			return gateStruct.standPosition;
		}
	}
}
