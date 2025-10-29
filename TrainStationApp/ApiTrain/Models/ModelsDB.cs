namespace ApiTrain.Models
{
    public class Category
    {
        public int categoryID { get; set; }
        public string? trainCategory { get; set; }
        public int priorityValue { get; set; }
        public int timeDelay { get; set; }
        public DateTime departureTrain { get; set; }
        public DateTime arrivalTrain { get; set; }
    }

    public class Trains
    {
        public int trainID { get; set; }
        public string? destination { get; set; }
        public int vagons { get; set; }
        public int category { get; set; }
    }

    public class Rail
    {
        public int railid { get; set; }
        public string railname { get; set; }

     
    }

    //public class SegmentRail
    //{
    //    public int SegmentRailID { get; set; }
    //    public int? RailID { get; set; }  // nullable per ON DELETE SET NULL
    //    public string SegmentName { get; set; }
    //    public bool IsOccupied { get; set; } = false;

    //    // Navigazione verso Rail
    //    public Rail Rail { get; set; }

    //    // Relazioni con Crossroads e Stoplights
    //    public ICollection<Crossroads> CrossroadsAsTrait1 { get; set; }
    //    public ICollection<Crossroads> CrossroadsAsTrait2 { get; set; }
    //    public ICollection<Stoplight> Stoplights { get; set; }

    //}

    //public class Crossroads
    //{
    //    public int CrossroadID { get; set; }
    //    public int? SegmentTrait1 { get; set; }
    //    public int? SegmentTrait2 { get; set; }
    //    public bool Changelane { get; set; } = true;
    //    public bool IsOccupied { get; set; } = false;

    //    // Navigazioni verso SegmentRail
    //    public SegmentRail Segment1 { get; set; }
    //    public SegmentRail Segment2 { get; set; }
    //}

    //public class Stoplight
    //{
    //    public int StoplightID { get; set; }
    //    public int? SegmentRailID { get; set; }  // nullable per ON DELETE SET NULL
    //    public bool Redlight { get; set; } = false;

    //    // Navigazione verso SegmentRail
    //    public SegmentRail SegmentRail { get; set; }
    //}

    //public class Wagon
    //{
    //    public int WagonID { get; set; }
    //    public int? TrainID { get; set; }  // nullable per ON DELETE SET NULL
    //    public int? WagonsSegment { get; set; }  // nullable per ON DELETE SET NULL
    //    public int Capacity { get; set; }
    //}
}
