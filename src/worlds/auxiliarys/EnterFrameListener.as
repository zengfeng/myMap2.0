package worlds.auxiliarys
{
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-16 ����4:28:27
	 */
	public class EnterFrameListener
	{
		public static function startup(stage : Stage) : void
		{
			EnterFrameListener.stage = stage;
		}

		private static var stage : Stage;
		private static var callList : Vector.<Function> = new Vector.<Function>();

		public static function add(fun : Function) : void
		{
			if (fun == null) return;
			var index : int = callList.indexOf(fun);
			if (index == -1)
			{
				callList.push(fun);
				if (isRuning == false)
				{
					isRuning = true;
					stage.addEventListener(Event.ENTER_FRAME, runCallList);
				}
			}
		}

		public static function remove(fun : Function) : void
		{
			if (fun == null) return;
			var index : int = callList.indexOf(fun);
			if (index != -1)
			{
				callList.splice(index, 1);
				if (callList.length == 0 && isRuning == true)
				{
					isRuning = false;
					stage.removeEventListener(Event.ENTER_FRAME, runCallList);
				}
			}
		}

		private static var isRuning : Boolean = false;

		private static function runCallList(event : Event = null) : void
		{
			for (var i : int = 0; i < callList.length; i++)
			{
				(callList[i] as Function).apply();
			}
		}
	}
}
