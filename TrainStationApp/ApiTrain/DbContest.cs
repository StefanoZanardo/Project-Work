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
        public DbSet<Category> category { get; set; }
        public DbSet<Trains> trains { get; set; }
        public DbSet<Rail> rail { get; set; }
        public DbSet<SegmentRail> segmentRails { get; set; }
        public DbSet<Crossroads> crossroads { get; set; }
        public DbSet<Stoplight> stoplights { get; set; }
        public DbSet<Wagon> wagons { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Crossroads>().HasKey(c => c.crossroadid);

            modelBuilder.Entity<Trains>().HasKey(c => c.trainid);

            modelBuilder.Entity<Trains>()
                .HasOne(t => t.category)
                .WithMany(c => c.trains)
                .HasForeignKey(t => t.categoryid)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Crossroads>()
                .HasOne(c => c.SegmentRail1)
                .WithMany(s => s.crossroadsastrait1)
                .HasForeignKey(c => c.segmenttrait1)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Crossroads>()
                .HasOne(c => c.SegmentRail2)
                .WithMany(s => s.crossroadsastrait2)
                .HasForeignKey(c => c.segmenttrait2)
                .OnDelete(DeleteBehavior.SetNull);


            modelBuilder.Entity<Stoplight>()
                .HasOne(s => s.SegmentRail)
                .WithMany(r => r.stoplights)
                .HasForeignKey(s => s.segmentrailid)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<SegmentRail>()
                .HasOne(s => s.rails)
                .WithMany()
                .HasForeignKey(s => s.railid)
                .OnDelete(DeleteBehavior.SetNull);


            modelBuilder.Entity<Wagon>()
                .HasOne(w => w.trains)
                .WithMany()
                .HasForeignKey(w => w.trainid)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Wagon>()
                .HasOne(w => w.segmentrail)
                .WithMany()
                .HasForeignKey(w => w.wagonssegment)
                .OnDelete(DeleteBehavior.SetNull);
        }

    }
}
