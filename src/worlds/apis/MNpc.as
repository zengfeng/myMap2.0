package worlds.apis
{
	import game.module.quest.QuestUtil;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.NpcMediator;
	import worlds.roles.cores.Npc;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	// ============================
	public class MNpc
	{
		/** 安装完成 */
		public static const sInstallComplete : MSignal = NpcMediator.installCompleted;
		public static const clickNpcCall:Function =QuestUtil.npcClick;

		public static function getNpc(npcId : int) : Npc
		{
			return NpcMediator.getNpc.call(npcId);
		}

		public static function add(npcId : int) : void
		{
			NpcMediator.addData.call(npcId);
		}

		public static function remove(npcId : int) : void
		{
			NpcMediator.removeData.call(npcId);
		}
	}
}