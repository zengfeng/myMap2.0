package worlds.auxiliarys.loads
{
	import log4a.Logger;
	import worlds.auxiliarys.loads.core.LoaderCore;
	import worlds.auxiliarys.loads.core.LoaderEvent;
	import worlds.auxiliarys.loads.expands.PieceLoader;
	import worlds.auxiliarys.mediators.MSignal;



	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
	 */
	public class LoadManager
	{
		/** 单例对像 */
		private static var _instance : LoadManager;

		/** 获取单例对像 */
		static public function get instance() : LoadManager
		{
			if (_instance == null)
			{
				_instance = new LoadManager(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public static var mapId : int;
		public var signalProgress : MSignal;
		public var signalComplete : MSignal;
		public var signalPieceComplete : MSignal;
		private var GC : Boolean;
		private var MAX_THREAD_COUTN : int;
		private var _isLoadList : Boolean;
		private var _loadingCount : uint ;
		private var _totalNum : int;
		private var _overNum : int;
		private var _waitList : Vector.<LoaderCore>;
		private var _loadingList : Vector.<LoaderCore>;
		private var _loadedList : Vector.<LoaderCore>;
		private var _overitmeList : Vector.<LoaderCore>;

		function LoadManager(singleton : Singleton)
		{
			singleton;
			MAX_THREAD_COUTN = LoadConfig.MAX_THREAD_COUTN;
			GC = LoadConfig.GC;
			_loadingCount = 0;
			_waitList = new Vector.<LoaderCore>();
			_loadingList = new Vector.<LoaderCore>();
			_loadedList = new Vector.<LoaderCore>();
			_overitmeList = new Vector.<LoaderCore>();
			signalProgress = new MSignal(int/** 已加载的 */, int/** 总数 */);
			signalComplete = new MSignal();
			signalPieceComplete = new MSignal();
		}

		public function clear() : void
		{
			signalProgress.clear();
			signalComplete.clear();
			signalPieceComplete.clear();
			var loader : LoaderCore;
			while (_waitList.length > 0)
			{
				loader = _waitList.pop();
				removeLoaderEvent(loader);
				loader.unloadAndStop(true);
			}

			while (_loadingList.length > 0)
			{
				loader = _loadingList.pop();
				removeLoaderEvent(loader);
				loader.unloadAndStop(true);
			}

			while (_overitmeList.length > 0)
			{
				loader = _overitmeList.pop();
				removeLoaderEvent(loader);
				loader.unloadAndStop(true);
			}

			while (_loadedList.length > 0)
			{
				loader = _loadedList.pop();
				removeLoaderEvent(loader);
				loader.unloadAndStop(true);
			}
			_loadingCount = 0;
			_totalNum = 0;
			_overNum = 0;
			_isLoadList = false;
			// trace("[clear]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		public function get haveEmptyThread() : Boolean
		{
			return _loadingCount < MAX_THREAD_COUTN;
		}

		private function dispatchProgress() : void
		{
			signalProgress.dispatch(_overNum, _totalNum);
			if (_overNum >= _totalNum)
			{
				dispatchComplete();
			}
		}

		private function dispatchComplete() : void
		{
			signalComplete.dispatch();
			_isLoadList = false;
		}

		public function load(loader : LoaderCore) : void
		{
			if (!haveEmptyThread)
			{
				if (_waitList.indexOf(loader)) _waitList.push(loader);
				// trace("[load_pushWait]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
				return;
			}
			initLoad(loader);
			// trace("[load_initLoader]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		public function append(loader : LoaderCore) : void
		{
			if (_waitList.indexOf(loader) == -1)
			{
				_totalNum++;
				_waitList.push(loader);
			}
			// trace("[append]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		public function remove(loader : LoaderCore, unloadAndStop : Boolean = true) : void
		{
			var index : int = _waitList.indexOf(loader);
			if (index != -1)
			{
				_waitList.splice(index, 1);
				_overNum++;
				dispatchProgress();
			}
			else if ((index = _loadingList.indexOf(loader)) != -1 )
			{
				_loadingCount--;
				_loadingList.splice(index, 1);
				if ((index = _overitmeList.indexOf(loader)) != -1 )
				{
					_overitmeList.splice(index, 1);
				}
				_overNum++;
				dispatchProgress();
			}
			else if ((index = _loadedList.indexOf(loader)) != -1 )
			{
				_loadedList.splice(index, 1);
			}
			removeLoaderEvent(loader);
			if (unloadAndStop) loader.unloadAndStop(GC);
			// trace("[remove]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		public function startLoad() : void
		{
			// Logger.info("startLoad:   " + "waitList.length:" + _waitList.length + "loadingList.length:" + _loadingList.length + "loadedList.length:" + _loadedList.length + "overitmeList.length:" + _overitmeList.length + "loadingCount:" + _loadingCount)
			_isLoadList = true;
			loadNext();
		}

		private function loadNext() : void
		{
			if (!haveEmptyThread) return;
			while (haveEmptyThread && _overitmeList.length > 0)
			{
				(_overitmeList.shift() as LoaderCore).reload();
				// trace("[loadNext_reload]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
			}

			while (haveEmptyThread && _waitList.length > 0)
			{
				initLoad(_waitList.shift());
				// trace("[loadNext_initLoad]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
			}
		}

		private  function initLoad(loader : LoaderCore) : void
		{
			_loadingCount++;
			addLoaderEvent(loader);
			var index : int = _waitList.indexOf(loader);
			if (index != -1) _waitList.splice(index, 1);
			if (_loadingList.indexOf(loader) == -1) _loadingList.push(loader);
			loader.generateLoader().load(false);
		}

		private function addLoaderEvent(loader : LoaderCore) : void
		{
			loader.addEventListener(LoaderEvent.OVERTIME, overtimerHandler);
			loader.addEventListener(LoaderEvent.COMPLETE, completeHandler);
			loader.addEventListener(LoaderEvent.CANCEL, cancelHandler);
			loader.addEventListener(LoaderEvent.UNLOAD, unloadHandler);
			loader.addEventListener(LoaderEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(LoaderEvent.ERROR, errorHandler);
		}

		private function removeLoaderEvent(loader : LoaderCore) : void
		{
			loader.removeEventListener(LoaderEvent.OVERTIME, overtimerHandler);
			loader.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			loader.removeEventListener(LoaderEvent.CANCEL, cancelHandler);
			loader.removeEventListener(LoaderEvent.UNLOAD, unloadHandler);
			loader.removeEventListener(LoaderEvent.IO_ERROR, ioErrorHandler);
			loader.removeEventListener(LoaderEvent.ERROR, errorHandler);
		}

		protected function overtimerHandler(event : LoaderEvent) : void
		{
			var obj : Object = event.target;
			var index : int = _overitmeList.indexOf(obj);
			if (index == -1)
			{
				_overitmeList.push(obj);
			}
			// trace("[overtimerHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		protected function completeHandler(event : LoaderEvent) : void
		{
			_loadingCount--;
			_loadingList.splice(_loadingList.indexOf(event.target), 1);
			_loadedList.push(event.target);
			// trace("[completeHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
			loadNext();
			if (!_isLoadList && event.target is PieceLoader)
			{
				signalPieceComplete.dispatch(event.target);
			}
			_overNum++;
			dispatchProgress();
		}

		protected function cancelHandler(event : LoaderEvent) : void
		{
			Logger.error("LoadManager:: cancelHandler" + event);
			var loader : LoaderCore = event.target as LoaderCore;
			var index : int = _waitList.indexOf(loader);
			if (index != -1) _waitList.splice(index, 1);
			removeLoaderEvent(loader);
			loader.unloadAndStop(GC);

			_overNum++;
			dispatchProgress();
			// trace("[cancelHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		protected function errorHandler(event : LoaderEvent) : void
		{
			Logger.error("LoadManager:: errorHandler" + event);
			cancelHandler(event);
			// trace("[errorHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		protected function ioErrorHandler(event : LoaderEvent) : void
		{
			_loadingCount--;
			var loader : LoaderCore = event.target as LoaderCore;
			var index : int = _loadingList.indexOf(loader);
			if (index != -1) _loadingList.splice(index, 1);
			removeLoaderEvent(loader);
			// trace("[ioErrorHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
			loadNext();
			_overNum++;
			dispatchProgress();
		}

		protected function unloadHandler(event : LoaderEvent) : void
		{
			var loader : LoaderCore = event.target as LoaderCore;
			remove(loader, false);
			// trace("[unloadHandler]", "waitList.length:" + _waitList.length, "loadingList.length:" + _loadingList.length, "loadedList.length:" + _loadedList.length, "overitmeList.length:" + _overitmeList.length, "loadingCount:" + _loadingCount);
		}

		public function get loadingCount() : uint
		{
			return _loadingCount;
		}

		public function get waitList() : Vector.<LoaderCore>
		{
			return _waitList;
		}

		public function get loadingList() : Vector.<LoaderCore>
		{
			return _loadingList;
		}

		public function get loadedList() : Vector.<LoaderCore>
		{
			return _loadedList;
		}

		public function get overitmeList() : Vector.<LoaderCore>
		{
			return _overitmeList;
		}
	}
}
class Singleton
{
}
