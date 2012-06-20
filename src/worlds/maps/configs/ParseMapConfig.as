package worlds.maps.configs
{
	import game.manager.RSSManager;
	import game.module.quest.VoNpc;

	import worlds.maps.configs.structs.GateStruct;
	import worlds.maps.configs.structs.MapStruct;
	import worlds.roles.structs.NpcStruct;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// ============================
	public class ParseMapConfig
	{
		private static var makMaps:Array = [1, 2];
		public static function parse(mapXmlDic : Dictionary) : void
		{
			var mapDic : Dictionary = MapConfigData.instance.mapDic;
			for each (var map:XML in mapXmlDic)
			{
				var mapXml : XMLList = map.child("scene");
				var mapStruct : MapStruct = new MapStruct();
				// 地图基本信息
				mapStruct.id = int(mapXml.attribute("id"));
				mapStruct.assetId = int(mapXml.attribute("assetsMapId")) ;
				mapStruct.assetId = mapStruct.assetId ? mapStruct.assetId : mapStruct.id ;
				mapStruct.name = mapXml.attribute("name");
				mapStruct.mapWidth = int(mapXml.attribute("width"));
				mapStruct.mapHeight = int(mapXml.attribute("height"));
				mapStruct.pieceCountX = mapStruct.mapWidth / LandConfig.PIECE_WIDTH;
				mapStruct.pieceCountY = mapStruct.mapHeight / LandConfig.PIECE_HEIGHT;
				mapStruct.mapWidth = mapStruct.pieceCountX * LandConfig.PIECE_WIDTH;
				mapStruct.mapHeight = mapStruct.pieceCountY * LandConfig.PIECE_HEIGHT;
				mapStruct.hasMask =makMaps.indexOf(mapStruct.id) != -1;

				// NPC数据
				var npcStruct : NpcStruct;
				var voNpc : VoNpc;
				var pointXmlList : XMLList;
				var max : int;
				var j : int;
				var npcXml : XMLList = mapXml.child("npc");
				var npcId : int;
				for (var i : int = 0; i < npcXml.length(); i++)
				{
					npcId = npcXml[i].@id;
					voNpc = RSSManager.getInstance().getNpcById(npcId);
					if (!voNpc) continue;
					voNpc.mapId = mapStruct.id;
					voNpc.x = npcXml[i].@x;
					voNpc.y = npcXml[i].@y;
					npcStruct = new NpcStruct();
					npcStruct.id = npcId;
					npcStruct.name = voNpc.name;
					npcStruct.avatarId = voNpc.avatarId;
					npcStruct.x = voNpc.x;
					npcStruct.y = voNpc.y ;
					npcStruct.position.x = voNpc.x;
					npcStruct.position.y = voNpc.y;
					npcStruct.isHit = voNpc.isHit;
					npcStruct.hasAvatar = voNpc.hasAvatar;
					npcStruct.moveRadius = npcXml[i].@moveRadius;
					npcStruct.attackRadius = npcXml[i].@attackRadius;
					pointXmlList = npcXml[i]["point"];
					max = pointXmlList.length();
					for (j = 0; j < max; j++)
					{
						npcStruct.standPostion.push(new Point(pointXmlList[j].@x, pointXmlList[j].@y));
					}
					mapStruct.npcDic[npcStruct.id] = npcStruct;
				}

				// 注入gate数据
				var gateXml : XMLList = mapXml.child("gate");
				for (i = 0; i < gateXml.length(); i++)
				{
					var gateStruct : GateStruct = new GateStruct();
					gateStruct.id = gateXml[i].@id;
					gateStruct.x = gateXml[i].@x;
					gateStruct.y = gateXml[i].@y;
					gateStruct.position.x = gateStruct.x ;
					gateStruct.position.y = gateStruct.y ;

					gateStruct.standX = gateXml[i].@standX;
					gateStruct.standY = gateXml[i].@standY;
					gateStruct.standPosition.x = gateStruct.standX ;
					gateStruct.standPosition.y = gateStruct.standY ;
					if (gateXml[i].@kind == "in")
					{
						gateStruct.toMapId = mapStruct.id;
						mapStruct.freeGates[gateStruct.toMapId] = gateStruct;
					}
					else
					{
						gateStruct.toMapId = gateXml[i].@toScene;
						mapStruct.linkGates[gateStruct.toMapId] = gateStruct;
					}
					mapStruct.gateDic[gateStruct.id] = gateStruct;
				}
				mapDic[mapStruct.id] = mapStruct;
			}
		}
	}
}
