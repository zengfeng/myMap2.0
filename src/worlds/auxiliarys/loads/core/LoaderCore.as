package worlds.auxiliarys.loads.core
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import worlds.auxiliarys.loads.LoadManager;
	import worlds.auxiliarys.loads.pools.LoaderPool;
	import worlds.auxiliarys.loads.pools.URLRequestPool;



	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
	 */
	public class LoaderCore extends EventDispatcher
	{
		protected var urlRequest : URLRequest;
		protected var loader : Loader;
		private var _requestCount : int = 0;
		private var _httpStatus : int = 0;
		private var _bytesLoaded : int = 0;
		private var _bytesTotal : int = 0;
		private var _isLoading : Boolean;
		private var _isError : Boolean;
		private var _isIOError : Boolean;
		private var _isLoaded : Boolean;

		// protected var
		public function LoaderCore()
		{
		}

		public function generateLoader() : LoaderCore
		{
			urlRequest = URLRequestPool.instance.getObject();
			loader = LoaderPool.instance.getObject();
			return this;
		}

		public function load(fromLoaderManager : Boolean = true) : void
		{
			if (fromLoaderManager)
			{
				LoadManager.instance.load(this);
				return;
			}
			addLoaderEvents();
			_isLoading = true;
			loader.load(urlRequest);
		}

		public function reload() : void
		{
			loader.load(urlRequest);
		}

		public function unloadAndStop(gc : Boolean) : void
		{
			if (_isLoading == false)
			{
				dispatchEvent(new LoaderEvent(LoaderEvent.CANCEL, this));
			}
			else
			{
				dispatchEvent(new LoaderEvent(LoaderEvent.UNLOAD, this));
			}
			removeLoaderEvents();
			URLRequestPool.instance.destoryObject(urlRequest);
			LoaderPool.instance.destoryObject(loader, !_isLoading, gc);
			urlRequest = null;
			loader = null;
			_isLoading = false;
			_isError = false;
			_isLoaded = false;
			_httpStatus = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}

		protected function addLoaderEvents() : void
		{
			if (loader)
			{
				var loaderInfo : LoaderInfo = loader.contentLoaderInfo;
				loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loaderInfo.addEventListener(Event.INIT, initHandler);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loaderInfo.addEventListener(Event.OPEN, openHandler);
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loaderInfo.addEventListener(Event.UNLOAD, unLoadHandler);
			}
		}

		protected function removeLoaderEvents() : void
		{
			if (loader)
			{
				var loaderInfo : LoaderInfo = loader.contentLoaderInfo;
				loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loaderInfo.removeEventListener(Event.INIT, initHandler);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loaderInfo.removeEventListener(Event.OPEN, openHandler);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loaderInfo.removeEventListener(Event.UNLOAD, unLoadHandler);
			}
		}

		protected function openHandler(event : Event) : void
		{
			// trace("openHandler: " + event);
		}

		protected function httpStatusHandler(event : HTTPStatusEvent) : void
		{
			// trace("httpStatusHandler: " + event.status + "  " + event);
			_httpStatus = event.status;

//			Logger.info("httpStatusHandler:" + event.status + urlRequest.url);
			if (_httpStatus == 408 && _requestCount <= 3)
			{
				_requestCount++;
				dispatchEvent(new LoaderEvent(LoaderEvent.OVERTIME, this));
			}
			else if (event.status > 300)
			{
//				Logger.error("加载httpStatus出错:" + event.status + urlRequest.url);
				dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, this));
			}
		}

		protected function ioErrorHandler(event : IOErrorEvent) : void
		{
			_isIOError = true;
//			Logger.error("加载ioError" + event + urlRequest.url);
			// trace("ioErrorHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, this));
		}

		protected function initHandler(event : Event) : void
		{
			// trace("initHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
		}

		protected function progressHandler(event : ProgressEvent) : void
		{
			// trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
		}

		protected function unLoadHandler(event : Event) : void
		{
			// trace("unLoadHandler: " + event);
			// dispatchEvent(new LoaderEvent(LoaderEvent.UNLOAD, this));
		}

		protected function completeHandler(event : Event) : void
		{
//			Logger.info("LoaderCore::completeHandler:" + urlRequest.url);
			_isLoaded = true;
			// trace("completeHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE, this));
		}

		public function get httpStatus() : int
		{
			return _httpStatus;
		}

		public function get bytesLoaded() : int
		{
			return _bytesLoaded;
		}

		public function get bytesTotal() : int
		{
			return _bytesTotal;
		}

		public function get isLoading() : Boolean
		{
			return _isLoading;
		}

		public function get isIOError() : Boolean
		{
			return _isIOError;
		}

		public function get isError() : Boolean
		{
			return _isError;
		}

		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}
	}
}
