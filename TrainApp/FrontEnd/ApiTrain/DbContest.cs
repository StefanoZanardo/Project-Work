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
        public DbSet<Category> Categories { get; set; }
        public DbSet<Train> Trains { get; set; }
        public DbSet<Rail> Rails { get; set; }
        public DbSet<SegmentRail> SegmentRails { get; set; }
        public DbSet<Crossroad> Crossroads { get; set; }
        public DbSet<Stoplight> Stoplights { get; set; }
        public DbSet<Wagon> Wagons { get; set; }

        public DbSet<ActualPosition> ActualPosition { get; set; }

        public DbSet<Credential> Credentials { get; set; }   


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Serve ad Entity FrameWork per capire quali sono le chiavi primarie e come si chiamano le tabelle
            modelBuilder.Entity<Rail>().ToTable("RAIL").HasKey(c => c.RailId);
            modelBuilder.Entity<Category>().ToTable("CATEGORY").HasKey(c=>c.CategoryId);
            modelBuilder.Entity<Train>().ToTable("TRAINS").HasKey(c => c.TrainId);
            modelBuilder.Entity<SegmentRail>().ToTable("SEGMENTRAIL").HasKey(s=> s.SegmentRailId);
            modelBuilder.Entity<Crossroad>().ToTable("CROSSROADS").HasKey(c => c.CrossroadId);
            modelBuilder.Entity<Stoplight>().ToTable("STOPLIGHT").HasKey(s=>s.StoplightId);
            modelBuilder.Entity<Wagon>().ToTable("WAGONS").HasKey(W=>W.WagonId);
            modelBuilder.Entity<ActualPosition>().ToTable("ACTUALPOSITION").HasKey(A=> A.ActualPositionId);
            modelBuilder.Entity<Credential>().ToTable("credential").HasKey(c => c.Id);



            modelBuilder.Entity<Train>()
                .HasOne(t => t.Category)
                .WithMany(c => c.Trains)
                .HasForeignKey(t => t.CategoryId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Crossroad>()
                .HasOne(c => c.SegmentRail1)
                .WithMany(s => s.CrossroadsTrait1)
                .HasForeignKey(c => c.SegmentTrait1)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Crossroad>()
                .HasOne(c => c.SegmentRail2)
                .WithMany(s => s.CrossroadsTrait2)
                .HasForeignKey(c => c.SegmentTrait2)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<Stoplight>()
                .HasOne(s => s.SegmentRail)
                .WithMany(r => r.Stoplights)
                .HasForeignKey(s => s.SegmentRailId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<SegmentRail>()
                .HasOne(s => s.Rail)
                .WithMany(r => r.SegmentRails)
                .HasForeignKey(s => s.RailId)
                .OnDelete(DeleteBehavior.SetNull);


            modelBuilder.Entity<Wagon>()
                .HasOne(w => w.Train)
                .WithMany(t => t.Wagons)
                .HasForeignKey(w => w.TrainId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Wagon>()
                .HasOne(w => w.SegmentRail)
                .WithMany(s=> s.Wagons)
                .HasForeignKey(w => w.WagonsSegment)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<ActualPosition>()
                .HasOne(w => w.Train)
                .WithOne(t => t.ActualPositions)
                .HasForeignKey<Train>(f=>f.ActualPositionId)
                .OnDelete(DeleteBehavior.SetNull);
            
            modelBuilder.Entity<Train>()
                .HasOne(w => w.ActualPositions)
                .WithOne(t => t.Train)
                .HasForeignKey<ActualPosition>(f=>f.TrainId)
                .OnDelete(DeleteBehavior.SetNull);
        }

    }
}
