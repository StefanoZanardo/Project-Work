using DashBoardTrains.Models;

namespace DashBoardTrains.Services.CRUDE
{
    public class TrainListService
    {
        public List<Train> trains { get; set; } = new List<Train>();

        public event Action<List<Train>>? trainsChanged;


        public async Task UpdateRow(Train train)
        {
            try
            {
                var valuetrain = trains.Where(a => a.TrainId == train.TrainId).FirstOrDefault();
                if (valuetrain == null)
                {

                    trains.Add(train);
                }
                else if (valuetrain.ActualPositions.x != train.ActualPositions.x || train.ActualPositions.y != valuetrain.ActualPositions.y)
                {
                    int index = trains.IndexOf(valuetrain);

                    trains[index] = train;

                }
                    trainsChanged?.Invoke(trains);

            }
            catch (Exception)
            {
                throw;
            }

        }

        public async Task DeleteRow(Train train)
        {
            try
            {
                var valuetrain = trains.Where(a => a.TrainId == train.TrainId).FirstOrDefault();
                if (valuetrain == null)
                {
                    return;
                }
                var index = trains.IndexOf(valuetrain);
                trains.Remove(valuetrain);
                

                trainsChanged?.Invoke(trains);

            }
            catch (Exception)
            {
                throw;
            }

        }
    }
}
