using Dapper;
using DashBoardTrains.Models;
using Microsoft.Data.SqlClient;
using System.Net;
using System.Net.Http.Json;

namespace DashBoardTrains.Services.CRUDE
{
    public class CategoryService
    {
        private readonly HttpClient _http;   

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

        public async Task PostCategoryAsync(Category category)
        {
            using var result = await _http.PostAsJsonAsync("/Category/Post/", category);

            if (result.StatusCode == HttpStatusCode.NotFound)
            {
                throw new Exception("Non si è riuscito a inserire nel db");

            }
        }

        public async Task DeleteCategoryAsync(int id) 
        {
            using var result = await _http.DeleteAsync($"/Category/Delete/{id}");
            if (result.StatusCode == HttpStatusCode.NotFound)
            {
                throw new Exception("Non si è riuscito a cancellare ricontrolla");
            }

        }


    }
}
