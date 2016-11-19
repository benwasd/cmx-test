namespace crxtest.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.SqlClient;

    public class Context : DbContext
    {
        public Context(SqlConnection connection) : base(connection, true)
        {
        }

        public DbSet<Message> Messages => this.Set<Message>();

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Message>()
                .HasKey(x => x.Id)
                .HasMany(x => x.Observations).WithRequired().HasForeignKey(x => x.MessageId);

            modelBuilder.Entity<Observation>();

            modelBuilder.ComplexType<Location>();
        }
    }

    public class Message
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string ApMac { get; set; }
        public string ApFloors { get; set; }
        public ICollection<Observation> Observations { get; set; }
    }

    public class Observation
    {
        public Guid MessageId { get; set; } = Guid.NewGuid();
        public string ClientMac { get; set; }
        public string ProbeEpoch { get; set; }
        public string ProbeTime { get; set; }
        public string RSSI { get; set; }
        public string SSID { get; set; }
        public string Manufacturer { get; set; }
        public string OS { get; set; }
        public Location Location { get; set; } = new Location();
    }

    public class Location
    {
        public decimal Lat { get; set; }
        public decimal Lng { get; set; }
        public decimal Unc { get; set; }
    }
}