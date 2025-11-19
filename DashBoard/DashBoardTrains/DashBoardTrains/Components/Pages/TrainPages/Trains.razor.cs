using Dapper;
using DashBoardTrains.Infrastracture;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class Trains
    {
        private string _connectionString = "";

        private List<Category> _categories = new List<Category>();
        private Products _product { get; set; } = NewImplementation.NewClass<Products>();

        private List<Products> _products = new List<Products>();


        protected override async Task OnInitializedAsync()
        {
            _connectionString = config.GetConnectionString("db");
            _categories = await _categoryService.GetAllCategory();
            _products = await _productService.GetAllProducts();
            StateHasChanged();
        }
 
        private async Task InserisciProdotto()
        {
            var query = """
                INSERT INTO Products (Code, Name, Description, Price, CategoryId)
                VALUES (@Code, @Name, @Description, @Price, @categoryId)
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.ExecuteAsync(query, _product);
            StateHasChanged();
        }
    }
}
