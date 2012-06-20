package worlds.mediators
{
	import worlds.auxiliarys.mediators.Call;
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	// ============================
	public class ToMediator
	{
		public static const toPoint:Call = new Call();
		public static const toNpc:Call = new Call();
		public static const toGate:Call = new Call();
		public static const toMap:Call = new Call();
		public static const toDuplNpc:Call = new Call();
		public static const transportTo:Call = new Call();
		public static const toExitGate:Call = new Call();
	}
}
