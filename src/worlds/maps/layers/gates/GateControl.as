package worlds.maps.layers.gates
{
	import com.utils.UrlUtils;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;
	import worlds.apis.GateOpened;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.maps.configs.MapId;
	import worlds.maps.configs.structs.GateStruct;







	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	// ============================
	public class GateControl
	{
		/** 单例对像 */
		private static var _instance : GateControl;

		/** 获取单例对像 */
		static public function get instance() : GateControl
		{
			if (_instance == null)
			{
				_instance = new GateControl(new Singleton());
			}
			return _instance;
		}

		private var dic : Dictionary = new Dictionary();

		function GateControl(singleton : Singleton) : void
		{
		}

		public function install() : void
		{
			loadGate();
		}

		public function uninstall() : void
		{
			GateOpened.signalState.remove(setGateOpenClose);
			var keyArr : Array = [];
			for (var key:String in dic)
			{
				keyArr.push(key);
			}

			var gateId : int;
			while (keyArr.length > 0)
			{
				gateId = parseInt(keyArr.shift());
				removeGate(gateId);
				delete dic [gateId] ;
			}
		}

		/** 加载八卦阵(出口入口) */
		private function loadGate() : void
		{
			if (GatePool.instance.GateClass)
			{
				setupGateList();
				return;
			}
			var url : String = UrlUtils.FILE_GATE;
			var key : String = "gate";
			RESManager.instance.load(new LibData(url, key, true), loadGate_onComplete, [key]);
		}

		/** 加载完加载八卦阵(出口入口) */
		private function loadGate_onComplete(key : String) : void
		{
			// 读取加载
			var loader : SWFLoader = RESManager.getLoader(key);
			if (loader == null) return;
			GatePool.instance.GateClass = loader.getClass("Gate");
			// 安装载八卦阵(出口入口)列表
			setupGateList();
		}

		/** 安装载八卦阵(出口入口)列表 */
		private function setupGateList() : void
		{
			if (GatePool.instance.GateClass == null) return;
			var linkGates : Dictionary = MapUtil.getGateStructDic();
			for each (var gateStruct:GateStruct in linkGates)
			{
				if ( GateOpened.getState(gateStruct.id) ) addGate(gateStruct);
			}
			GateOpened.signalState.add(setGateOpenClose);
		}

		public function setGateOpenClose(gateId : int, isOpen : Boolean) : void
		{
			if (isOpen)
			{
				var gate : MovieClip = dic [gateId] ;
				if (!gate )
				{
					var struct : GateStruct = MapUtil.getGateStructById(gateId);
					addGate(struct);
				}
			}
			else
			{
				removeGate(gateId);
			}
		}

		/** 加入八卦阵(出入口) */
		private function addGate(struct : GateStruct) : void
		{
			if (struct == null) return;
			var elementName : String = "gate_" + struct.toMapId + "_" + struct.id;
			var element : MovieClip = dic[struct.id];
			if (element)
			{
				element.x = struct.position.x;
				element.y = struct.position.y;
				return;
			}
			element = GatePool.instance.getObject();
			element.name = elementName;
			element.x = struct.position.x;
			element.y = struct.position.y;
			element.mouseChildren = false;
			element.mouseEnabled = true;
			element.addEventListener(MouseEvent.CLICK, gateOnclick);
			element.gotoAndPlay(1);
			GateMediator.addToLayer.call(element);
			dic [struct.id] = element;
		}

		/** 移除八卦阵(出入口) */
		private function removeGate(gateId : int) : void
		{
			var element : MovieClip = dic [gateId] ;
			if (element)
			{
				element.stop();
				element.removeEventListener(MouseEvent.CLICK, gateOnclick);
				GateMediator.removeFromLayer.call(element);
				GatePool.instance.destoryObject(element);
				delete dic [gateId] ;
			}
		}

		/**  八卦阵(出入口) 点击事件 */
		private function gateOnclick(event : MouseEvent) : void
		{
			var gate : MovieClip = event.target as 	MovieClip;
			var str : String = gate.name.replace("gate_", "");
			var arr : Array = str.split("_");
			var toMapId : int = parseInt(arr[0]);
			var gateId : int = parseInt(arr[1]);
			MTo.toGate(toMapId, 0, false, arriveGate, [toMapId, gateId]);
		}

		/** 到达八卦阵(出口入口) */
		private function arriveGate(toMapId : int, gateId : int = 0) : void
		{
			if (toMapId == MapId.BACK)
			{
				MWorld.csChangeMap(toMapId);
				return;
			}
			MWorld.csUseGateChangeMap(gateId);
		}
	}
}
class Singleton
{
}