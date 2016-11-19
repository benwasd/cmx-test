namespace crxtest.Controllers
{
    using System;
    using System.Configuration;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Web.Http;

    public class HomeController : ApiController
    {
        [HttpGet]
        [Route("api/events")]
        public string Validator()
        {
            return "c9c94dbd905f479bc9057bfc30deb7a3b059cd13";
        }

        [HttpPost]
        [Route("api/events")]
        public string Index()
        {
            using (var dbContext = new ItemDbContext(new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString)))
            {
                dbContext.Items.Add(new Item { ApMac = "Lola", ClientMac = "Lo", Rssi = "asdasd" });
                dbContext.SaveChanges();

                return "OK";
            }
        }

        public void Store(Item i)
        {

        }
    }

    public class ItemDbContext : DbContext
    {
        public ItemDbContext(SqlConnection connection) : base(connection, true)
        {
        }

        public DbSet<Item> Items => this.Set<Item>();

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Item>().HasKey(x => x.Id);
        }
    }

    public class Item
    {
        public Item()
        {
            this.Id = Guid.NewGuid();
        }

        public Guid Id { get; set; }
        public string ApMac { get; set; }
        public string ClientMac { get; set; }
        public string Rssi { get; set; }
    }
}
