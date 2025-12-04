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
    }
}
