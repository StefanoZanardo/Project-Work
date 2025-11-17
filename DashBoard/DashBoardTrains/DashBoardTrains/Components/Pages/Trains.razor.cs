using DashBoardTrains.Models;
using Dapper;
using System.Data.SqlTypes;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Components.Pages
{
    public partial class Trains
    {
        public string _connectionString = "";
        private Category categoria { get; set; } = new Category();

        public List<Category>? categories  = new();


        protected override async Task OnInitializedAsync()
        {
            
            _connectionString = config.GetConnectionString("db")
            ?? throw new InvalidOperationException("Connection string 'db' not found.");
            

        }
        protected override async Task OnParametersSetAsync()
        {
            await GetAllCategory();
        }


        public async Task GetAllCategory()
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
