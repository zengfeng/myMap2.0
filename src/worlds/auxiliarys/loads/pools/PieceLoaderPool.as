package worlds.auxiliarys.loads.pools
{
    import worlds.auxiliarys.loads.expands.PieceLoader;
    import worlds.maps.layers.lands.pieces.PiecePosition;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class PieceLoaderPool
    {
        /** 单例对像 */
        private static var _instance : PieceLoaderPool;

        /** 获取单例对像 */
        static public function get instance() : PieceLoaderPool
        {
            if (_instance == null)
            {
                _instance = new PieceLoaderPool(new Singleton());
            }
            return _instance;
        }

        private const MAX_COUNT : int = 2000;
        public var list : Vector.<PieceLoader> = new Vector.<PieceLoader>();

        function PieceLoaderPool(singleton : Singleton)
        {
        }

        public function getObject(piecePosition : PiecePosition, mapId : int) : PieceLoader
        {
            if (list.length > 0)
            {
                var pieceLoader : PieceLoader = list.pop();
                pieceLoader.isInPool = false;
                pieceLoader.piecePosition = piecePosition;
                pieceLoader.mapId = mapId;
                return pieceLoader;
            }
            return new PieceLoader(piecePosition, mapId);
        }

        /**
         * 
         * @param bitmap
         */
        public function destoryObject(loader : PieceLoader, gc : Boolean = false) : void
        {
            if (loader == null) return;
            if (list.indexOf(loader) != -1) return;
            loader.unloadAndStop(gc);
            if (list.length < MAX_COUNT) list.push(loader);
        }
    }
}
class Singleton
{
}