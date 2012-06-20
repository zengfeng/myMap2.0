package worlds.maps.resets
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-7
	// ============================
	public interface IReset
	{
		/** 卸载 */
		function uninstall() : void;

		/** 开始安装 */
		function startInstall() : void;
		
		/** 初始化玩家model状态 */
		 function initPlayerModel(playerId:int, model:int):void;
	}
}
