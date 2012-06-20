package worlds.auxiliarys.mediators
{
	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-31 ����8:58:24
	 * 通知
	 */
	public class MSignal
	{
		function MSignal(...args : *) : void
		{
		}

		public function dispatch(...args : *) : void
		{
			runCallList(args);
		}

		protected var callList : Vector.<Function> = new Vector.<Function>();

		public function add(fun : Function) : void
		{
			if (fun == null) return;
			var index : int = callList.indexOf(fun);
			if (index == -1)
			{
				runLength += 1;
				callList.push(fun);
			}
		}

		public function remove(fun : Function) : void
		{
			if (fun == null) return;
			var index : int = callList.indexOf(fun);
			if (index != -1)
			{
				if (index <= runIndex)
				{
					runIndex -= 1;
					runLength -= 1;
				}
				else
				{
					runLength -= 1;
				}
				callList.splice(index, 1);
			}
		}

		public function clear() : void
		{
			while (callList.length > 0)
			{
				callList.pop();
			}
		}

		private var runIndex : int;
		private var runLength : int;
		private var runing : Boolean;

		protected function runCallList(args : Array) : void
		{
			runing = true;
			runLength = callList.length;
			for (runIndex = 0; runIndex < runLength;runIndex++)
			{
				var fun : Function = callList[runIndex];
				fun.apply(null, args);
			}
			runing = false;
		}
	}
}
