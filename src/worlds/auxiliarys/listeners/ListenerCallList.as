package worlds.auxiliarys.listeners
{
	import flash.utils.Dictionary;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	// ============================
	public class ListenerCallList
	{
		private var list : Vector.<ListenerCall> = new Vector.<ListenerCall>();
		private var funDic : Dictionary = new Dictionary();
		private var length : int;
		private var index : int;

		public function getFunCall(fun : Function) : ListenerCall
		{
			return funDic[fun];
		}

		public function add(listenerCall : ListenerCall) : void
		{
			var index : int = list.indexOf(listenerCall);
			if (index == -1)
			{
				list.push(listenerCall);
				funDic[listenerCall.fun] = listenerCall;
				length++;
			}
		}

		public function remove(listenerCall : ListenerCall) : void
		{
			var index : int = list.indexOf(listenerCall);
			if (index != -1)
			{
				list.splice(index, 1);
				delete funDic[listenerCall.fun];
				if (index >= this.index)
				{
					this.index -= 1;
				}
				length--;
			}
			listenerCall.destory();
		}

		public function removeFun(fun : Function) : void
		{
			var listenerCall : ListenerCall = getFunCall(fun);
			if (listenerCall)
			{
				remove(listenerCall);
			}
		}

		private var tempKeyArr : Array = [];

		public function clear() : void
		{
			var listenerCall : ListenerCall;
			while ( list.length > 0)
			{
				listenerCall = list.shift();
				listenerCall.destory();
			}

			for (var key:* in funDic)
			{
				tempKeyArr.push(key);
			}

			while (tempKeyArr.length > 0)
			{
				delete funDic[tempKeyArr.shift()];
			}
		}

		private static var pool : ListenerCallListPool = ListenerCallListPool.instance;

		public function destory() : void
		{
			clear();
			pool.destoryObject(this, true);
		}

		public function run() : void
		{
			length = list.length;
			var listenerCall : ListenerCall;
			for (index = 0; index < length; index++)
			{
				listenerCall = list[index];
				listenerCall.call();
			}
		}
	}
}
