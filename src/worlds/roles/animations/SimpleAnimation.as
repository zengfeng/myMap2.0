package worlds.roles.animations
{
	import game.core.avatar.AvatarThumb;

	import worlds.roles.animations.depths.RoleNode;


	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	// ============================
	public class SimpleAnimation extends RoleNode
	{
		public function resetSimple(avatar : AvatarThumb):void
		{
			setAvatar(avatar);
		}

		override public function destory() : void
		{
			removeFromLayer();
			AvatarFactory.destoryAvatar(avatar);
			avatar = null;
			super.destory();
			destoryToPool();
		}
		
		protected function destoryToPool() : void
		{
			SimpleAnimationPool.instance.destoryObject(this, true);
		}

		/** 设置位置 */
		public function setPosition(x : int, y : int) : void
		{
			this.x = x;
			this.y = y;
			avatar.x = x;
			avatar.y = y;
			updateDepth();
			updateMask();
		}

		/** 站立 */
		public function stand() : void
		{
			avatar.stand();
		}

		/** 站立方向 */
		public function standDirection(targetX : int, targetY : int, x : int = 0, y : int = 0) : void
		{
			avatar.standDirection(targetX, targetY, x, y);
		}

		/** 跑 */
		public function run(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			avatar.run(toX, toY, fromX, fromY);
		}

		/** 攻击 */
		public function attack(targetX : int) : void
		{
			if (targetX > x)
			{
				avatar.fontAttack();
			}
			else
			{
				avatar.backAttack();
			}
		}
	}
}
