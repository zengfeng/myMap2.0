package worlds.roles.structs
{

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
     */
    public class PlayerStruct extends BaseStruct
    {
        public var avatarVer : Number = -1;
        public var newAvatarVer : Number = 0;
        
        //=====================
        //  基本属性
        //=====================
        public var level : uint = 0;
        // 将领ID 1-男金刚 2-女金刚 3-男修罗 4-女修罗 5-男天师 6-女天师
        public var heroId : uint = 0;
        public var clothId : uint = 0;
        public var rideId : uint;
        // 模式 0:正常状态 1-4 运镖 5-8加速运镖中 11:渔夫 20:打坐 30-39派对变身状态 40-44派对跳舞状态 45 派对舞伴
        public var model : uint;
        
        
        //=====================
        // 行走中。。。？
        //=====================
        public var fromX:int;
        public var fromY:int;
        public var toX:int;
        public var toY:int;
        public var walking:Boolean;
        public var walkTime:Number;

        public function PlayerStruct()
        {
        }
        
        public function get isNewestAvatar():Boolean
        {
            return avatarVer == newAvatarVer;
        }
    }
}
