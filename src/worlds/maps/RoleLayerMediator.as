package worlds.maps
{
	import worlds.auxiliarys.mediators.Call;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-24
	 */
	public class RoleLayerMediator
	{
		/** 添加到RoleLayer，args=[Avatar, childIndex] */
		public static const cAdd : Call = new Call();
		/** 移除从RoleLayer  */
		public static const cRemove : Call = new Call();
		/** 深度改变 args=[Avatar, childIndex] */
		public static const cChangeDepth : Call = new Call();
	}
}
