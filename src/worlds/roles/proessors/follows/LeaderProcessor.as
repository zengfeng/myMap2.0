package worlds.roles.proessors.follows
{
	import worlds.auxiliarys.MapMath;
	import worlds.auxiliarys.MapPoint;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	// ============================
	public class LeaderProcessor
	{
		protected const GAP : int = 80;
		protected var list : Vector.<FollowerProcessor> = new Vector.<FollowerProcessor>();
		protected var callDestory : Function;
		protected var position : MapPoint;
		protected var speed : Number;
		protected var moveing : Boolean;

		public function reset(callDestory : Function, position : MapPoint, speed : Number, moveing : Boolean) : void
		{
			this.callDestory = callDestory;
			this.position = position;
			this.speed = speed;
			this.moveing = moveing;
		}

		public function destory() : void
		{
			removeAllFollower();
			position = null;
			callDestory(true);
		}

		public function addFollower(follower : FollowerProcessor) : void
		{
			var index : int = list.indexOf(follower);
			if (index == -1)
			{
				list.push(follower);
			}
		}

		public function removeFollower(follower : FollowerProcessor, destoryed : Boolean = false) : void
		{
			var index : int = list.indexOf(follower);
			list.splice(index, 1);
			if (!destoryed) follower.destory(true);
		}

		protected function removeAllFollower() : void
		{
			while (list.length > 0)
			{
				removeFollower(list[0]);
			}
		}

		public function changeSpeed(speed : Number) : void
		{
			this.speed = speed;
			var length : int = list.length;
			for (var i : int = 0; i < length; i++)
			{
				(list[i] as FollowerProcessor).leaderChangeSpeed(speed);
			}
		}

		public function transport(toX : int, toY : int) : void
		{
			var length : int = list.length;
			for (var i : int = 0; i < length; i++)
			{
				(list[i] as FollowerProcessor).leaderTransport(toX, toY);
			}
		}

		public function walkStart() : void
		{
			moveing = true;
			isChangPath = true;
		}

		private var isChangPath : Boolean;
		private var tempLength : int;
		private var templIndex : int;
		private var tempFollower : FollowerProcessor;
		protected var fromX : int;
		protected var fromY : int;
		protected var toX : int;
		protected var toY : int;

		public function walkTurn(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			this.fromX = fromX;
			this.fromY = fromY;
			this.toX = toX;
			this.toY = toY;
			if (isChangPath)
			{
				tempLength = list.length;
				for (templIndex = 0; templIndex < tempLength;templIndex++)
				{
					tempFollower = list[templIndex];
					tempFollower.removeLastPoint();
					tempFollower.addPathPoint(fromX, fromY);
					tempFollower.addPathPoint(toX, toY);
				}
				tempFollower = null;
				isChangPath = false;
				return;
			}

			tempLength = list.length;
			for (templIndex = 0; templIndex < tempLength;templIndex++)
			{
				tempFollower = list[templIndex];
				tempFollower.addPathPoint(toX, toY);
			}
			tempFollower = null;
		}

		private var tempDistance : int;
		private var tempRadian : Number;
		private var tempX : int;
		private var tempY : int;
		private var gap : int;

		public function walkEnd() : void
		{
			moveing = false;
			tempLength = list.length;
			toX = position.x;
			toY = position.y;
			tempDistance = MapMath.distance(toX, toY, fromX, fromY);
			tempRadian = MapMath.radian(toX, toY, fromX, fromY);
			gap = GAP;
			if (tempLength * gap > tempDistance)
			{
				gap = tempDistance / tempLength;
			}

			for (templIndex = 0; templIndex < tempLength;templIndex++)
			{
				tempDistance = (templIndex + 1 ) * gap;
				tempX = MapMath.radianPointX(tempRadian, tempDistance, toX);
				tempY = MapMath.radianPointY(tempRadian, tempDistance, toY);
				tempFollower = list[templIndex];
				tempFollower.removeLastPoint();
				tempFollower.addPathPoint(tempX, tempY);
				tempFollower.setStandDirection(toX, toY);
			}
			tempFollower = null;
		}

		public function initFollowerPosition(follower : FollowerProcessor) : void
		{
			follower.leaderChangeSpeed(speed);
			tempDistance = MapMath.distance(follower.x, follower.y, position.x, position.y);
			tempX = position.x + Math.random() * GAP * (Math.random() > 0.5 ? 1 : -1);
			tempY = position.y + Math.random() * GAP * (Math.random() > 0.5 ? 1 : -1);
			if (tempDistance > 300 || moveing)
			{
				follower.leaderTransport(tempX, tempY);
			}

			if (toX == 0)
			{
				toX = position.x;
				toY = position.y;
			}
			tempX = toX + Math.random() * GAP * (Math.random() > 0.5 ? 1 : -1);
			tempY = toY + Math.random() * GAP * (Math.random() > 0.5 ? 1 : -1);
			follower.addPathPoint(tempX, tempY);
			follower.setStandDirection(toX, toY);
		}
	}
}
