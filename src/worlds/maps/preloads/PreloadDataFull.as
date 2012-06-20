package worlds.maps.preloads
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class PreloadDataFull extends PreloadData
    {
        /** 单例对像 */
        private static var _instance : PreloadDataFull;

        /** 获取单例对像 */
        static public function get instance() : PreloadDataFull
        {
            if (_instance == null)
            {
                _instance = new PreloadDataFull(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        function PreloadDataFull(singleton : Singleton) : void
        {
            singleton;
            super();
        }

        override public function setLoad(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int, hasMask:Boolean) : void
        {
			mapX;
			mapY;
			stageWidth;
			stageHeight;
            if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
            setPathLoader(mapAssetId);
            setBlurLandLoaderNull();
			if(hasMask)
			{
				setMaskLoader(mapAssetId);
			}
			else
			{
				setMaskLoaderNull();
			}
            setPieceAllLoaderList(mapAssetId, mapWidth, mapHeight);
        }
    }
}
class Singleton
{
}
