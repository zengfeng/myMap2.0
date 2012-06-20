package worlds.roles.proessors.ais
{
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.TimerChannel;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-9
	// ============================
	public class TrackProcessor
	{
		protected var originX : int;
		protected var originY : int;
		protected var callWalkTo : Function;
		protected var enemyPosition : MapPoint;

		function TrackProcessor() : void
		{
		}

		public function reset(originX : int, originY : int, enemyPosition : MapPoint, callWalkTo : Function) : void
		{
			this.originX = originX;
			this.originY = originY;
			this.enemyPosition = enemyPosition;
			this.callWalkTo = callWalkTo;
		}

		public function destory() : void
		{
			stop();
			originX = NaN;
			originY = NaN;
			enemyPosition = null;
			callWalkTo = null;
		}

		private function onTimer() : void
		{
			callWalkTo(enemyPosition.x, enemyPosition.y);
		}

		public function start() : void
		{
			TimerChannel.add(TimerChannel.TIME_500, onTimer);
		}

		public function stop() : void
		{
			TimerChannel.remove(TimerChannel.TIME_500, onTimer);
		}

		public function retreat() : void
		{
			trace("retreat");
			callWalkTo(originX, originY);
		}
	}
}
