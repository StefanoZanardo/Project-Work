using Dapper;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;

namespace DashBoardTrains.Services.CRUDE
{
    public class CategoryService
    {
        public HttpClient _http;   

        public CategoryService(HttpClient httpClient)
        {
            _http = httpClient;
        }
        public async Task<List<Category>> GetAllCategory()
        {
            var result = await _http.GetFromJsonAsync<List<Category>>("/Category/GetAll");
            if (result == null) 
            {
                return new List<Category>();
            }
            return result;
        }


    }
}
