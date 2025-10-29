namespace ApiTrain.Models
{
    public class Category
    {
        public int categoryid { get; set; }
        public string? traincategory { get; set; }
        public int priorityvalue { get; set; }
        public int timedelay { get; set; }
        public DateTime departuretrain { get; set; }
        public DateTime arrivaltrain { get; set; }

        public ICollection<Trains> trains { get; set; } = new List<Trains>();
    }

    public class Trains
    {
        public int trainid { get; set; }
        public string? destination { get; set; }
        public int vagons { get; set; }
        public int categoryid { get; set; }

        public Category category {  get; set; }
    }

    public class Rail
    {
        public int railid { get; set; }
        public string railname { get; set; }

     
    }

    public class SegmentRail
    {
        public int segmentrailid { get; set; }
        public int? railid { get; set; }  // nullable per ON DELETE SET NULL
        public string segmentname { get; set; }
        public bool isoccupied { get; set; } = false;
        public Rail rails { get; set; }
        public ICollection<Crossroads> crossroadsastrait1 { get; set; } = new List<Crossroads>();
        public ICollection<Crossroads> crossroadsastrait2 { get; set; } = new List<Crossroads>();
        public ICollection<Stoplight> stoplights { get; set; } = new List<Stoplight>();

    }

    public class Crossroads
    {
        public int crossroadid { get; set; }
        public int? segmenttrait1 { get; set; }
        public int? segmenttrait2 { get; set; }
        public bool changelane { get; set; } = true;
        public bool isoccupied { get; set; } = false;
        public SegmentRail SegmentRail1 { get; set; }

        public SegmentRail SegmentRail2 { get; set; }
    }

    public class Stoplight
    {
        public int stoplightid { get; set; }
        public int? segmentrailid { get; set; }  // nullable per ON DELETE SET NULL
        public bool redlight { get; set; } = false;
        public SegmentRail SegmentRail { get; set; }
    }

    public class Wagon
    {
        public int wagonid { get; set; }
        public int? trainid { get; set; }  // nullable per ON DELETE SET NULL
        public int? wagonssegment { get; set; }  // nullable per ON DELETE SET NULL
        public int capacity { get; set; }

        public Trains trains { get; set; }

        public SegmentRail segmentrail { get; set; }
    }
}
