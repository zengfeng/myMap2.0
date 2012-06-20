package worlds.roles.proessors.walks
{
	import flash.utils.getTimer;
	import worlds.auxiliarys.EnterFrameListener;




	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// 时间为主移动处理器
	// ============================
	public class TimeMoveProessor extends AbstractMoveProcessor
	{
		protected var distanceX : int;
		protected var distanceY : int;
		protected var distance : int;
		protected var startTime : int;
		protected var totalTime : int;
		protected var time : int;
		protected var progress : Number;

		public function TimeMoveProessor()
		{
		}

		override public function destory() : void
		{
			distanceX = NaN;
			distanceY = NaN;
			distance = NaN;
			startTime = NaN;
			totalTime = NaN;
			time = NaN;
			progress = NaN;
			super.destory();
		}

		override public function move(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			if(fromX == 0)
			{
				trace(fromX);
			}
			startTime = getTimer();
			this.x = fromX;
			this.y = fromY;
			this.fromX = fromX;
			this.fromY = fromY;
			this.toX = toX;
			this.toY = toY;
			distanceX = toX - fromX;
			distanceY = toY - fromY;
			distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			totalTime = distance / (speed / (1000 / 60));
			moveing = true;
			EnterFrameListener.add(onEnterFrame);
		}

		override protected function onEnterFrame() : void
		{
			time = getTimer() - startTime;
			progress = time / totalTime;
			if (progress < 1)
			{
				x = fromX + distanceX * progress;
				y = fromY + distanceY * progress;
				callUpdate(x, y);
				return;
			}

			x = fromX + distanceX;
			y = fromY + distanceY;
			callUpdate(x, y);
			stop();
		}

	}
}
