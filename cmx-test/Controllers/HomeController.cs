namespace crxtest.Controllers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Web.Http;

    public class HomeController : ApiController
    {
        [HttpPost]
        [Route("api/events")]
        public Message Index(RawMessage m)
        {
            try
            {
                using (var dbContext = new Context(new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString)))
                {
                    dbContext.Messages.Add(m.Data);
                    dbContext.SaveChanges();
                }
            }
            catch (System.Exception ex)
            {
                return new Message { ApFloors = ex.Message };
            }

            return m.Data;
        }
    }

    public class RawMessage
    {
        public Message Data { get; set; }
    }
}