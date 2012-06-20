package worlds.npcs
{
	import worlds.mediators.NpcMediator;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-23
	 */
	public class NpcData
	{
		/** 单例对像 */
		private static var _instance : NpcData;

		/** 获取单例对像 */
		static public function get instance() : NpcData
		{
			if (_instance == null)
			{
				_instance = new NpcData(new Singleton());
			}
			return _instance;
		}

		function NpcData(singleton : Singleton) : void
		{
			singleton;
			NpcMediator.installCompleted.add(setInstalled);
			NpcMediator.addData.register(add);
			NpcMediator.removeData.register(remove);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var list : Vector.<uint> = new Vector.<uint>();
		public var waitInstallList : Vector.<uint> = new Vector.<uint>();

		/** 清理 */
		public function clear() : void
		{
			NpcMediator.stopInstall.dispatch();
			while (list.length > 0)
			{
				list.pop();
			}
			while (waitInstallList.length > 0)
			{
				waitInstallList.pop();
			}
		}

		/** 添加 */
		public function add(npcId : int) : void
		{
			var index : int = list.indexOf(npcId);
			if (index == -1)
			{
				list.push(npcId);
			}
			index = waitInstallList.indexOf(npcId);
			if (index == -1)
			{
				waitInstallList.push(npcId);
				NpcMediator.add.dispatch(npcId);
			}
		}

		/** 移除 */
		public function remove(npcId : int) : void
		{
			var index : int = list.indexOf(npcId);
			if (index != -1)
			{
				list.splice(index, 1);
			}
			index = waitInstallList.indexOf(npcId);
			if (index != -1)
			{
				waitInstallList.splice(index, 1);
			}

			NpcMediator.remove.dispatch(npcId);
		}

		/** 设置安装完成 */
		public function setInstalled(npcId : int) : void
		{
			var index : int = waitInstallList.indexOf(npcId);
			if (index != -1)
			{
				waitInstallList.splice(index, 1);
			}
		}

		/** 是否安装完成 */
		public function isInstalled(npcId : int) : Boolean
		{
			return list.indexOf(npcId) != -1 && waitInstallList.indexOf(npcId) == -1;
		}

		/** 是否有等待安装的 */
		public function hasWaitInstall() : Boolean
		{
			return waitInstallList.length > 0;
		}
	}
}
class Singleton
{
}