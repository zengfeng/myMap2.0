package worlds.auxiliarys.loads.expands
{
    import com.utils.UrlUtils;
    import flash.display.BitmapData;
    import worlds.auxiliarys.loads.core.LoaderCore;
    import worlds.auxiliarys.loads.core.SwfLoader;
    import worlds.auxiliarys.loads.pools.PieceLoaderPool;
    import worlds.maps.layers.lands.pieces.PiecePosition;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class PieceLoader extends SwfLoader
    {
        public var mapId : int;
        public var piecePosition : PiecePosition;

        public function PieceLoader(piecePosition : PiecePosition, mapId : int)
        {
            this.piecePosition = piecePosition;
            this.mapId = mapId;
            super();
        }

        override public function generateLoader() : LoaderCore
        {
            super.generateLoader();
            urlRequest.url = UrlUtils.getMapPiece(mapId, piecePosition.key);
            return this;
        }

        public function getData() : BitmapData
        {
            var myClass : Class = getClass("localPiece");
            return new myClass();
        }

        public function getDataTile(x : int, y : int) : BitmapData
        {
            var className : String = "pieceTile" + y + "_" + x;
            var myClass : Class = getClass(className);
            return new myClass();
        }

        public var isInPool : Boolean = false;

        override public function unloadAndStop(gc : Boolean) : void
        {
            if (isInPool == false)
            {
                isInPool = true;
                PieceLoaderPool.instance.destoryObject(this, gc);
                return;
            }
            super.unloadAndStop(gc);
            if(piecePosition) piecePosition.dispose();
            piecePosition = null;
            mapId = NaN;
        }
    }
}
