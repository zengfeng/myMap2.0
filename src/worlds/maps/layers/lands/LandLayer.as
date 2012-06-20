package worlds.maps.layers.lands
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import worlds.auxiliarys.PointShape;
	import worlds.auxiliarys.grids.ConstantSizeGenerateGrid;
	import worlds.auxiliarys.grids.Grid;
	import worlds.auxiliarys.grids.GridItem;
	import worlds.maps.configs.LandConfig;
	import worlds.maps.layers.lands.pools.BitmapDataPool;
	import worlds.maps.layers.lands.pools.BitmapPool;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-16
	 */
	public class LandLayer extends Sprite
	{
		/** 单例对像 */
		private static var _instance : LandLayer;

		/** 获取单例对像 */
		static public function get instance() : LandLayer
		{
			if (_instance == null)
			{
				_instance = new LandLayer(new Singleton());
			}
			return _instance;
		}

		// ===========
		// 配置
		// ===========
		/** 网格单元格宽 */
		private var GRID_ITEM_WIDTH : int;
		/** 网格单元格高 */
		private var GRID_ITEM_HEIGHT : int;
		/** 陆地块宽 */
		private var PIECE_WIDTH : int;
		/** 陆地块高 */
		private var PIECE_HEIGHT : int;
		/** 陆地块小格宽 */
		private var PIECE_TILE_WIDTH : int;
		/** 陆地块小格高 */
		private var PIECE_TILE_HEIGHT : int;
		// ===========
		// 绘制地图高宽的两个点
		// ===========
		private var leftTopPointShape : PointShape;
		private var rightBottomPointShape : PointShape;
		// ===========
		// 网格区块Bitmap
		// ===========
		private var bitmapGrid : Grid;
		private var bitmapDic : Dictionary;
		private var bitmapList : Vector.<Bitmap>;
		private var bitmapPool : BitmapPool;
		private var bitmapDataPool : BitmapDataPool;
		// ===========
		// 地图宽高
		// ===========
		private var mapWidth : int;
		private var mapHeight : int;

		public function LandLayer(singleton : Singleton)
		{
			singleton;
		}

		public function init() : void
		{
			this.mouseChildren = false;
			this.mouseEnabled = true;
			GRID_ITEM_WIDTH = LandConfig.GRID_ITEM_WIDTH;
			GRID_ITEM_HEIGHT = LandConfig.GRID_ITEM_HEIGHT;
			PIECE_WIDTH = LandConfig.PIECE_WIDTH;
			PIECE_HEIGHT = LandConfig.PIECE_HEIGHT;
			PIECE_TILE_WIDTH = LandConfig.PIECE_TILE_WIDTH;
			PIECE_TILE_HEIGHT = LandConfig.PIECE_TILE_HEIGHT;
			GRID_ITEM_PIECE_COUNT_X = GRID_ITEM_WIDTH / PIECE_WIDTH;
			GRID_ITEM_PIECE_COUNT_Y = GRID_ITEM_HEIGHT / PIECE_HEIGHT;

			bitmapDic = new Dictionary(true);
			bitmapList = new Vector.<Bitmap>();
			bitmapGrid = new Grid();

			bitmapPool = BitmapPool.instance;
			bitmapDataPool = BitmapDataPool.instance;

			leftTopPointShape = new PointShape();
			rightBottomPointShape = new PointShape();
			addChild(leftTopPointShape);
			addChild(rightBottomPointShape);

			pieceHDRectangle = new Rectangle(0, 0, PIECE_WIDTH, PIECE_HEIGHT);
			pieceHDPoint = new Point();
			pieceTileHDRectangle = new Rectangle(0, 0, PIECE_TILE_WIDTH, PIECE_TILE_HEIGHT);
			pieceTileHDPoint = new Point();
		}


		/**  重设  */
		public function reset(mapWidth : int, mapHeight : int) : void
		{
			dispose();
			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;
			resetGrid(mapWidth, mapHeight);
			rightBottomPointShape.x = mapWidth - rightBottomPointShape.width;
			rightBottomPointShape.y = mapHeight - rightBottomPointShape.height;
			addChild(rightBottomPointShape);
			// drawRandom();
		}

		public function drawRandom() : void
		{
			graphics.clear();
			var size : int = mapWidth / 10;
			var countX : int = mapWidth / size;
			var countY : int = mapHeight / size;
			for (var y : int = 0; y < countY; y++)
			{
				for (var x : int = 0; x < countX; x++)
				{
					graphics.beginFill(Math.random() * 0xFFFFFF, Math.random() * 0.5 + 0.3);
					graphics.drawRect(x * size, y * size, size, size);
					graphics.endFill();
				}
			}
			// cacheAsBitmap = true;
		}

		/**  析构释放内存  */
		public function dispose() : void
		{
		}

		// ========================
		// 网格区块
		// ========================
		private function resetGrid(mapWidth : int, mapHeight : int) : void
		{
			disposeGride(mapWidth, mapHeight);

			bitmapGrid.reset(mapWidth, mapHeight, GRID_ITEM_WIDTH, GRID_ITEM_HEIGHT, ConstantSizeGenerateGrid);
			var gridItem : GridItem;
			var bitmap : Bitmap;
			var bitmapData : BitmapData;
			var key : String;
			var items : Vector.<GridItem> = bitmapGrid.items;
			var length : int = items.length;
			for (var i : int = 0; i < length; i++)
			{
				gridItem = items[i];
				key = LandUtil.getGridItemKey(gridItem.itemX, gridItem.itemY);
				bitmap = bitmapDic[key];
				if (bitmap)
				{
					continue;
				}

				if (gridItem.isNormalSize )
				{
					bitmapData = bitmapDataPool.getObject();
				}
				else
				{
					bitmapData = new BitmapData(gridItem.width, gridItem.height, false, Math.random() * 0x666666 + 0x2222);
				}
				bitmap = bitmapPool.getObject();
				bitmap.bitmapData = bitmapData;
				bitmap.smoothing = true;
				bitmap.x = gridItem.mapX;
				bitmap.y = gridItem.mapY;
				bitmapDic[key] = bitmap;
				bitmapList.push(bitmap);
				addChild(bitmap);
			}
		}

		private var kerArr : Array = [];

		private function disposeGride(mapWidth : int, mapHeight : int) : void
		{
			var bitmap : Bitmap;
			var key : String;
			var normalInX : int = int(mapWidth / GRID_ITEM_WIDTH) * GRID_ITEM_WIDTH ;
			var normalInY : int = int(mapHeight / GRID_ITEM_HEIGHT) * GRID_ITEM_HEIGHT ;

			var isNormalBitmapData : Boolean ;
			for (key in bitmapDic)
			{
				bitmap = bitmapDic[key];
				isNormalBitmapData = bitmap.bitmapData.width == GRID_ITEM_WIDTH && bitmap.bitmapData.height == GRID_ITEM_HEIGHT;
				if (bitmap.x < normalInX && bitmap.y < normalInY && isNormalBitmapData)
				{
					continue;
				}

				if (isNormalBitmapData)
				{
					bitmap.bitmapData.dispose();
					// bitmapDataPool.destoryObject(bitmap.bitmapData);
				}
				else
				{
					bitmap.bitmapData.dispose();
				}
				bitmapList.splice(bitmapList.indexOf(bitmap), 1) ;
				removeChild(bitmap);
				bitmap.bitmapData = null;
				kerArr.push(key);
				bitmapPool.destoryObject(bitmap);
			}

			while (kerArr.length)
			{
				key = kerArr.pop();
				bitmapDic[key] = null;
				delete bitmapDic[key];
			}
		}

		// ========================
		// 获取区块
		// ========================
		/** 用key 获取区块 */
		private function getGridItemBimapByKey(key : String) : Bitmap
		{
			return bitmapDic[key];
		}

		/** 用地图坐标 获取区块 */
		private function getGridItemBimapByMapXY(mapX : int, mapY : int) : Bitmap
		{
			var gridItemX : int = LandUtil.mapToGridX(mapX);
			var gridItemY : int = LandUtil.mapToGridY(mapY);
			var key : String = LandUtil.getGridItemKey(gridItemX, gridItemY);
			return getGridItemBimapByKey(key);
		}

		// ========================
		// 绘制
		// ========================
		/** 绘制模糊陆地 */
		public function drawBlurLand(blurLand : BitmapData) : void
		{
			var rectangle : Rectangle = new Rectangle();
			var matrix : Matrix = new Matrix();
			matrix.a = mapWidth / blurLand.width;
			matrix.d = mapHeight / blurLand.height;
			var bitmap : Bitmap;
			var bitmapData : BitmapData;
			for each (bitmap in bitmapDic)
			{
				bitmapData = bitmap.bitmapData;
				rectangle.width = bitmapData.width;
				rectangle.height = bitmapData.height;
				matrix.tx = -bitmap.x;
				matrix.ty = - bitmap.y;
				bitmapData.draw(blurLand, matrix, null, null, rectangle);
			}

			blurLand.dispose();
		}

		private var pieceHDRectangle : Rectangle;
		private var pieceHDPoint : Point;
		private var GRID_ITEM_PIECE_COUNT_X : int;
		private var GRID_ITEM_PIECE_COUNT_Y : int;

		/** 绘制高清陆地块 */
		public function drawPieceHD(pieceBitmapData : BitmapData, pieceX : int, pieceY : int) : void
		{
			var mapX : int = LandUtil.pieceToMapX(pieceX);
			var mapY : int = LandUtil.pieceToMapY(pieceY);
			var bitmap : Bitmap = getGridItemBimapByMapXY(mapX, mapY);
			var bitmapData : BitmapData = bitmap.bitmapData;
			pieceHDPoint.x = (pieceX % GRID_ITEM_PIECE_COUNT_X) * PIECE_WIDTH;
			pieceHDPoint.y = (pieceY % GRID_ITEM_PIECE_COUNT_Y) * PIECE_HEIGHT;
			bitmapData.copyPixels(pieceBitmapData, pieceHDRectangle, pieceHDPoint);
			pieceBitmapData.dispose();
		}

		private var pieceTileHDRectangle : Rectangle;
		private var pieceTileHDPoint : Point;

		/** 绘制高清陆地块 */
		public function drawPieceTileHD(pieceBitmapData : BitmapData, pieceX : int, pieceY : int, pieceTileX : int, pieceTileY : int) : void
		{
			var mapX : int = LandUtil.pieceToMapX(pieceX);
			var mapY : int = LandUtil.pieceToMapY(pieceY);
			var bitmap : Bitmap = getGridItemBimapByMapXY(mapX, mapY);
			var bitmapData : BitmapData = bitmap.bitmapData;
			pieceTileHDPoint.x = (pieceX % GRID_ITEM_PIECE_COUNT_X) * PIECE_WIDTH + pieceTileX * PIECE_TILE_WIDTH;
			pieceTileHDPoint.y = (pieceY % GRID_ITEM_PIECE_COUNT_Y) * PIECE_HEIGHT + pieceTileY * PIECE_TILE_HEIGHT;
			bitmapData.copyPixels(pieceBitmapData, pieceTileHDRectangle, pieceTileHDPoint);
			pieceBitmapData.dispose();
		}
	}
	
}
class Singleton
{
}