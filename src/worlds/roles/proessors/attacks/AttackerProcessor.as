package worlds.roles.proessors.attacks
{
	import worlds.auxiliarys.MapMath;
	import worlds.auxiliarys.MapPoint;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-31
	// ============================
	public class AttackerProcessor
	{
		protected var defender : DefenderProcessor;
		protected var callDestory : Function;
		protected var callWalkTo : Function;
		protected var callAttackAction : Function;
		protected var position : MapPoint;
		protected var x : int;
		protected var y : int;
		protected var defenderX : int;
		protected var defenderY : int;
		protected static const radius : int = 100;

		public function reset(defender : DefenderProcessor, position : MapPoint, defenderX : int, defenderY : int, callDestory : Function, callWalkTo : Function, callAttackAction : Function) : void
		{
			this.defender = defender;
			this.position = position;
			this.defenderX = defenderX;
			this.defenderY = defenderY;
			this.callDestory = callDestory;
			this.callWalkTo= callWalkTo;
			this.callAttackAction= callAttackAction;
			pursue();
		}

		public function destory(isDefender : Boolean = false) : void
		{
			if (!isDefender) defender.removeAttacker(this, true);
			callDestory(true);
			callDestory = null;
		}

		/** 追杀 */
		protected function pursue() : void
		{
			var distance : Number = MapMath.distance(position.x, position.y, defenderX, defenderY);
			if (distance < radius)
			{
				callAttackAction(defenderX);
			}
			else
			{
				callWalkTo(defenderX, defenderY);
			}
		}

		public function walkEnd() : void
		{
			callAttackAction(defenderX);
		}
		
		private var frame:int = 0;
		public function defenderMove(x : int, y : int) : void
		{
			frame ++;
			if(frame < 180) return;
			frame = 0;
			defenderX = x;
			defenderY = y;
			pursue();
		}
	}
}