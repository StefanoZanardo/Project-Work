using DashBoardTrains.Models;

namespace DashBoardTrains.Services.CRUDE
{
    public class ServicesGenerics<T> where T : class
    {
        private readonly HttpClient _httpClient;




        public ServicesGenerics(IHttpClientFactory httpClient)
        {
            _httpClient = httpClient.CreateClient("GenericHttpClient");
        }

        public async Task<List<T>> GetList(string connection)
        {
            var response = await _httpClient.GetFromJsonAsync<List<T>>(connection);

            if (response != null)
            {
                return response;
            }
            else
            {
                throw new Exception("Lista vuota");
            }
        }

        public async Task PostAsync(string connection, T insert)
        {
            var response = await _httpClient.PostAsJsonAsync<T>(connection, insert);
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception("Non è riuscito a inserire nel db");
            }
        }

        public async Task DeleteRow(int id, string connection)
        {
            try
            {
                var response = await _httpClient.DeleteAsync($"{connection}/{id}");
                if (response == null)
                {
                    throw new Exception("Non è riuscito a cancellare la riga");
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


    
    }
}
