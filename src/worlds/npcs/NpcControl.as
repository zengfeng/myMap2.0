package worlds.npcs
{
	import log4a.Logger;
	import worlds.apis.MTo;

	import worlds.apis.MNpc;

	import flash.utils.Dictionary;

	import worlds.apis.MapUtil;
	import worlds.mediators.NpcMediator;
	import worlds.mediators.SelfMediator;
	import worlds.roles.cores.Npc;
	import worlds.roles.cores.Role;
	import worlds.roles.structs.NpcStruct;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
	 */
	public class NpcControl
	{
		/** 单例对像 */
		private static var _instance : NpcControl;

		/** 获取单例对像 */
		static public function get instance() : NpcControl
		{
			if (_instance == null)
			{
				_instance = new NpcControl(new Singleton());
			}
			return _instance;
		}

		function NpcControl(singleton : Singleton) : void
		{
			singleton;
			dic = new Dictionary();
			aiWaitStartupList = new Vector.<Npc>();
			aiList = new Array();
			mapNpcs = NpcData.instance;
			npcFactory = NpcFactory.instance;
			NpcMediator.startInstall.add(startInstall);
			NpcMediator.stopInstall.add(stopInstall);
			NpcMediator.remove.add(remove);
			NpcMediator.uninstall.add(uninstall);
			NpcMediator.aiHit.add(aiHit);
			NpcMediator.gotoNextAI.add(gotoNextAI);
			SelfMediator.sInstallComplete.add(startupWaitAI);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var dic : Dictionary;
		private var aiWaitStartupList : Vector.<Npc>;
		private var aiList : Array;
		private var nextAI : int;
		private var mapNpcs : NpcData;
		private var npcFactory : NpcFactory;
		private var enStartupAI : Boolean = false;

		private function startupWaitAI() : void
		{
			enStartupAI = true;
			var npc : Npc;
			while (aiWaitStartupList.length > 0)
			{
				npc = aiWaitStartupList.shift();
				startupAI(npc);
			}
		}

		private function startupAI(npc : Npc) : void
		{
			var struct : NpcStruct = MapUtil.getNpcStruct(npc.id);
			npc.startupAI(struct.x, struct.y, struct.standPostion, struct.moveRadius, struct.attackRadius);
		}

		private function aiHit(npcId : int) : void
		{
			trace("NpcControl::aiHit " + npcId);
			MNpc.clickNpcCall(npcId);
		}

		private function gotoNextAI() : void
		{
			if (nextAI == -1) return;
			var npc : Npc = getNpc(nextAI);
			MTo.toPoint(npc.x, npc.y);
		}

		private function setNextAI() : void
		{
			aiList.sort(Array.NUMERIC);
			if (aiList.length > 0)
			{
				nextAI = aiList[0];
			}
			else
			{
				nextAI = -1;
			}
		}

		private function getNpc(npcId : int) : Npc
		{
			return dic[npcId];
		}

		/** 添加 */
		private function add(npcId : int) : void
		{
			var struct : NpcStruct = MapUtil.getNpcStruct(npcId);
			if (struct == null)
			{
//				Alert.show("地图没配置npc" + npcId);
				Logger.info("地图没配置npc" + npcId);
				NpcMediator.installCompleted.dispatch(npcId);
				return;
			}

			var npc : Npc = npcFactory.make(npcId, struct.hasAvatar, struct.avatarId, struct.name, struct.colorStr);
			npc.initPosition(struct.x, struct.y, struct.speed);
			dic[npcId] = npc;
			if (struct.isHit)
			{
				if (enStartupAI)
				{
					startupAI(npc);
				}
				else
				{
					aiWaitStartupList.push(npc);
				}
				aiList.push(npcId);
				setNextAI();
			}
			NpcMediator.installCompleted.dispatch(npcId);
		}

		/** 移除 */
		private function remove(npcId : int) : void
		{
			var role : Role = dic[npcId];
			role.destory();
			dic[npcId] = null;
			delete  dic[npcId];

			var index : int = aiList.indexOf(npcId);
			if (index != -1)
			{
				aiList.splice(index, 1);
				setNextAI();
			}
		}

		private var keyArr : Array = [];

		/** 移除所有 */
		private function uninstall() : void
		{
			while (aiList.length > 0)
			{
				aiList.shift();
			}

			enStartupAI = false;
			while (aiWaitStartupList.length > 0)
			{
				aiWaitStartupList.shift();
			}

			var key : String;
			for (key  in  dic)
			{
				keyArr.push(key);
			}
			var role : Role ;
			while (keyArr.length > 0)
			{
				key = keyArr.pop();
				role = dic[key];
				if (role == null)
				{
					trace(key);
					dic[key] = null;
					delete  dic[key];
					return;
				}
				role.destory();
				dic[key] = null;
				delete  dic[key];
			}
		}

		/** 开始安装 */
		private function startInstall() : void
		{
			NpcMediator.add.add(add);
			var list : Vector.<uint> = mapNpcs.waitInstallList;
			while (list.length > 0)
			{
				add(list[0]);
			}
		}

		/** 停止安装 */
		private function stopInstall() : void
		{
			NpcMediator.add.remove(add);
		}
	}
}
class Singleton
{
}