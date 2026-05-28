using DashBoardTrains.Models;
using DashBoardTrains.Services.CRUDE;
using Microsoft.AspNetCore.Components;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class Simulator : IDisposable
    {
        //private HashSet<string> expandedTrainIds = new();

        private HashSet<Guid> expandedTrainIds = new();

        private List<Train> Trains = new()
    {
    };

        [Inject]
        private TrainListService _trainListService { get; set; } = default!;

        protected override Task OnInitializedAsync()
        {
            _trainListService.trainsChanged += UpdateTable;

            Console.Write(_trainListService);
            return base.OnInitializedAsync();
        }
        private void ToggleExpand(string trainId)
        {
            if (!expandedTrainIds.Add(Guid.Parse(trainId)))
                expandedTrainIds.Remove(Guid.Parse(trainId));
        }

        public void UpdateTable(List<Train> trains)
        {
            Trains = trains;

            InvokeAsync(StateHasChanged);
            
        }

        public void Dispose()
        {
            _trainListService.trainsChanged -= UpdateTable;
        }
    }
}
