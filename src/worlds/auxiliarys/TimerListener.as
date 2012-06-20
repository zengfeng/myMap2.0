package worlds.auxiliarys
{
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	public class TimerListener
	{
		private var callList : Vector.<Function>;
		private var timer : Timer;

		function TimerListener(delay : int) : void
		{
			callList = new Vector.<Function>();
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		public function add(fun : Function) : void
		{
			var index : int = callList.indexOf(fun);
			if (index == -1)
			{
				callList.push(fun);
				if (timer.running == false) timer.start();
			}
		}

		public function remove(fun : Function) : void
		{
			var index : int = callList.indexOf(fun);
			if (index != -1)
			{
				callList.splice(index, 1);
				if (timer.running == true) timer.stop();
			}
		}

		public function clear() : void
		{
			timer.stop();
			while (callList.length > 0)
			{
				callList.shift();
			}
		}

		private var tempFun : Function;
		private var tempIndex : int;
		private var tempLength : int;
		
		private var time:int = getTimer();
		private function onTimer(event : TimerEvent) : void
		{
			trace("onTimer_" + timer.delay, getTimer() - time);
			time = getTimer();
			tempLength = callList.length;
			for (tempIndex = 0; tempIndex < tempLength; tempIndex++)
			{
				tempFun = callList[tempIndex];
				tempFun();
			}
			tempFun = null;
		}

		private function onTimerComplete(event : TimerEvent) : void
		{
			trace("TimerListener_" + timer.delay, "onTimerComplete");
		}
	}
}
