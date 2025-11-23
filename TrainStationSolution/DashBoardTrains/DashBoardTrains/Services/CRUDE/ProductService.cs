using Dapper;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Services.CRUDE
{
    public class ProductService
    {
        private string _connectionString;

        public ProductService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("db")
            ?? throw new InvalidOperationException("Connection string 'db' not found.");


        }
        public async Task<List<Products>> GetAllProducts()
        {
            var query = """
                SELECT p.Id,
                       p.Code,
                       p.Name,
                       p.Description,
                       p.Price,
                       p.categoryId,
                       c.Name
                FROM Products p
                INNER JOIN Categories c ON p.categoryId = c.Id
                """;
            using var connection = new SqlConnection(_connectionString);
            var response = await connection.QueryAsync<Products, Category, Products>(query, (product,category)=>
            {
                product.Category = category;
                return product;
            },
            splitOn: "categoryId"
            );
            return response.ToList();
        }
    }
}
