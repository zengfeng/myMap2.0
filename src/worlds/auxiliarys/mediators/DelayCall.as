package worlds.auxiliarys.mediators
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// 延迟回调
	// ============================
	public class DelayCall
	{
		private var fun : Function;
		private var args : Array;

		function DelayCall(fun : Function = null, args : Array = null) : void
		{
			if(fun != null)
			{
				register(fun, args);
			}
			else
			{
				clear();
			}
		}

		public function register(fun : Function, args : Array = null) : DelayCall
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

		private function emptyFun(... args) : void
		{
		}

		public function call() : void
		{
			fun.apply(fun, args);
		}
	}
}
