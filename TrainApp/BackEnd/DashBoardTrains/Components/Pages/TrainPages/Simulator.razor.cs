using DashBoardTrains.Models;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class Simulator
    {
        //private HashSet<string> expandedTrainIds = new();

        private HashSet<Guid> expandedTrainIds = new();

        private static readonly Guid Id1 = new("a1b2c3d4-0001-0001-0001-000000000001");
        private static readonly Guid Id2 = new("e5f6a7b8-0002-0002-0002-000000000002");
        private static readonly Guid Id3 = new("c9d0e1f2-0003-0003-0003-000000000003");

        private List<Train> Trains = new()
    {
        new Train
        {
            TrainId      = Id1,
            Destination  = "R1",
            Vagons       = 3,
            TimeDelay    = 0,
            DepartureTrain = DateTime.Now.AddMinutes(-30),
            ArrivalTrain   = DateTime.Now.AddMinutes(15),
            CategoryId   = 1,
            ActualPositions = new ActualPosition
            {
                ActualPositionId = new Guid("aaaaaaaa-0001-0001-0001-000000000001"),
                x = 680.9f, y = 215f, speed = 135f,
                TrainId = Id1
            }
        },
        new Train
        {
            TrainId      = Id2,
            Destination  = "C2",
            Vagons       = 1,
            TimeDelay    = 3,
            DepartureTrain = DateTime.Now.AddMinutes(-10),
            ArrivalTrain   = DateTime.Now.AddMinutes(40),
            CategoryId   = 2,
            ActualPositions = new ActualPosition
            {
                ActualPositionId = new Guid("bbbbbbbb-0002-0002-0002-000000000002"),
                x = 50f, y = 260f, speed = 80f,
                TrainId = Id2
            }
        },
        new Train
        {
            TrainId      = Id3,
            Destination  = "L2",
            Vagons       = 5,
            TimeDelay    = 12,
            DepartureTrain = DateTime.Now.AddHours(-1),
            ArrivalTrain   = DateTime.Now.AddMinutes(5),
            CategoryId   = 1,
            ActualPositions = null   // nessuna posizione registrata
        }
    };
        private void ToggleExpand(string trainId)
        {
            if (!expandedTrainIds.Add(Guid.Parse(trainId)))
                expandedTrainIds.Remove(Guid.Parse(trainId));
        }
    }
}
