package worlds.maps.resets
{
	import worlds.mediators.PlayerMediator;
	import worlds.players.Model;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class ResetCapital extends ResetNormal
	{
		/** 单例对像 */
		private static var _instance : ResetCapital;

		/** 获取单例对像 */
		public static function get instance() : ResetCapital
		{
			if (_instance == null)
			{
				_instance = new ResetCapital(new Singleton());
			}
			return _instance;
		}

		public function ResetCapital(singleton : Singleton)
		{
		}

		override protected function addSignals() : void
		{
			super.addSignals();
			PlayerMediator.MODEL_CONVOY_IN.add(playerControl.convoyModelIn);
			PlayerMediator.MODEL_CONVOY_OUT.add(playerControl.convoyModelOut);
			PlayerMediator.MODEL_CONVOY_SPEED.add(playerControl.convoyChangeSpeed);
		}

		override protected function removeSignals() : void
		{
			super.removeSignals();
			PlayerMediator.MODEL_CONVOY_IN.remove(playerControl.convoyModelIn);
			PlayerMediator.MODEL_CONVOY_OUT.remove(playerControl.convoyModelOut);
			PlayerMediator.MODEL_CONVOY_SPEED.remove(playerControl.convoyChangeSpeed);
		}

		/** 初始化玩家model状态 */
		override public function initPlayerModel(playerId : int, model : int) : void
		{
			if (Model.isNormal(model))
			{
				return;
			}
			else if (Model.isPractice(model))
			{
				PlayerMediator.sitDown.dispatch(playerId);
			}
			else if (Model.isFishing(model))
			{
				PlayerMediator.MODEL_FISHING_IN.dispatch(playerId);
			}
			else if (Model.isConvory(model))
			{
				PlayerMediator.MODEL_CONVOY_IN.dispatch(playerId, model);
			}
		}
	}
}
class Singleton
{
}