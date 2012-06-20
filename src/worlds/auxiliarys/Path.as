package worlds.auxiliarys
{
	import cmodule.pathc.CLibInit;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import worlds.apis.BarrierOpened;
	import worlds.apis.MapUtil;
	import worlds.auxiliarys.mediators.MSignal;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class Path
	{
		function Path() : void
		{
			lib = new CLibInit();
			arithmetic = lib.init();
			setPathSizeFun = arithmetic["setMapSize"];
			writePathDataFun = arithmetic["setMapData"];
			findPathFun = arithmetic["findMapPath"];
			setBlockFun = arithmetic["setBlock"];

			findByteArray = new ByteArray();
			findByteArray.endian = Endian.LITTLE_ENDIAN;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var lib : CLibInit;
		private var arithmetic : *;
		private var setPathSizeFun : Function;
		private var writePathDataFun : Function;
		private var findPathFun : Function;
		private var setBlockFun : Function;
		private var writeComplete : Boolean = false;
		private var width : int;
		private var height : int;
		private var tileData : Vector.<uint> = new  Vector.<uint>();
		private var alchemyByteArray : ByteArray = new ByteArray();
		public  var signalWriteProgress : MSignal = new MSignal(uint, uint);
		public  var signalWriteComplete : MSignal = new MSignal();

		public function reset(byteArray : ByteArray) : void
		{
			if (byteArray == null || byteArray.length == 0)
			{
				throw new Error("Path::reset 数据出错，有可能path文件不存在");
				return;
			}
			clearup();
			signalWriteComplete.add(initBarrier);
			decodePathFile(byteArray);
			writeData();
		}
		
		
		/** 清理 */
		public function clearup() : void
		{
			writeComplete = false;
			alchemyByteArray.clear();
			tileData = new Vector.<uint>();
			var arr : Array = [];
			for (var key:String in openedBarrierDic)
			{
				arr.push(key);
			}

			while (arr.length > 0)
			{
				delete openedBarrierDic[arr.pop()];
			}

			openedBarrierDic[0] = false;
			openedBarrierDic[255] = true;
		}

		/** 反编码path文件数据 */
		private function decodePathFile(ba : ByteArray) : void
		{
			width = ba.readInt() ;
			height = ba.readInt() ;
			while ( ba.position < ba.length )
			{
				var b : int = ba.readByte() ;
				b = b >= 0 ? b : ((-1 ^ b) ^ 0xFF) ;

				var rep : int = ba.readByte() ;
				rep = rep >= 0 ? rep : ((-1 ^ rep) ^ 0xFF) ;

				for ( var i : int = 0 ; i < rep ; ++i )
				{
					tileData.push(b);
				}
			}
			ba.clear();
		}

		// =======================
		// 设置关卡开放
		// =======================
		private var openedBarrierDic : Dictionary = new Dictionary();

		/** 初始化路障 */
		private function initBarrier() : void
		{
			setBarrier(255, true);
			var dic : Dictionary = BarrierOpened.dic;
			for (var key:String in dic)
			{
				setBarrier(parseInt(key), dic[key]);
			}
			BarrierOpened.signalState.add(setBarrier);
		}

		public function setBarrier(barrierId : uint, isOpened : Boolean) : void
		{
			openedBarrierDic[barrierId] = isOpened;
			setBlockFun(barrierId, isOpened ? 1 : 0);
		}

		/** 获取路径点的颜色ID */
		private function getPixel(pathX : int, pathY : int) : int
		{
			var index : int = pathY * width + pathX;
			if (index > tileData.length) return 0;
			return tileData[index];
		}

		/** 获取路径点是否开放 */
		private function isOpened(pathX : int, pathY : int) : Boolean
		{
			return openedBarrierDic[getPixel(pathX, pathY)];
		}

		// =======================
		// 写入寻路数据
		// =======================
		private function writeData() : void
		{
			writeComplete = false;
			clearTimeout(writePathTimer);
			setPathSizeFun(width, height);
			line = 0;
			lineNum = 128 ;
			startWriteData();
		}

		private var line : int;
		private var lineNum : int = 128;
		private var writePathTime : int;
		private var writePathTimer : uint;

		private function startWriteData() : void
		{
			clearTimeout(writePathTimer);
			writePathTime = writePathTime;
			while (line < height)
			{
				if ((height - line ) < lineNum) lineNum = height - line;
				writeDataLine(line, lineNum);
				line += lineNum;
				signalWriteProgress.dispatch(line, height);
				if (getTimer() - writePathTime > 100)
				{
					writePathTimer = setTimeout(startWriteData, 20);
					return;
				}
			}
			writeComplete = true;
			signalWriteComplete.dispatch();
		}

		private function writeDataLine(line : int, lineNum : int) : void
		{
			encodAlchemyByteArray(line, lineNum);
			alchemyByteArray.position = 0;
			writePathDataFun(line, lineNum, alchemyByteArray);
			alchemyByteArray.clear();
		}

		/** 编码炼金术所需数据 */
		private function encodAlchemyByteArray(line : int, lineNum : int) : void
		{
			var i : int = line * width;
			var end : int = i + lineNum * width;
			alchemyByteArray.clear();
			alchemyByteArray.position = 0;
			for (i; i < end; i++)
			{
				alchemyByteArray.writeByte(tileData[i]);
			}
		}

		// =======================
		// 寻路
		// =======================
		private var pathPoinList : Vector.<MapPoint> = new Vector.<MapPoint>();
		private var mapPoint : MapPoint;
		private var mapPointPool : MapPointPool = MapPointPool.instance;
		private var pathFromX : int;
		private var pathFromY : int;
		private var pathToX : int;
		private var pathToY : int;
		private var pathFromPoint : MapPoint;
		private var pathToPoint : MapPoint;
		private var findByteArray : ByteArray;

		public function find(mapFromX : int, mapFromY : int, mapToX : int, mapToY : int, pushList : Vector.<MapPoint> = null) : Vector.<MapPoint>
		{
			if (pushList == null) pushList = pathPoinList;
			while (pushList.length > 0)
			{
				mapPoint = pushList.shift();
				mapPoint.destory();
			}
			if (writeComplete == false)
			{
				pushList.push(mapPointPool.getObject(mapToX, mapToY));
				return pushList;
			}

			pathFromX = MapUtil.mapToPathX(mapFromX);
			pathFromY = MapUtil.mapToPathY(mapFromY);
			pathToX = MapUtil.mapToPathX(mapToX);
			pathToY = MapUtil.mapToPathY(mapToY);
			pathFromPoint = getLatestCanWalkPoint(pathFromX, pathFromY);
			pathToPoint = getLatestCanWalkPoint(pathToX, pathToY);
			if (pathFromPoint == null || pathToPoint == null) return pushList;
			findByteArray.position = 0;
			findPathFun(pathFromPoint.x, pathFromPoint.y, pathToPoint.x, pathToPoint.y, findByteArray);
			pathFromPoint.destory();
			pathToPoint.destory();

			findByteArray.position = 0;
			while (findByteArray.position < findByteArray.length)
			{
				var x : int = findByteArray.readInt();
				var y : int = x >>> 16;
				x &= 0xFFFF;
				pushList.push(mapPointPool.getObject(MapUtil.pathToMapX(x), MapUtil.pathToMapY(y)));
			}
			findByteArray.clear();

			if (pushList.length > 1)
			{
				mapPoint = pushList[0];
				var distance : Number = MapMath.distance(mapFromX, mapFromY, mapPoint.x, mapPoint.y);
				if (distance < 40)
				{
					pushList.shift();
				}
			}
			return pushList;
		}

		/** 获取最近能走的点 */
		private function getLatestCanWalkPoint(pathX : int, pathY : int) : MapPoint
		{
			var point : MapPoint = mapPointPool.getObject(pathX, pathY);
			if (isOpened(point.x, point.y)) return point;

			var step : uint = 1;
			var isFind : Boolean = false;
			while (!isFind)
			{
				// 左边
				if (point.x - step > 0)
				{
					if (isOpened(point.x - step, point.y))
					{
						isFind = true;
						point.x -= step;
						return point;
					}
				}

				// 右边
				if (point.x + step < width)
				{
					if (isOpened(point.x + step, point.y))
					{
						isFind = true;
						point.x += step;
						return point;
					}
				}

				// 上边
				if (point.y - step > 0)
				{
					if (isOpened(point.x, point.y - step))
					{
						isFind = true;
						point.y -= step;
						return point;
					}
				}

				// 下边
				if (point.y + step > 0)
				{
					if (isOpened(point.x, point.y + step))
					{
						isFind = true;
						point.y += step;
						return point;
					}
				}

				// 左上
				if (point.x - step > 0 && point.y - step > 0)
				{
					if (isOpened(point.x - step, point.y - step))
					{
						isFind = true;
						point.x -= step;
						point.y -= step;
						return point;
					}
				}

				// 右上
				if (point.x + step < width && point.y - step > 0)
				{
					if (isOpened(point.x + step, point.y - step))
					{
						isFind = true;
						point.x += step;
						point.y -= step;
						return point;
					}
				}

				// 左下
				if (point.x - step > 0 && point.y + step < height)
				{
					if (isOpened(point.x - step, point.y + step))
					{
						isFind = true;
						point.x -= step;
						point.y += step;
						return point;
					}
				}

				// 右下
				if (point.x + step < width && point.y + step < height)
				{
					if (isOpened(point.x + step, point.y + step))
					{
						isFind = true;
						point.x += step;
						point.y += step;
						return point;
					}
				}

				step += 2;
				if (step >= 500) break;
			}
			return null;
		}
		
	}
}
