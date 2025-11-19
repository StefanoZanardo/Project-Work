using DashBoardTrains.Models;
using Dapper;
using System.Data.SqlTypes;
using Microsoft.Data.SqlClient;
using DashBoardTrains.Infrastracture;
using System.Text.Json.Serialization;
using System.Runtime.Serialization.Json;
using System.Text.Json;
using DashBoardTrains.Services;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class CategoryTrains
    {
        public string _connectionString = "";
        private Category categoria { get; set; } = NewImplementation.NewClass<Category>();

        public List<Category>? categories  = new();


        protected override async Task OnInitializedAsync()
        {
            
            var response = await File.ReadAllTextAsync("filejson.json");
            var value = JsonSerializer.Deserialize<filejson>(response);
            _connectionString = config.GetConnectionString("db")
            ?? throw new InvalidOperationException("Connection string 'db' not found.");
            

        }
        protected override async Task OnParametersSetAsync()
        {
            await GetAllCategory();
        }


        public async Task<List<Category>> GetAllCategory()
        {
            var query = """
                SELECT t.id,
                t.name
                FROM Categories t
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.QueryAsync<Category>(query);
            categories = response.ToList();
            StateHasChanged();
            return categories;
            
        }

        public async Task InserisciCategoria()
        {
            var query = """
                INSERT INTO Categories (Name)
                VALUES (@Name)
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.ExecuteAsync(query, new { Name = categoria.Name });
            await GetAllCategory();
            StateHasChanged();
            categoria = new Category();
        }

        public async Task EliminaCategoria(int id)
        {
            var query = """
                DELETE FROM Categories
                WHERE Id = @Id
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.ExecuteAsync(query, new { Id = id });
            await GetAllCategory();
            StateHasChanged();
        }

    }
}
