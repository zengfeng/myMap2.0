package 
worlds.auxiliarys.listeners{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// 延迟回调
	// ============================
	public class ListenerCall
	{
		public var fun : Function;
		private var args : Array;

		function ListenerCall(fun : Function = null, args : Array = null) : void
		{
			if (fun != null)
			{
				register(fun, args);
			}
			else
			{
				clear();
			}
		}

		public function register(fun : Function, args : Array = null) : ListenerCall
		{
			this.fun = fun;
			this.args = args;
			return this;
		}

		public function clear() : void
		{
			fun = emptyFun;
			args = null;
		}

		private static var pool : ListenerCallPool = ListenerCallPool.instance;

		public function destory() : void
		{
			clear();
			pool.destoryObject(this, true);
		}

		private function emptyFun(... args) : void
		{
		}

		public function call() : void
		{
			fun.apply(fun, args);
		}
	}
}
