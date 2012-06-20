package worlds.auxiliarys.loads.core
{

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class SwfLoader extends LoaderCore
    {
        public function SwfLoader()
        {
            super();
        }

        public function getClass(className : String) : Class
        {
            if (loader)
            {
                if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className))
                {
                    return loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
                }
            }
            return null;
        }
    }
}
