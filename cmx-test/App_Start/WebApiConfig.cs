namespace crxtest
{
    using System.Web.Http;

    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API routes
            config.MapHttpAttributeRoutes();

            // Remove the xml formatter, he cant really handle derived types by default
            config.Formatters.Remove(config.Formatters.XmlFormatter);
        }
    }
}
