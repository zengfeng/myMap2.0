package worlds.maps.preloads
{
	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
	 */
	public class PreloadDataScreen extends PreloadData
	{
		/** 单例对像 */
		private static var _instance : PreloadDataScreen;

		/** 获取单例对像 */
		static public function get instance() : PreloadDataScreen
		{
			if (_instance == null)
			{
				_instance = new PreloadDataScreen(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function PreloadDataScreen(singleton : Singleton) : void
		{
			singleton;
			super();
		}

		override public function setLoad(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int, hasMask : Boolean) : void
		{
			if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
			setPathLoader(mapAssetId);
			setBlurLandLoader(mapAssetId);
			if (hasMask)
			{
				setMaskLoader(mapAssetId);
			}
			else
			{
				setMaskLoaderNull();
			}
			setPieceScreenLoaderList(mapAssetId, mapX, mapY, mapWidth, mapHeight, stageWidth, stageHeight);
		}
	}
}
class Singleton
{
}
