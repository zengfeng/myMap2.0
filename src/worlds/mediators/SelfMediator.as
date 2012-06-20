package worlds.mediators
{
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.Callback;
	import worlds.auxiliarys.mediators.MSignal;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	// ============================
	public class SelfMediator
	{
		public static const sInstallComplete : MSignal = new MSignal();
		public static const cWalkStop : Call = new Call();
		public static const cWalkPathTo : Call = new Call();
		public static const cbPosition : Callback = new Callback();
		public static const sPosition : MSignal = new MSignal(int, int);
		public static const sTransport : MSignal = new MSignal();
		public static const sWalkStart : MSignal = new MSignal();
		public static const sWalkEnd : MSignal = new MSignal();
		public static const sDestory : MSignal = new MSignal();
		public static const csWalkTurn : MSignal = new MSignal();
		public static const sWalkTurn : MSignal = new MSignal(int, int, int, int);
	}
}
