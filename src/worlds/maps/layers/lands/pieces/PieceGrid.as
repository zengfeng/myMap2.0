package worlds.maps.layers.lands.pieces
{
	import flash.utils.Dictionary;
	import worlds.maps.configs.LandConfig;
	import worlds.maps.layers.lands.LandUtil;
	import worlds.maps.layers.lands.pools.PiecePositionPool;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-12
     */
    public class PieceGrid
    {
        /** 单例对像 */
        private static var _instance : PieceGrid;

        /** 获取单例对像 */
        static public function get instance() : PieceGrid
        {
            if (_instance == null)
            {
                _instance = new PieceGrid(new Singleton());
            }
            return _instance;
        }

        // ==============
        // 图块绘制状态
        // ==============
        /** 没加载也没画 */
        public const ITEM_NULL : int = 1;
        /** 加载中 */
        public const ITEM_LOADING : int = 2;
        /** 画了高清版 */
        public const ITEM_HD : int = 3;
        private var itemDic : Dictionary = new Dictionary();
        private var piecePositionPool : PiecePositionPool;
        private var itemCountX : int ;
        private var itemCountY : int ;
        private var itemStageCountX : int ;
        private var itemStageCountY : int ;
        private var isItemStageIntX : Boolean;
        private var isItemStageIntY : Boolean;
        private var pieceWidth : uint;
        private var pieceHeight : uint;
        private var itemCount : int;
        private var loadCount : int;
        private var preMapX : int;
        private var preMapY : int;
        private var _isFinish : Boolean;
        public var finishCall : Function;

        function PieceGrid(singleton : Singleton) : void
        {
            singleton;
            piecePositionPool = PiecePositionPool.instance;
            pieceWidth = LandConfig.PIECE_WIDTH;
            pieceHeight = LandConfig.PIECE_HEIGHT;
        }

        public function resetStageSize(stageWidth : int, stageHeight : int) : void
        {
            isItemStageIntX = stageWidth % pieceWidth == 0;
            isItemStageIntY = stageHeight % pieceHeight == 0;
            itemStageCountX = Math.ceil(stageWidth / pieceWidth);
            itemStageCountY = Math.ceil(stageHeight / pieceHeight);
        }

        public function reset(mapWidth : int, mapHeight : int) : void
        {
            dispose();
            this.pieceWidth = pieceWidth;
            this.pieceHeight = pieceHeight;
            _isFinish = false;
            itemCount = 0;
            loadCount = 0;
            itemCountX = mapWidth / pieceWidth;
            itemCountY = mapHeight / pieceHeight;
            var key : String;
            for (var y : int = 0; y < itemCountY; y++)
            {
                for (var x : int = 0; x < itemCountX; x++)
                {
                    key = LandUtil.getPieceKey(x, y);
                    itemDic[key] = ITEM_NULL;
                    itemCount++;
                }
            }
        }

        public function dispose() : void
        {
            var key : String;
            for (key in itemDic)
            {
                delete itemDic[key];
            }
        }

        /** 获取等待加载列表 */
        public function getWaitLoadList(mapX : int, mapY : int, pushList : Vector.<PiecePosition> = null) : Vector.<PiecePosition>
        {
            if (pushList == null) pushList = new Vector.<PiecePosition>();
            var startItemX : int = mapX / pieceWidth;
            var startItemY : int = mapY / pieceHeight;
            var endItemX : int = startItemX + itemStageCountX;
            var endItemY : int = startItemY + itemStageCountY;

            var isStartItemIntX : Boolean = mapX % pieceWidth == 0;
            var  isStartItemIntY : Boolean = mapY % pieceHeight == 0;

            if (mapX < preMapX)
            {
                if ( startItemX != 0)
                {
                    startItemX -= 1;
                    endItemX -= 1;
                }
            }
            else if (!isStartItemIntX && !isItemStageIntX)
            {
                endItemX += 1;
            }

            if (mapY < preMapY)
            {
                if ( startItemY != 0)
                {
                    startItemY -= 1;
                    endItemY -= 1;
                }
            }
            else if (!isStartItemIntY && !isItemStageIntY)
            {
                endItemY += 1;
            }
            if (endItemX >= itemCountX) endItemX = itemCountX - 1;
            if (endItemY >= itemCountY) endItemY = itemCountY - 1;

            preMapX = mapX;
            preMapY = mapY;

            var x : int;
            var y : int;
            var piecePosition : PiecePosition;
            var key : String;
            for (y = startItemY; y <= endItemY; y++)
            {
                for (x = startItemX; x <= endItemX; x++)
                {
                    key = LandUtil.getPieceKey(x, y);
                    if (itemDic[key] != ITEM_NULL)
                    {
                        continue;
                    }
                    piecePosition = piecePositionPool.getObject();
                    piecePosition.mapX = x * pieceWidth;
                    piecePosition.mapY = y * pieceHeight;
                    piecePosition.pieceX = x;
                    piecePosition.pieceY = y;
                    piecePosition.key = key;
                    pushList.push(piecePosition);
                    itemDic[piecePosition.key] = ITEM_LOADING;
                    loadCount++;
                }
            }

            if (loadCount == itemCount)
            {
                isFinish = true;
            }
            return pushList;
        }

        // =================
        // 判断是否绘制高清
        // =================
        public function isDrawHDByKey(key : String) : Boolean
        {
            return itemDic[key] == ITEM_HD;
        }

        public function isDrawHDByPieceXY(pieceX : int, pieceY : int) : Boolean
        {
            var key : String = LandUtil.getPieceKey(pieceX, pieceY);
            return isDrawHDByKey(key);
        }

        // =================
        // 设置绘制高清
        // =================
        public function setItemDrawHD(key : String) : void
        {
            if (itemDic[key] == ITEM_NULL)
            {
                loadCount++;
            }
            itemDic[key] == ITEM_HD;
        }

        /** 是否完成 */
        public function get isFinish() : Boolean
        {
            return _isFinish;
        }

        public function set isFinish(isFinish : Boolean) : void
        {
            _isFinish = isFinish;
            if (_isFinish == true && finishCall != null)
            {
                finishCall.apply();
            }
        }

        /** 获取所有加载列表 */
        public static function getAllLoadList(mapWidth : int, mapHeight : int, pushList : Vector.<PiecePosition> = null) : Vector.<PiecePosition>
        {
            if (pushList == null) pushList = new Vector.<PiecePosition>();
            const PIECE_WIDTH : int = LandConfig.PIECE_WIDTH;
            const PIECE_HEIGHT : int = LandConfig.PIECE_HEIGHT;
            var itemCountX : int = mapWidth / PIECE_WIDTH;
            var itemCountY : int = mapHeight / PIECE_HEIGHT;
            var x : int;
            var y : int;
            var piecePositionPool : PiecePositionPool = PiecePositionPool.instance;
            var piecePosition : PiecePosition;
            var key : String;
            for (y = 0; y < itemCountY; y++)
            {
                for (x = 0; x < itemCountX; x++)
                {
                    key = LandUtil.getPieceKey(x, y);
                    piecePosition = piecePositionPool.getObject();
                    piecePosition.mapX = x * PIECE_WIDTH;
                    piecePosition.mapY = y * PIECE_HEIGHT;
                    piecePosition.pieceX = x;
                    piecePosition.pieceY = y;
                    piecePosition.key = key;
                    pushList.push(piecePosition);
                }
            }
            return pushList;
        }

        /** 获取屏幕内加载列表 */
        public static function getScreenLoadList(mapX : int, mapY : int, mapWidth : int, mapHeight : int, stageWidth : int, stageHeight : int, pushList : Vector.<PiecePosition> = null) : Vector.<PiecePosition>
        {
            if (pushList == null) pushList = new Vector.<PiecePosition>();
            PieceGrid.instance.preMapX = mapX;
            PieceGrid.instance.preMapY = mapY;
            const PIECE_WIDTH : int = LandConfig.PIECE_WIDTH;
            const PIECE_HEIGHT : int = LandConfig.PIECE_HEIGHT;
            var  isItemStageIntX : Boolean = stageWidth % PIECE_WIDTH == 0;
            var  isItemStageIntY : Boolean = stageHeight % PIECE_HEIGHT == 0;
            var  itemStageCountX : int = Math.ceil(stageWidth / PIECE_WIDTH);
            var  itemStageCountY : int = Math.ceil(stageHeight / PIECE_HEIGHT);
            var itemCountX : int = mapWidth / PIECE_WIDTH;
            var itemCountY : int = mapHeight / PIECE_HEIGHT;

            var startItemX : int = mapX / PIECE_WIDTH;
            var startItemY : int = mapY / PIECE_HEIGHT;
            var endItemX : int = startItemX + itemStageCountX;
            var endItemY : int = startItemY + itemStageCountY;

            var isStartItemIntX : Boolean = mapX % PIECE_WIDTH == 0;
            var  isStartItemIntY : Boolean = mapY % PIECE_HEIGHT == 0;
            if (!isStartItemIntX && !isItemStageIntX)
            {
                endItemX += 1;
            }

            if (!isStartItemIntY && !isItemStageIntY)
            {
                endItemY += 1;
            }
            if (endItemX >= itemCountX) endItemX = itemCountX - 1;
            if (endItemY >= itemCountY) endItemY = itemCountY - 1;

            var x : int;
            var y : int;
            var piecePosition : PiecePosition;
            var piecePositionPool : PiecePositionPool = PiecePositionPool.instance;
            var key : String;
            for (y = startItemY; y <= endItemY; y++)
            {
                for (x = startItemX; x <= endItemX; x++)
                {
                    key = LandUtil.getPieceKey(x, y);
                    piecePosition = piecePositionPool.getObject();
                    piecePosition.mapX = x * PIECE_WIDTH;
                    piecePosition.mapY = y * PIECE_HEIGHT;
                    piecePosition.pieceX = x;
                    piecePosition.pieceY = y;
                    piecePosition.key = key;
                    pushList.push(piecePosition);
                }
            }
            return pushList;
        }
    }
}
class Singleton
{
}