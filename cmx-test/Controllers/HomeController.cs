namespace crxtest.Controllers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Web.Http;

    public class HomeController : ApiController
    {
        private Context dbContext = new Context(new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));

        [HttpPost]
        [Route("api/events")]
        public void Index(RawMessage m)
        {
            dbContext.Messages.Add(m.Data);
            dbContext.SaveChanges();
        }
    }

    public class RawMessage
    {
        public Message Data { get; set; }
    }
}