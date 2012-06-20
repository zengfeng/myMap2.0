package worlds.npcs
{
	import worlds.apis.MMouse;
	import game.core.avatar.AvatarThumb;

	import worlds.apis.MNpc;
	import worlds.apis.MTo;
	import worlds.roles.NpcPool;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.animations.SimpleAnimationPool;
	import worlds.roles.cores.Npc;

	import flash.events.Event;
	import flash.events.MouseEvent;



	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class NpcFactory
	{
		/** 单例对像 */
		private static var _instance : NpcFactory;

		/** 获取单例对像 */
		public static  function get instance() : NpcFactory
		{
			if (_instance == null)
			{
				_instance = new NpcFactory(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var npcPool : NpcPool;
		private var avatarFactory : AvatarFactory;
		private var simpleAnimationPool : SimpleAnimationPool;

		function NpcFactory(singleton : Singleton) : void
		{
			singleton;
			npcPool = NpcPool.instance;
			avatarFactory = AvatarFactory.instance;
			simpleAnimationPool = SimpleAnimationPool.instance;
		}

		public function make(npcId : int, hasAvatar : Boolean, avatarId : int, name : String, colorStr : String) : Npc
		{
			var npc : Npc;
			if (npcId < 4000)
			{
				npc = makeNpc(npcId);
			}
			else
			{
				if (hasAvatar)
				{
					npc = makeMonster(npcId, avatarId, name, colorStr);
				}
				else
				{
					npc = makeHideMonster(npcId);
				}
			}
			return npc;
		}

		/** 创建正常NPC */
		public function makeNpc(npcId : int) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			var avatar : AvatarThumb = avatarFactory.makeNpc(npcId);
			avatar.source = npcId;
			avatar.addEventListener(MouseEvent.CLICK, onClickNpc);
			avatar.addEventListener("callback", onNpcCallback);
			var animation : SimpleAnimation = simpleAnimationPool.getObject();
			animation.resetSimple(avatar);
			role.setAnimation(animation);
			role.addToLayer();
			return role;
		}

		private function onNpcCallback(event:Event) : void
		{
			var avatar : AvatarThumb =  event.target as AvatarThumb;
			avatar.source = null;
			avatar.removeEventListener(MouseEvent.CLICK, onClickNpc);
			avatar.removeEventListener("callback", onNpcCallback);
		}
		
		private function onClickNpc(event:MouseEvent):void
		{
			if(MMouse.enableWalk == false) return;
			var avatar : AvatarThumb =  event.currentTarget as AvatarThumb;
			var npcId:int = avatar.source;
			trace("onClickNpc", npcId);
			MTo.toNpc(npcId, 0, MNpc.clickNpcCall, [npcId]);
		}
		

		/** 创建可见怪物 */
		public function makeMonster(npcId : int, avatarId : int, name : String, colorStr : String) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			var avatar : AvatarThumb = avatarFactory.makeMonster(avatarId);
			avatar.source = npcId;
			avatar.addEventListener(MouseEvent.CLICK, onClickMonster);
			avatar.removeEventListener("callback", onMonsterCallback);
			avatar.setName(name, colorStr);
			var animation : SimpleAnimation = simpleAnimationPool.getObject();
			animation.resetSimple(avatar);
			role.setAnimation(animation);
			role.addToLayer();
			return role;
		}
		private function onMonsterCallback(event:Event) : void
		{
			var avatar : AvatarThumb =  event.target as AvatarThumb;
			avatar.source = null;
			avatar.removeEventListener(MouseEvent.CLICK, onClickMonster);
			avatar.removeEventListener("callback", onMonsterCallback);
		}
		
		private function onClickMonster(event:MouseEvent):void
		{
			if(MMouse.enableWalk == false) return;
			var avatar : AvatarThumb =  event.currentTarget as AvatarThumb;
			var npcId:int = avatar.source;
			trace("onClickMonster", npcId);
			MTo.toNpc(npcId);
		}

		/** 创建隐藏怪物 */
		public function makeHideMonster(npcId : int) : Npc
		{
			var role : Npc = npcPool.getObject();
			role.resetNpc(npcId);
			return role;
		}
	}
}
class Singleton
{
}