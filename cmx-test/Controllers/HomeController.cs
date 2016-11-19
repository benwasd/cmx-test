namespace crxtest.Controllers
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Http;

    public class HomeController : ApiController
    {
        [HttpPost]
        [Route("api/events")]
        public async Task<string> Index(RawMessage m)
        {
            try
            {
                var message = m.Data;
                message.Event = m.Type;

                await this.PersistMessage(message);

                return "OK";
            }
            catch (Exception ex)
            {
                var message = new Message();
                message.Event = $"Error, {ex}";

                await this.PersistMessage(message);

                return "FAIL";
            }
        }

        private async Task PersistMessage(Message message)
        {
            foreach (var observation in message.Observations ?? Enumerable.Empty<Observation>())
            {
                observation.Location = observation.Location ?? new Location();
            }

            using (var dbContext = new Context(new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString)))
            {
                dbContext.Messages.Add(message);
                await dbContext.SaveChangesAsync();
            }
        }
    }

    public class RawMessage
    {
        public Message Data { get; set; }
        public string Type { get; set; }
    }
}