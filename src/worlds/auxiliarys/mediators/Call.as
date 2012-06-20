package worlds.auxiliarys.mediators
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// ============================
	public class Call
	{
		private var fun : Function;

		function Call(fun : Function = null) : void
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

		public function register(fun : Function) : Call
		{
			this.fun = fun;
			return this;
		}

		public function clear() : void
		{
			fun = emptyFun;
		}

		private function emptyFun(... args) : void
		{
		}

		public function call(...args) : void
		{
			fun.apply(fun, args);
		}
	}
}
