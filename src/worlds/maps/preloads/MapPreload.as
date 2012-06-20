package worlds.maps.preloads
{
	import worlds.auxiliarys.loads.expands.MaskLoader;
	import worlds.auxiliarys.loads.LoadManager;
	import worlds.auxiliarys.loads.core.LoaderCore;
	import worlds.auxiliarys.loads.expands.BlurLandLoader;
	import worlds.auxiliarys.loads.expands.PathLoader;
	import worlds.auxiliarys.loads.expands.PieceLoader;
	import worlds.auxiliarys.mediators.MSignal;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class MapPreload
    {
        /** 单例对像 */
        private static var _instance : MapPreload;

        /** 获取单例对像 */
        static public function get instance() : MapPreload
        {
            if (_instance == null)
            {
                _instance = new MapPreload(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var loadManager : LoadManager;
        public var signalComplete : MSignal;
		public var signalProgress:MSignal;
        public var pathLoader : PathLoader;
        public var blurLandLoader : BlurLandLoader;
		public var maskLoader:MaskLoader;
        public var pieceLoaderList : Vector.<PieceLoader>;

        function MapPreload(singleton : Singleton)
        {
            singleton;
            loadManager = LoadManager.instance;
            pieceLoaderList = new Vector.<PieceLoader>();
            signalComplete = new MSignal();
            signalProgress = new MSignal();
        }

        public function reset(mapId : int, mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, mapAssetId : int, isFullMode:Boolean, hasMask:Boolean = false) : void
        {
            if (!mapAssetId || mapAssetId < 0) mapAssetId = mapId;
            loadManager.clear();
            clear(true);
            var preloadData : PreloadData;
            if (!isFullMode)
            {
                preloadData = PreloadDataScreen.instance;
            }
            else
            {
                preloadData = PreloadDataFull.instance;
            }
            preloadData.setLoad(mapId, mapX, mapY, mapWidth, mapHeight, stageWidth, stageHeight, mapAssetId, hasMask);
        }

        public function startLoad() : void
        {
            // 寻路数据
            if (pathLoader)
            {
                loadManager.append(pathLoader);
            }

            // 模糊陆地
            if (blurLandLoader)
            {
                loadManager.append(blurLandLoader);
            }
			
			//遮罩数据
			if(maskLoader)
			{
                loadManager.append(maskLoader);
			}

            // 地图块列表
            var length : int = pieceLoaderList.length;
            for (var i : int = 0; i < length; i++)
            {
                loadManager.append(pieceLoaderList[i]);
            }

            loadManager.signalProgress.add(progress);
            loadManager.signalComplete.add(complete);
            loadManager.startLoad();
        }

        public function complete() : void
        {
            loadManager.signalProgress.remove(progress);
            loadManager.signalComplete.remove(complete);
            signalComplete.dispatch();
        }

        public function progress(overNum : int, totalNum : int) : void
        {
			signalProgress.dispatch(overNum, totalNum);
//			MapPreloadManager.instance.setLoadMapProgress(int((overNum / totalNum) * 100));
        }

        public function clear(gc : Boolean = false) : void
        {
            if (pathLoader) pathLoader.unloadAndStop(gc);
            if (blurLandLoader) blurLandLoader.unloadAndStop(gc);
			if(maskLoader) maskLoader.unloadAndStop(gc);
            while (pieceLoaderList.length > 0)
            {
                (pieceLoaderList.pop() as LoaderCore).unloadAndStop(gc);
            }
        }
    }
}
class Singleton
{
}