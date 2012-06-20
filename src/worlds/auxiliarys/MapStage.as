package worlds.auxiliarys
{
	import flash.display.Stage;
	import flash.events.Event;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-12
     */
    public class MapStage
    {
        /** 单例对像 */
        private static var _instance : MapStage;

        /** 获取单例对像 */
        private static  function get instance() : MapStage
        {
            if (_instance == null)
            {
                _instance = new MapStage(new Singleton());
            }
            return _instance;
        }

        function MapStage(singleton : Singleton) : void
        {
        }
		
		//=======================
		// 私有类内方法
		//=======================
        private var stageResizeCallList : Vector.<Function> = new Vector.<Function>();
        private var isAaddStageReisizeEvent : Boolean = false;

        private  function addStageResize(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = stageResizeCallList.indexOf(fun);
            if (index == -1)
            {
                stageResizeCallList.push(fun);
                if (isAaddStageReisizeEvent == false)
                {
                    isAaddStageReisizeEvent = true;
                    stage.addEventListener(Event.RESIZE, onStageResize);
                }
            }
        }

        private  function removeStageResize(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = stageResizeCallList.indexOf(fun);
            if (index != -1)
            {
                stageResizeCallList.splice(index, 1);
                if (isAaddStageReisizeEvent == true && stageResizeCallList.length > 0)
                {
                    stage.removeEventListener(Event.RESIZE, onStageResize);
                    isAaddStageReisizeEvent = false;
                }
            }
        }

        private function onStageResize(event : Event) : void
        {
            stageWidth = stage.stageWidth;
            stageHeight = stage.stageHeight;
            var length : int = stageResizeCallList.length;
            var fun : Function;
            for (var i : int = 0; i < length; i++)
            {
                fun = stageResizeCallList[i];
                fun.apply(null, [stageWidth, stageHeight]);
            }
        }
		//=======================
		//  静态属性
		//=======================
        public static var stage : Stage;
        public static var stageWidth : int;
        public static var stageHeight : int;

		//=======================
		//  静态开放方法
		//=======================
        public static function startup(stage : Stage) : void
        {
            MapStage.stage = stage;
            stageWidth = stage.stageWidth;
            stageHeight = stage.stageHeight;
        }

        public static function addStageResize(fun : Function) : void
        {
            instance.addStageResize(fun);
        }

        public static function removeStageResize(fun : Function) : void
        {
            instance.removeStageResize(fun);
        }
    }
}
class Singleton
{
}