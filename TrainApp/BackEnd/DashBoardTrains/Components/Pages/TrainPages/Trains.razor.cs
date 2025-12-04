using Dapper;
using DashBoardTrains.Infrastracture;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class Trains
    {
        private Train _train = new Train()
        {
            DepartureTrain = DateTime.Now,
            ArrivalTrain = DateTime.Now.AddHours(1)
        };

        private List<Category> _categories = new();

        protected override async Task OnInitializedAsync()
        {
            try
            {

                _categories = await _serviceCategory.GetList("/category");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Errore caricamento categorie: {ex.Message}");
            }
        }

        private async Task InserisciTreno()
        {
            try
            {

                await _serviceTrain.PostAsync("/train", _train); 

                NavManager.NavigateTo("/dashboard");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Errore salvataggio: {ex.Message}");

            }
        }
    }
}
