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
        public int crossroadid { get; set; }
        public int? segmenttrait1 { get; set; }
        public int? segmenttrait2 { get; set; }
        public bool changelane { get; set; } = true;
        public bool isoccupied { get; set; } = false;

        public SegmentRail rail { get; set; }
        public SegmentRail rail2 { get; set; }
    }
}
