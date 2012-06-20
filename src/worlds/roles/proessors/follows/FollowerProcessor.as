package worlds.roles.proessors.follows
{
	import worlds.auxiliarys.MapPoint;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	// ============================
	public class FollowerProcessor
	{
		protected var leader : LeaderProcessor;
		protected var position : MapPoint;
		protected var callDestory : Function;
		protected var callChangeSpeed : Function;
		protected var callTransport : Function;
		protected var callWalkAddPoint : Function;
		protected var callWalkRemoveLastPoint : Function;
		protected var callSetStandDirection : Function;

		public function reset(leaderProcessor : LeaderProcessor, position : MapPoint, callDestory : Function, callChangeSpeed : Function, callTransport : Function, callWalkAddPoint : Function, callWalkRemoveLastPoint : Function, callSetStandDirection : Function) : void
		{
			this.leader = leaderProcessor;
			this.position = position;
			this.callDestory = callDestory;
			this.callChangeSpeed = callChangeSpeed;
			this.callTransport = callTransport;
			this.callWalkAddPoint = callWalkAddPoint;
			this.callWalkRemoveLastPoint = callWalkRemoveLastPoint;
			this.callSetStandDirection = callSetStandDirection;
			leader.initFollowerPosition(this);
		}

		public function destory(isLeader : Boolean = false) : void
		{
			if (!isLeader) leader.removeFollower(this, true);
			callDestory(true);
			callDestory = null;
		}

		public function leaderChangeSpeed(speed : Number) : void
		{
			callChangeSpeed(speed);
		}

		public function leaderTransport(toX : int, toY : int) : void
		{
			callTransport(toX, toY);
		}

		public function addPathPoint(toX : int, toY : int) : void
		{
			callWalkAddPoint(toX, toY);
		}

		public function removeLastPoint() : void
		{
			callWalkRemoveLastPoint();
		}

		public function setStandDirection(targetX : int, targetY : int) : void
		{
			callSetStandDirection(targetX, targetY);
		}
		
		public function get x():int
		{
			return position.x;
		}
		
		public function get y():int
		{
			return position.y;
		}
	}
}
