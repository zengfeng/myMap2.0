package worlds.maps.layers.lands
{
	import worlds.auxiliarys.EnterFrameListener;
	import worlds.auxiliarys.MapStage;
	import worlds.auxiliarys.loads.LoadManager;
	import worlds.auxiliarys.loads.expands.PieceLoader;
	import worlds.auxiliarys.loads.pools.PieceLoaderPool;
	import worlds.maps.layers.lands.pieces.PieceGrid;
	import worlds.maps.layers.lands.pieces.PiecePosition;
	import worlds.maps.preloads.MapPreload;



    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-16
     */
    public class LandInstall
    {
        /** 单例对像 */
        private static var _instance : LandInstall;

        /** 获取单例对像 */
        static public function get instance() : LandInstall
        {
            if (_instance == null)
            {
                _instance = new LandInstall(new Singleton());
            }
            return _instance;
        }

        // ===========
        // 变量
        // ===========
        private var mapId : int;
        private var isFullModel : Boolean ;
        private var mapWidth : int;
        private var mapHeight : int;
        private var mapPreload : MapPreload;
        private var landLayer : LandLayer;
        private var pieceGrid : PieceGrid;
        private var pieceLoaderPool : PieceLoaderPool;
        private var loadManager : LoadManager;

        function LandInstall(singleton : Singleton) : void
        {
            singleton;
            landLayer = LandLayer.instance;
            mapPreload = MapPreload.instance;
            pieceGrid = PieceGrid.instance;
            pieceLoaderPool = PieceLoaderPool.instance;
            loadManager = LoadManager.instance;
        }

        /** 预设 */
        public function preset(mapId : int, mapWidth : int, mapHeight : int, isFullModel : Boolean) : void
        {
            EnterFrameListener.remove(startLoadPieceHD);
            EnterFrameListener.remove(startDrawPieceHD);
            loading = false;
            drawing = false;
            loadFrame = 0;
            this.mapId = mapId;
            this.isFullModel = isFullModel;
            this.mapWidth = mapWidth;
            this.mapHeight = mapHeight;
            clearPieceLoaderLoaded();
            MapStage.removeStageResize(onStageResize);
            pieceGrid.resetStageSize(MapStage.stageWidth, MapStage.stageHeight);
            pieceGrid.reset(mapWidth, mapHeight);
            landLayer.reset(mapWidth, mapHeight);
            LoadManager.instance.signalPieceComplete.remove(pieceLoader_completeHandler);
        }

        /** 安装 */
        public function install() : void
        {
            inistallCommon();
            if (isFullModel)
            {
                inistallFullMode();
            }
            else
            {
                inistallSectionMode();
            }
        }

        private function onStageResize(stageWidth : int, stageHeight : int) : void
        {
            pieceGrid.resetStageSize(stageWidth, stageHeight);
        }

        /** 安装公共 */
        public function inistallCommon() : void
        {
            if (mapPreload.blurLandLoader)
            {
                landLayer.drawBlurLand(mapPreload.blurLandLoader.getBitmapData());
                mapPreload.blurLandLoader.unloadAndStop(true);
            }

            var pieceLoaderList : Vector.<PieceLoader> = mapPreload.pieceLoaderList;
            var pieceLoader : PieceLoader;
            var piecePosition : PiecePosition;
            var length : int = pieceLoaderList.length;
            for (var i : int = 0; i < length; i++)
            {
                pieceLoader = pieceLoaderList[i];
				if(pieceLoader.isLoaded == false)
				{
					continue;
				}
                piecePosition = pieceLoader.piecePosition;
                landLayer.drawPieceHD(pieceLoader.getData(), piecePosition.pieceX, piecePosition.pieceY);
                pieceGrid.setItemDrawHD(piecePosition.key);
            }
            mapPreload.clear(true);
        }

        /** 完全安装模式 */
        public function inistallFullMode() : void
        {
        }

        /** 部分安装模式 */
        public function inistallSectionMode() : void
        {
            MapStage.addStageResize(onStageResize);
            LoadManager.instance.signalPieceComplete.add(pieceLoader_completeHandler);
        }

        private var piecePositionList : Vector.<PiecePosition> = new Vector.<PiecePosition>();
        private var pieceLoaderLoaded : Vector.<PieceLoader> = new Vector.<PieceLoader>();

        private function clearPieceLoaderLoaded() : void
        {
            while (pieceLoaderLoaded.length > 0)
            {
                (pieceLoaderLoaded.pop() as  PieceLoader).unloadAndStop(true);
            }

            while (piecePositionList.length > 0)
            {
                (piecePositionList.pop() as PiecePosition).dispose();
            }
        }
		
        /** 加载地图位置陆地块 */
        public function loadMapPosition(mapX : int, mapY : int) : void
        {
            // landLayer.x = -mapX;
            // landLayer.y = -mapY;
            if (isFullModel) return;
            PieceGrid.instance.getWaitLoadList(mapX, mapY, piecePositionList);
            if (loading == false)
            {
                loading = true;
                EnterFrameListener.add(startLoadPieceHD);
            }
        }

        private var loading : Boolean;
        private var loadFrame : int = 0;

        private function startLoadPieceHD() : void
        {
            loadFrame++;
            if (loadFrame % 2 != 0)
            {
                return;
            }
            var pieceLoader : PieceLoader;
            if (piecePositionList.length > 0)
            {
                pieceLoader = pieceLoaderPool.getObject(piecePositionList.pop(), mapId);
                loadManager.load(pieceLoader);
                return;
            }
            EnterFrameListener.remove(startLoadPieceHD);
            loading = false;
        }

        private function pieceLoader_completeHandler(pieceLoader : PieceLoader) : void
        {
            pieceLoaderLoaded.push(pieceLoader);
            if (drawing == false)
            {
                drawing = true;
                EnterFrameListener.add(startDrawPieceHD);
            }
        }

        private var drawing : Boolean;
        private var drawFrame : int = 0;

        private function startDrawPieceHD() : void
        {
            drawFrame++;
            if (drawFrame % 3 != 0)
            {
                return;
            }
            var pieceLoader : PieceLoader;
            var piecePosition : PiecePosition;
            if (pieceLoaderLoaded.length > 0)
            {
                pieceLoader = pieceLoaderLoaded.pop();
                piecePosition = pieceLoader.piecePosition;
                landLayer.drawPieceHD(pieceLoader.getData(), piecePosition.pieceX, piecePosition.pieceY);
                pieceGrid.setItemDrawHD(piecePosition.key);
                pieceLoader.unloadAndStop(false);
                return;
            }
            drawing = false;
            EnterFrameListener.remove(startDrawPieceHD);
        }
    }
}
class Singleton
{
}
