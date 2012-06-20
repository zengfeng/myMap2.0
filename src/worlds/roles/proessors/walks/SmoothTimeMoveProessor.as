package worlds.roles.proessors.walks
{
	import flash.utils.getTimer;
	import worlds.auxiliarys.EnterFrameListener;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// 时间为主移动处理器 平滑版
	// ============================
	public class SmoothTimeMoveProessor extends AbstractMoveProcessor
	{
		protected var distanceX : int;
		protected var distanceY : int;
		protected var distance : int;
		protected var startTime : int;
		protected var totalTime : Number;
		protected var time : Number;
		protected var progress : Number;
		protected var time0 : Number;
		protected var time1 : Number;
		protected var time2 : Number;

		public function SmoothTimeMoveProessor()
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
			time1 = 17;
			time2 = 17;
			startTime = getTimer();
			this.fromX = fromX;
			this.fromY = fromY;
			distanceX = toX - fromX;
			distanceY = toY - fromY;
			distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			totalTime = distance / (speed / (1000 / 60));
			moveing = true;
			EnterFrameListener.add(onEnterFrame);
		}

		override protected function onEnterFrame() : void
		{
			time0 = getTimer() - startTime;
			time =( time0 * 2 + 2 * time1 + 2 * time2) / 6;
			time1 = time2;
			time2 = time0;
			progress = time / totalTime;
			if (progress < 1)
			{
				x = fromX + distanceX * progress;
				y = fromY + distanceY * progress;
				callUpdate.apply(null, [x, y]);
				return;
			}

			x = fromX + distanceX;
			y = fromY + distanceY;
			callUpdate.apply(null, [x, y]);
			stop();
		}
	}
}
