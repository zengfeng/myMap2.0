package worlds.roles.proessors.ais
{
	import worlds.auxiliarys.MapMath;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-9
	// ============================
	public class RadarProcessor
	{
		protected var originX : int;
		protected var originY : int;
		protected var x : int;
		protected var y : int;
		protected var enemyX : int;
		protected var enemyY : int;
		protected var moveRadius : Number;
		protected var attackRadius : Number;
		protected var trackRadius : Number;
		protected var locking : Boolean;
		protected var callLockEnemy : Function;
		protected var callLoseEnemy : Function;
		protected var callHitEnemy : Function;
		private var radar : Function;

		function RadarProcessor() : void
		{
		}

		public function reset(originX : int, originY : int, moveRadius : Number, attackRadius : Number, x : int, y : int, enemyX : int, enemyY : int, callLockEnemy : Function, callLoseEnemy : Function, callHitEnemy : Function) : void
		{
			this.originX = originX;
			this.originY = originY;
			this.x = x;
			this.y = y;
			this.enemyX = enemyX;
			this.enemyY = enemyY;
			this.moveRadius = moveRadius;
			this.attackRadius = attackRadius;
			this.trackRadius = moveRadius + 100;
			this.callLockEnemy = callLockEnemy;
			this.callLoseEnemy = callLoseEnemy;
			this.callHitEnemy = callHitEnemy;
			if (moveRadius <= 0)
			{
				this.moveRadius = attackRadius;
				this.trackRadius = attackRadius;
			}
			start();
		}

		public function destory() : void
		{
			stop();
			originX = NaN;
			originY = NaN;
			x = NaN;
			y = NaN;
			enemyX = NaN;
			enemyY = NaN;
			moveRadius = NaN;
			attackRadius = NaN;
			locking = false;
			callLockEnemy = null;
			callLoseEnemy = null;
			callHitEnemy = null;
		}

		public function start() : void
		{
			radar = onTimer;
		}

		public function stop() : void
		{
			radar = emptyOnTimer;
		}

		private function emptyOnTimer() : void
		{
		}

		private var moveDistance : Number;
		private var attackDistance : Number;

		protected function onTimer() : void
		{
			moveDistance = MapMath.distance(originX, originY, enemyX, enemyY);
			if (moveDistance > trackRadius)
			{
				if (locking)
				{
					loseEnmeny();
				}
			}
			else if (moveDistance > moveRadius)
			{
				if (locking)
				{
					attackDistance = MapMath.distance(x, y, enemyX, enemyY);
					if (attackDistance <= attackRadius)
					{
						hitEnmeny();
					}
				}
			}
			else
			{
				if (locking == false)
				{
					lockEnemy();
				}

				attackDistance = MapMath.distance(x, y, enemyX, enemyY);
				if (attackDistance <= attackRadius)
				{
					hitEnmeny();
				}
			}
		}

		public function updatePostion(x : int, y : int) : void
		{
			this.x = x;
			this.y = y;
			radar();
		}

		public function enemyUpdatePosition(x : int, y : int) : void
		{
			this.enemyX = x;
			this.enemyY = y;
			radar();
		}

		protected function lockEnemy() : void
		{
			locking = true;
			callLockEnemy();
		}

		protected function loseEnmeny() : void
		{
			locking = false;
			callLoseEnemy();
		}

		protected function hitEnmeny() : void
		{
			callHitEnemy();
		}
	}
}
