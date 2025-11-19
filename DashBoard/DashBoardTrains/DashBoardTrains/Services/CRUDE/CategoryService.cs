using Dapper;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Services.CRUDE
{
    public class CategoryService
    {
        public string _connectionString = "";   

        public CategoryService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("db")
            ?? throw new InvalidOperationException("Connection string 'db' not found.");
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
            return response.ToList();


        }


    }
}
