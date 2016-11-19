namespace crxtest.Controllers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Web.Http;

    public class HomeController : ApiController
    {
        [HttpPost]
        [Route("api/events")]
        public void Index(Message m)
        {
            using (var dbContext = new Context(new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString)))
            {
                dbContext.Messages.Add(m);
                dbContext.SaveChanges();
            }
        }
    }   
}