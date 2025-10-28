using ApiTrain.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiTrain
{
    public class DbContest:DbContext
    {
        public DbContest(
            DbContextOptions<DbContest> options
          ) : base(options)
        {
        }
        //public DbSet<Category> categories { get; set; }
        //public DbSet<Trains> trains { get; set; }
        public DbSet<Rail> rail { get; set; }
        //public DbSet<SegmentRail> segmentRails { get; set; }
        //public DbSet<Crossroads> crossroads { get; set; }
        //public DbSet<Stoplight> stoplights { get; set; }
        //public DbSet<Wagon> wagons { get; set; }

    }
}
