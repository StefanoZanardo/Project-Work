using System.Net.Http.Json;

namespace DashBoardTrains.Services
{
    public class AuthService
    {
        private readonly HttpClient _httpClient;

        public AuthService(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient("GenericHttpClient");
        }

        public record LoginRequest(string NomeUtente, string Password);

        public record LoginResponse(bool Success, string? Message, int? UserId);

        public async Task<LoginResponse?> LoginAsync(string nomeUtente, string password)
        {
            try
            {
                var request = new LoginRequest(nomeUtente, password);
                var response = await _httpClient.PostAsJsonAsync("/auth/login", request);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<LoginResponse>();
                    return result;
                }
                else if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                {
                    return new LoginResponse(false, "Credenziali non valide", null);
                }
                else
                {
                    var errorMessage = await response.Content.ReadAsStringAsync();
                    return new LoginResponse(false, $"Errore: {errorMessage}", null);
                }
            }
            catch (Exception ex)
            {
                return new LoginResponse(false, $"Errore di connessione: {ex.Message}", null);
            }
        }
    }
}
