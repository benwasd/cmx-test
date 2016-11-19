using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json.Serialization;

namespace crxtest
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}"
            );

            // Remove the xml formatter, he cant really handle derived types by default
            config.Formatters.Remove(config.Formatters.XmlFormatter);

            //// skip nulled properties
            //config.Formatters.JsonFormatter.SerializerSettings.NullValueHandling = NullValueHandling.Ignore;

            //// convert date properties to local time
            //config.Formatters.JsonFormatter.SerializerSettings.DateTimeZoneHandling = DateTimeZoneHandling.RoundtripKind;

            //// Enable $type for the json.net serializer, will handle deriverd types perfectly in combination with Practices.TypeScriptGen
            //config.Formatters.JsonFormatter.SerializerSettings.TypeNameHandling = TypeNameHandling.;
            //config.Formatters.JsonFormatter.SerializerSettings.TypeNameAssemblyFormat = FormatterAssemblyStyle.Simple;
        }
    }
}
