package worlds.maps.configs
{
	import flash.utils.Dictionary;
	import worlds.maps.configs.structs.MapStruct;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
     */
    public class MapConfigData
    {
        /** 单例对像 */
        private static var _instance : MapConfigData;

        /** 获取单例对像 */
        static public function get instance() : MapConfigData
        {
            if (_instance == null)
            {
                _instance = new MapConfigData(new Singleton());
            }
            return _instance;
        }

        public function MapConfigData(singleton : Singleton)
        {
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 地图字典,存入 MapStruct 使用 id 做索引 */
        public var mapDic : Dictionary = new Dictionary();

        /** 获取地图数据结构 */
        public function getMapStruct(mapId : uint) : MapStruct
        {
            return mapDic[mapId];
        }
    
    }
}
class Singleton
{
}