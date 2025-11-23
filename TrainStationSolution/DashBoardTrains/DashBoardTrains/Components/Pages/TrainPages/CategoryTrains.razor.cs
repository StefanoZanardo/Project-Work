using DashBoardTrains.Models;
using System.Data.SqlTypes;
using DashBoardTrains.Infrastracture;
using System.Text.Json.Serialization;
using System.Runtime.Serialization.Json;
using System.Text.Json;
using DashBoardTrains.Services;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class CategoryTrains
    {
        private Category categoria { get; set; } = NewImplementation.NewClass<Category>();

        public List<Category>? categories  = new();


        protected override async Task OnInitializedAsync()
        {
            categories = await categoryService.GetAllCategory();

            StateHasChanged();

        }
        protected override async Task OnParametersSetAsync()
        {
            await GetAllCategory();
        }


        public async Task GetAllCategory()
        {
            categories = await categoryService.GetAllCategory();
            StateHasChanged();
        }

        public async Task InserisciCategoria()
        {
           throw new NotImplementedException();
        }

        public async Task EliminaCategoria(int id)
        {
           /* var query = """
                DELETE FROM Categories
                WHERE Id = @Id
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.ExecuteAsync(query, new { Id = id });
            await GetAllCategory();
            StateHasChanged();*/
        }

    }
}
