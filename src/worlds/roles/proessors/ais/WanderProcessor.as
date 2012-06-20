package worlds.roles.proessors.ais
{
	import flash.geom.Point;
	import worlds.auxiliarys.MapMath;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	public class WanderProcessor
	{
		protected var pointList : Vector.<Point> ;
		protected var callWalkTo : Function;

		function WanderProcessor() : void
		{
			pointList = new Vector.<Point>();
		}

		public function reset(callWalkTo : Function, pointList : Vector.<Point>, x : int = 0, y : int = 0) : void
		{
			this.callWalkTo = callWalkTo;
			this.pointList = pointList;
			if (pointList == null)
			{
				resetRandomPoint(x, y);
			}
			start();
		}

		public function resetRandomPoint(x : int, y : int) : void
		{
			var i : int = 0;
			if (pointList == null)
			{
				pointList = new Vector.<Point>();
				for (i = 0; i < 4; i++)
				{
					tempPoint = new Point();
					pointList.push(tempPoint);
				}
			}
			var length : int = pointList.length;
			tempPoint = pointList[0];
			tempPoint.x = x;
			tempPoint.y = y;
			for (i = 1; i < length; i++)
			{
				tempPoint = pointList[i];
				tempPoint.x = x + MapMath.randomPlusMinus(100);
				tempPoint.y = y + MapMath.randomPlusMinus(100);
			}
			pointList.push(tempPoint);
		}

		public function destory() : void
		{
			stop();
			pointList = null;
			callWalkTo = null;
		}

		private var tempPoint : Point;
		private var tempIndex : int;
		private  var tempX : int;
		private var tempY : int;

		protected function onTimer() : void
		{
			if (Math.random() > 0.2)
			{
				tempIndex = Math.random() * pointList.length;
				tempPoint = pointList[tempIndex];
				tempX = tempPoint.x + MapMath.randomPlusMinus(30);
				tempY = tempPoint.y + MapMath.randomPlusMinus(30);
				callWalkTo(tempX, tempY);
				tempPoint = null;
			}
		}

		public function start() : void
		{
			WanderOnTimer.add(onTimer);
		}

		public function stop() : void
		{
			WanderOnTimer.remove(onTimer);
		}
	}
}
