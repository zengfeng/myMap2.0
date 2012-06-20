package worlds.maps.configs.structs
{
    import flash.utils.Dictionary;
    import worlds.roles.structs.NpcStruct;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-26 ����7:32:52
     */
    public class MapStruct
    {
        /** 地图ID号 */
        public var id:uint;
        /** 美术资源地图ID */
        public var assetId:int= 0;
        /** 地图名称 */
		public var name:String;
        /** 整个地图的完整宽 */
		public var mapWidth:int;
        /** 整个地图的完整高 */
		public var mapHeight:int;
        /** 整个地图有多少块组成 */
		public var pieceCountX:int;
		public var pieceCountY:int;
		public var hasMask:Boolean = false;
		
		public var gateDic:Dictionary = new Dictionary();
        /** 八卦阵(地图连接门) 存入 GateStruct 使用 toMapId 做索引 */
		public var linkGates:Dictionary	= new Dictionary();
        /** 八卦阵(地图自由传送门) 存入 GateStruct 使用 toMapId 做索引 */
		public var freeGates:Dictionary	= new Dictionary();
		/** 地图NPC字典列表 存入 NpcStruct 使用 id 做索引 */
		public var npcDic:Dictionary = new Dictionary();
        
        /** 获取NPC数据结构 */
        public function getNpcStruct(npcId:uint):NpcStruct
        {
            return npcDic[npcId];
        }
        
        /** 获取本地图的 八卦阵(地图自由传送门)*/
        public function get freeGate():GateStruct
        {
            return freeGates[id];
        }
    }
}
