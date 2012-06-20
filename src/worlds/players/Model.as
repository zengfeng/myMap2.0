package worlds.players
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	// ============================
	public class Model
	{
		/** 最小龟拜值 */
		private static const MIN_CONVORY : int = 1;
		/** 最大龟拜值 */
		private static const MAX_CONVORY : int = 10;
		/** 钓鱼 */
		private static const FISHING : int = 11;
		/** 修炼 */
		private static const PRACTICE : int = 20;
		/** 派对变身1 */
		private static const FEAST_MIN : int = 30;
		/** 派对变身6 */
		private static const FEAST_MAX : int = 35;
		/** 派对合体1 */
		private static const FEAST_MATCH_MIN : int = 40 ;
		/** 派对合体3 */
		private static const FEAST_MATCH_MAX : int = 42 ;
		/** 派对舞伴 */
		private static const FEAST_PARTNER : int = 45 ;

		public static function isNormal(model : int) : Boolean
		{
			return model == 0;
		}

		public static function isPractice(model : int) : Boolean
		{
			return model == PRACTICE;
		}

		public static function isConvory(model : int) : Boolean
		{
			return model >= MIN_CONVORY && model <= MAX_CONVORY;
		}

		public static function isFishing(model : int) : Boolean
		{
			return model == FISHING;
		}
	}
}
