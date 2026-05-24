using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ApiTrain.Models
{
    public class Category
    {
        public int CategoryId { get; set; }
        public string? TrainCategory { get; set; }
        public int PriorityValue { get; set; }

        [JsonIgnore]
        public ICollection<Train> Trains { get; set; } = new List<Train>();
    }

    public class Train
    {
        public Guid TrainId { get; set; }
        public string? Destination { get; set; }
        public int Vagons { get; set; }
        public int TimeDelay { get; set; }
        public DateTime DepartureTrain { get; set; }
        public DateTime ArrivalTrain { get; set; }

        public int? CategoryId { get; set; }

        [JsonIgnore]
        public Category? Category { get; set; }

        [JsonIgnore]
        public ICollection<Wagon> Wagons { get; set; } = new List<Wagon>();

        [JsonIgnore]
        public ActualPosition? ActualPositions { get; set; }
    }

    public class Rail
    {
        public int RailId { get; set; }
        public string? RailName { get; set; }

        [JsonIgnore]
        public ICollection<SegmentRail> SegmentRails { get; set; } = new List<SegmentRail>();
    }

    public class SegmentRail
    {
        public int SegmentRailId { get; set; }
        public int? RailId { get; set; }
        public string? SegmentName { get; set; }
        public bool IsOccupied { get; set; } = false;

        [JsonIgnore]
        public Rail? Rail { get; set; }

        [JsonIgnore]
        public ICollection<Crossroad> CrossroadsTrait1 { get; set; } = new List<Crossroad>();

        [JsonIgnore]
        public ICollection<Crossroad> CrossroadsTrait2 { get; set; } = new List<Crossroad>();

        [JsonIgnore]
        public ICollection<Stoplight> Stoplights { get; set; } = new List<Stoplight>();

        [JsonIgnore]
        public ICollection<Wagon> Wagons { get; set; } = new List<Wagon>();
    }

    public class Crossroad
    {
        public int CrossroadId { get; set; }
        public int? SegmentTrait1 { get; set; }
        public int? SegmentTrait2 { get; set; }
        public bool ChangeLane { get; set; } = true;
        public bool IsOccupied { get; set; } = false;

        [JsonIgnore]
        public SegmentRail? SegmentRail1 { get; set; }

        [JsonIgnore]
        public SegmentRail? SegmentRail2 { get; set; }
    }

    public class Stoplight
    {
        public int StoplightId { get; set; }
        public int? SegmentRailId { get; set; }
        public bool RedLight { get; set; } = false;

        [JsonIgnore]
        public SegmentRail? SegmentRail { get; set; }
    }

    public class Wagon
    {
        public int WagonId { get; set; }
        public Guid? TrainId { get; set; }       // <-- era int?, ora Guid?
        public int? WagonsSegment { get; set; }
        public int Capacity { get; set; }

        [JsonIgnore]
        public Train? Train { get; set; }

        [JsonIgnore]
        public SegmentRail? SegmentRail { get; set; }
    }

    public class ActualPosition
    {
        public Guid ActualPositionId { get; set; }
        public float x { get; set; }
        public float y { get; set; }
        public float speed { get; set; } 
        public Guid? TrainId { get; set; }

        [JsonIgnore]
        public Train? Train { get; set; }
    }

    public class Credential
    {
        public int Id { get; set; }
        public string NomeUtente { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string Salt { get; set; } = null!;
        public DateTime DataCreazione { get; set; }
    }
}