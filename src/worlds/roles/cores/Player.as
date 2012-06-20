package worlds.roles.cores
{
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.roles.PlayerPool;
	import worlds.roles.RoleFactory;
	import worlds.roles.animations.PlayerAnimation;
	import worlds.roles.animations.SimpleAnimation;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// ============================
	public class Player extends Role
	{
		// ==============
		// 稳定信息
		// ==============
		protected var playerId : int;
		protected var heroId : int;
		protected var clothId : int;
		protected var rideId : int;
		// ==============
		// 处理器及动画
		// ==============
		protected var playerAnimation : PlayerAnimation;
		protected var turtle : Role;
		/* 消息 */
		protected var callActionSitdown : Call = new Call();
		protected var callActionSitdup : Call = new Call();
		protected var callActionRideUp : Call = new Call();
		protected var callActionRideDown : Call = new Call();
		protected var sChangeCloth : MSignal = new MSignal(int, int);

		override protected function destoryToPool() : void
		{
			 PlayerPool.instance.destoryObject(this, true);
		}

		public function resetPlayer(playerId : int, name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : void
		{
			this.playerId = playerId;
			this.name = name;
			this.colorStr = colorStr;
			this.heroId = heroId;
			this.clothId = clothId;
			this.rideId = rideId;
		}

		// ==============
		// 动画
		// ==============
		override public function setAnimation(animation : SimpleAnimation) : void
		{
			playerAnimation = animation as PlayerAnimation;
			super.setAnimation(animation);
			callActionSitdown.register(playerAnimation.sitDown);
			callActionSitdup.register(playerAnimation.sitUp);
			callActionRideUp.register(playerAnimation.rideUp);
			callActionRideDown.register(playerAnimation.rideDown);
			sChangeCloth.add(playerAnimation.changeCloth);
		}

		override protected function destoryAnimation() : void
		{
			super.destoryAnimation();
			if (playerAnimation == null) return;
			callActionSitdown.clear();
			callActionSitdup.clear();
			callActionRideUp.clear();
			callActionRideDown.clear();
			sChangeCloth.remove(playerAnimation.changeCloth);
			playerAnimation = null;
		}

		// =======================
		// 打座
		// =======================
		public function sitDown() : void
		{
			walkStop();
			rideDown();
			callActionSitdown.call();
			sWalkStart.add(rideUp);
		}

		public function sitUp() : void
		{
			if(walking == false) callActionStand.call();
			rideUp();
		}

		// =======================
		// 坐骑
		// =======================
		public function rideUp(rideId : int = -1) : void
		{
			sWalkStart.remove(rideUp);
			if (rideId != -1) this.rideId = rideId;
			if (this.rideId == 0)
			{
				rideDown();
			}
			else
			{
				callActionRideUp.call(this.rideId);
				playerAnimation.rideUp(this.rideId);
			}
		}

		protected function rideDown() : void
		{
			callActionRideDown.call();
		}

		// =======================
		// 换装
		// =======================
		public function changeCloth(clothId : int) : void
		{
			this.clothId = clothId;
			sChangeCloth.dispatch(clothId, heroId);
		}

		// =======================
		// 钓鱼
		// =======================
		public function fishModelIn(fishDirection : int) : void
		{
			walkStop();
			rideDown();
			playerAnimation.fishModelIn(fishDirection);
		}

		public function fishModelOut() : void
		{
			playerAnimation.fishModelOut();
			rideUp();
		}

		public function fishSit() : void
		{
			playerAnimation.fishSit();
		}

		public function fishHold() : void
		{
			playerAnimation.fishHold();
		}

		public function fishPull(awardUrl : String, onPullComplete : Function) : void
		{
			playerAnimation.fishPull(awardUrl, onPullComplete);
		}

		// =======================
		// 龟仙拜佛
		// =======================
		public function convoyModelIn(quality : int, name : String, colorStr : String, isFast : Boolean) : void
		{
			rideUp(1);
			callActionStand.call();
			turtle = RoleFactory.instance.makeTurtle(quality, this.name, this.colorStr, name, colorStr);
			turtle.initPosition(x, y, 0.6, false, 0, 0, 0, 0, 0);
			turtle.follow(this);
			if (isFast)
			{
				convoySpeedFast();
			}
			else
			{
				convoySpeedSlowly();
			}
		}

		public function convoyModelOut() : void
		{
			turtle.destory();
			turtle = null;
			rideDown();
			walkStop();
			recoverSpeed();
		}

		public function convoySpeedSlowly() : void
		{
			dispatchSpeed(0.6);
		}

		public function convoySpeedFast() : void
		{
			dispatchSpeed(15);
		}
	}
}
