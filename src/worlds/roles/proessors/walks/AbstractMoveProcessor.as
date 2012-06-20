package worlds.roles.proessors.walks
{
	import worlds.auxiliarys.EnterFrameListener;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-29
	// 抽象移动处理器
	// ============================
	public class AbstractMoveProcessor
	{
		public var callUpdate : Function;
		public var callEnd : Function;
		public var speed : Number;
		public var x : int;
		public var y : int;
		protected var fromX : int;
		protected var fromY : int;
		protected var toX : int;
		protected var toY : int;
		protected var moveing : Boolean;

		public function reset(speed : Number, callUpdate : Function, callEnd : Function) : void
		{
			this.speed = speed;
			this.callUpdate = callUpdate;
			this.callEnd = callEnd;
			moveing = false;
		}

		public function destory() : void
		{
			callUpdate = null;
			callEnd = null;
			speed = NaN;
			x = NaN;
			y = NaN;
			fromX = NaN;
			fromY = NaN;
			toX = NaN;
			toY = NaN;
			EnterFrameListener.remove(onEnterFrame);
			MoveProessorFactory.instance.destoryObject(this, true);
		}

		public function move(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			throw new Error("抽象方法,需要重写");
		}

		protected function onEnterFrame() : void
		{
			throw new Error("抽象方法,需要重写");
		}

		public function stop() : void
		{
			moveing = false;
			EnterFrameListener.remove(onEnterFrame);
			callEnd();
		}

		protected function pause() : void
		{
			EnterFrameListener.remove(onEnterFrame);
			fromX = x;
			fromY = y;
		}

		protected function play() : void
		{
			move(fromX, fromY, toX, toY);
		}

		public function changeSpeed(speed : Number) : void
		{
			if (this.speed == speed) return;
			this.speed = speed;
			if (moveing)
			{
				pause();
				play();
			}
		}
	}
}
