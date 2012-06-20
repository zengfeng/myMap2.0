package worlds.auxiliarys.mediators
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// ============================
	public class Callback
	{
		private var fun : Function;

		function Callback(fun : Function = null) : void
		{
			if (fun != null)
			{
				register(fun);
			}
			else
			{
				clear();
			}
		}

		public function register(fun : Function) : Callback
		{
			this.fun = fun;
			return this;
		}

		public function clear() : void
		{
			fun = emptyFun;
		}

		private function emptyFun(... args) : *
		{
			return null;
		}

		public function call(...args) : *
		{
			return fun.apply(fun, args);
		}
	}
}
