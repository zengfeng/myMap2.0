package worlds.auxiliarys.loads.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class ImageLoader extends LoaderCore
    {
        public function ImageLoader()
        {
            super();
        }
		
		public var url:String;
		override public function generateLoader() : LoaderCore
		{
            super.generateLoader();
            urlRequest.url = url;
			return this;
		}

        public function getBitmap() : Bitmap
        {
            return loader.content as Bitmap;
        }

        public function getBitmapData() : BitmapData
        {
            var bitmap : Bitmap = getBitmap();
            if (bitmap)
            {
                return bitmap.bitmapData;
            }
            return null;
        }
    }
}
