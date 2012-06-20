package worlds.roles.proessors.walks
{
	import worlds.auxiliarys.EnterFrameListener;
	import worlds.auxiliarys.MapMath;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// ============================
	public class FrameMoveProessor extends AbstractMoveProcessor
	{
		protected var distance : int;
		protected var radian : Number;
		protected var length : int;
		protected var totalFrame : int;
		protected var frame : int;

		public function FrameMoveProessor()
		{
		}

		override public function destory() : void
		{
			distance = NaN;
			radian = NaN;
			length = NaN;
			totalFrame = NaN;
			frame = NaN;
			super.destory();
		}

		override public function move(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			this.fromX = fromX;
			this.fromY = fromY;
			this.toX = toX;
			this.toY = toY;
			radian = MapMath.radian(fromX, fromY, toX, toY);
			distance = MapMath.distance(fromX, fromY, toX, toY);
			totalFrame = distance / speed;
			frame = 1;
			moveing = true;
			EnterFrameListener.add(onEnterFrame);
		}

		override protected function onEnterFrame() : void
		{
			length = speed * frame;
			x = MapMath.radianPointX(radian, length, fromX);
			y = MapMath.radianPointY(radian, length, fromY);
			callUpdate(x, y);
			frame++;
			if (frame > totalFrame)
			{
				stop();
			}
		}
	}
}
