namespace ApiTrain.Models.NewFolder
{
    public class ProvaDTO
    {
        public int TrainId { get; set; }
        public string Destination { get; set; }
        public string CategoryName { get; set; }
    }

    public class CrossRoadTraitDTO
    {
        public int CrossroadId { get; set; }
        public int? SegmentTrait1 { get; set; }
        public int? SegmentTrait2 { get; set; }
        public bool ChangeLane { get; set; } = true;
        public bool IsOccupied { get; set; } = false;

        public SegmentRail rail { get; set; } = new SegmentRail();
        public SegmentRail rail2 { get; set; } = new SegmentRail();
    }
}
