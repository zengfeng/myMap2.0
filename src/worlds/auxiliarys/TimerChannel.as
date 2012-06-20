package worlds.auxiliarys
{
	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-8
	// ============================
	public class TimerChannel
	{
	
		/**  frame = 3;   frameRate = 20; */
		public static const TIME_50 : int = 50;
		/**  frame = 6;   frameRate = 10;*/
		public static const TIME_100 : int = 100;
		/** frame = 10;   frameRate = 6;*/
		public static const TIME_167 : int = 167;
		/**  frame = 12;   frameRate = 5;*/
		public static const TIME_200 : int = 200;
		/**  frame = 30;   frameRate = 2;*/
		public static const TIME_500 : int = 500;
		/** frame = 60;   frameRate = 1;*/
		public static const TIME_1000 : int = 1000;
		/** frame = 120;   frameRate = 0.5;*/
		public static const TIME_2000 : int = 2000;
		/** frame = 180;   frameRate = 0.3;*/
		public static const TIME_3000 : int = 3000;
		/** frame = 300;   frameRate = 0.2;*/
		public static const TIME_5000 : int = 5000;
		private static var _dic : Dictionary;

		private static function get dic() : Dictionary
		{
			if (_dic == null)
			{
				_dic = new Dictionary();
				_dic[TIME_50] = new TimerListener(TIME_50);
				_dic[TIME_100] = new TimerListener(TIME_100);
				_dic[TIME_167] = new TimerListener(TIME_167);
				_dic[TIME_200] = new TimerListener(TIME_200);
				_dic[TIME_500] = new TimerListener(TIME_500);
				_dic[TIME_1000] = new TimerListener(TIME_1000);
				_dic[TIME_2000] = new TimerListener(TIME_2000);
				_dic[TIME_3000] = new TimerListener(TIME_3000);
				_dic[TIME_5000] = new TimerListener(TIME_5000);
			}
			return _dic;
		}

		private static var tempTimer : TimerListener;

		public static function add(time : int, fun : Function) : void
		{
			tempTimer = dic[time];
			if (tempTimer)
			{
				tempTimer.add(fun);
			}
			tempTimer = null;
		}

		public static function remove(time : int, fun : Function) : void
		{
			tempTimer = dic[time];
			if (tempTimer)
			{
				tempTimer.remove(fun);
			}
			tempTimer = null;
		}

		public static function clear(time : int) : void
		{
			tempTimer = dic[time];
			if (tempTimer)
			{
				tempTimer.clear();
			}
			tempTimer = null;
		}
	}
}
