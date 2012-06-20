package worlds.auxiliarys.listeners
{
	import flash.utils.Dictionary;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	// ============================
	public class Listener
	{
		private var dic : Dictionary = new Dictionary();
		private var callPool : ListenerCallPool = ListenerCallPool.instance;
		private var listPool : ListenerCallListPool = ListenerCallListPool.instance;

		public function add(id : int, callFun : Function, callFunArgs : Array = null) : void
		{
			var list : ListenerCallList = dic[id];
			if (list == null)
			{
				list = listPool.getObject();
				dic[id] = list;
			}

			var call : ListenerCall = list.getFunCall(callFun);
			if (call )
			{
				call.register(callFun, callFunArgs);
			}
			else
			{
				call = callPool.getObject(callFun, callFunArgs);
				list.add(call);
			}
		}

		public function remove(id : int, callFun : Function) : void
		{
			var list : ListenerCallList = dic[id];
			if (list == null) return;
			list.removeFun(callFun);
		}

		public function clearID(id : int) : void
		{
			var list : ListenerCallList = dic[id];
			if(list == null) return;
			list.destory();
			delete dic[id];
		}

		private var tempKeyArr : Array = [];

		public function clearAll() : void
		{
			var key : String;
			for (key in dic)
			{
				tempKeyArr.push(key);
			}

			while (tempKeyArr.length > 0)
			{
				key = tempKeyArr.shift();
				clearID(parseInt(key));
			}
		}

		public function call(id : int) : void
		{
			var list : ListenerCallList = dic[id];
			if (list)
			{
				list.run();
			}
		}
	}
}
