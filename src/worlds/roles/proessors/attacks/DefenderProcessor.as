package worlds.roles.proessors.attacks
{

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-5-31
	// ============================
	public class DefenderProcessor
	{
		protected var list : Vector.<AttackerProcessor> = new Vector.<AttackerProcessor>();
		protected var callDestory : Function;

		public function reset(callDestory : Function) : void
		{
			this.callDestory = callDestory;
		}

		public function destory() : void
		{
			removeAllAttacker();
			callDestory(true);
		}

		public function addAttacker(attacker : AttackerProcessor) : void
		{
			var index:int = list.indexOf(attacker);
			if(index == -1)
			{
				list.push(attacker);
			}
		}

		public function removeAttacker(attacker : AttackerProcessor, destoryed:Boolean = false) : void
		{
			var index:int = list.indexOf(attacker);
			list.splice(index, 1);
			if(!destoryed)attacker.destory(true);
		}

		protected function removeAllAttacker() : void
		{
			while (list.length > 0)
			{
				removeAttacker(list[0]);
			}
		}
		
		public function move(x:int, y:int):void
		{
			var length:int = list.length;
			for(var i:int = 0; i < length; i ++)
			{
				(list[i] as AttackerProcessor).defenderMove(x, y);
			}
		}
	}
}
