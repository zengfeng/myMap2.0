package worlds.auxiliarys.loads.expands
{
	import com.utils.UrlUtils;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import log4a.Logger;
	import worlds.auxiliarys.loads.LoadManager;
	import worlds.auxiliarys.loads.core.LoaderCore;
	import worlds.auxiliarys.loads.core.LoaderEvent;
	import worlds.auxiliarys.loads.pools.URLRequestPool;




	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-11
	// ============================
	public class PathLoader  extends LoaderCore
	{
		public var mapId : int;
		protected var urlLoader : URLLoader;
		private var _requestCount : int = 0;
		private var _httpStatus : int = 0;
		private var _bytesLoaded : int = 0;
		private var _bytesTotal : int = 0;
		private var _isLoading : Boolean;
		private var _isError : Boolean;
		private var _isIOError : Boolean;
		private var _isLoaded : Boolean;
		/** 单例对像 */
		private static var _instance : PathLoader;

		/** 获取单例对像 */
		static public function get instance() : PathLoader
		{
			if (_instance == null)
			{
				_instance = new PathLoader(new Singleton());
			}
			return _instance;
		}

		function PathLoader(singleton : Singleton)
		{
			singleton;
		}

		override public function generateLoader() : LoaderCore
		{
			if (urlLoader == null)
			{
				urlRequest = URLRequestPool.instance.getObject();
				urlLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			
//			urlRequest.url = "path";
			urlRequest.url = UrlUtils.getMapPathData(mapId);
			return this;
		}

		override public function load(fromLoaderManager : Boolean = true) : void
		{
			if (fromLoaderManager)
			{
				LoadManager.instance.load(this);
				return;
			}
			addLoaderEvents();
			_isLoading = true;
			urlLoader.load(urlRequest);
		}

		override public function reload() : void
		{
			urlLoader.load(urlRequest);
		}

		override public function unloadAndStop(gc : Boolean) : void
		{
			gc;
			if (_isLoading == false)
			{
				dispatchEvent(new LoaderEvent(LoaderEvent.CANCEL, this));
			}
			else
			{
				dispatchEvent(new LoaderEvent(LoaderEvent.UNLOAD, this));
			}
			removeLoaderEvents();
//			if(_isLoaded == false) urlLoader.close();
			var byteArray : ByteArray = urlLoader.data as ByteArray;
			if (byteArray)
			{
				byteArray.clear();
				byteArray.position = 0;
			}
			_isLoading = false;
			_isError = false;
			_isLoaded = false;
			_httpStatus = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}

		override protected function addLoaderEvents() : void
		{
			if (urlLoader)
			{
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}

		override protected function removeLoaderEvents() : void
		{
			if (urlLoader)
			{
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}

		override protected function openHandler(event : Event) : void
		{
			// trace("openHandler: " + event);
		}

		override protected function httpStatusHandler(event : HTTPStatusEvent) : void
		{
			// trace("httpStatusHandler: " + event.status + "  " + event);
			_httpStatus = event.status;

			// Logger.info("httpStatusHandler:" + event.status + urlRequest.url);
			if (_httpStatus == 408 && _requestCount <= 3)
			{
				_requestCount++;
				dispatchEvent(new LoaderEvent(LoaderEvent.OVERTIME, this));
			}
			else if (event.status > 300)
			{
				Logger.error("加载httpStatus出错:" + event.status + urlRequest.url);
				dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, this));
			}
		}

		override protected function ioErrorHandler(event : IOErrorEvent) : void
		{
			_isIOError = true;
			Logger.error("加载ioError" + event + urlRequest.url);
			// trace("ioErrorHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, this));
		}

		protected function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			_isIOError = true;
			Logger.error("加载securityErrorHandler" + event + urlRequest.url);
			dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, this));
		}

		override protected function initHandler(event : Event) : void
		{
			// trace("initHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
		}

		override protected function progressHandler(event : ProgressEvent) : void
		{
			// trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
		}

		override protected function unLoadHandler(event : Event) : void
		{
			// trace("unLoadHandler: " + event);
			// dispatchEvent(new LoaderEvent(LoaderEvent.UNLOAD, this));
		}

		override protected function completeHandler(event : Event) : void
		{
			// Logger.info("LoaderCore::completeHandler:" + urlRequest.url);
			_isLoaded = true;
			// trace("completeHandler: " + event);
			dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE, this));
		}

		override public function get httpStatus() : int
		{
			return _httpStatus;
		}

		override public function get bytesLoaded() : int
		{
			return _bytesLoaded;
		}

		override public function get bytesTotal() : int
		{
			return _bytesTotal;
		}

		override public function get isLoading() : Boolean
		{
			return _isLoading;
		}

		override public function get isIOError() : Boolean
		{
			return _isIOError;
		}

		override public function get isError() : Boolean
		{
			return _isError;
		}

		override public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}

		public function getData() : ByteArray
		{
			if (urlLoader)
			{
				return urlLoader.data;
			}
			return null;
		}
	}
}
class Singleton
{
}