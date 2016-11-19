namespace crxtest
{
    using System.Web.Http;

    using Owin;
    using Microsoft.Owin;
    using System.Text;

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapWhen(
                state => state.Request.Path == new PathString("/api/events") && state.Request.Method == "GET",
                eventGetApp => eventGetApp.Run(state => state.Response.WriteAsync(Encoding.Default.GetBytes("c9c94dbd905f479bc9057bfc30deb7a3b059cd13")))
            );

            var config = new HttpConfiguration();
            WebApiConfig.Register(config);

            app.UseWebApi(config);
        }
    }
}