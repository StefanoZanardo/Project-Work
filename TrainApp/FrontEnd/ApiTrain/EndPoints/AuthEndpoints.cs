using ApiTrain;
using ApiTrain.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;

namespace ApiTrain.EndPoints
{
    public static class AuthEndpoints
    {
        public static IEndpointRouteBuilder MapAuthEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/auth")
                .WithTags("Authentication");

            group.MapPost("/login", LoginAsync);

            return app;
        }

        public record LoginRequest(string NomeUtente, string Password);

        public record LoginResponse(bool Success, string? Message, int? UserId);

        private static async Task<IResult> LoginAsync(
            [FromBody] LoginRequest request,
            DbContest dbContext)
        {
            if (string.IsNullOrWhiteSpace(request.NomeUtente) || string.IsNullOrWhiteSpace(request.Password))
            {
                return TypedResults.BadRequest(new LoginResponse(false, "Nome utente e password sono obbligatori", null));
            }

            try
            {
                // Cerca l'utente nel database
                var credential = await dbContext.Credentials
                    .FirstOrDefaultAsync(c => c.NomeUtente == request.NomeUtente);

                if (credential == null)
                {
                    return TypedResults.Unauthorized();
                }

                // Hasha la password fornita con il salt dal database
                string hashedPassword = HashPassword(request.Password, credential.Salt);

                // Confronta la password hashed con quella nel database
                if (hashedPassword == credential.Password)
                {
                    return TypedResults.Ok(new LoginResponse(true, "Login effettuato con successo", credential.Id));
                }
                else
                {
                    return TypedResults.Unauthorized();
                }
            }
            catch (Exception ex)
            {
                return TypedResults.Problem(
                    detail: ex.Message,
                    statusCode: 500);
            }
        }

        /// <summary>
        /// Hasha una password usando PBKDF2 con il salt fornito
        /// </summary>
        private static string HashPassword(string password, string salt)
        {
            // Converte il salt da stringa esadecimale a byte array
            byte[] saltBytes = Convert.FromHexString(salt);

            // Usa PBKDF2 per hashare la password
            using (var pbkdf2 = new Rfc2898DeriveBytes(
                Encoding.UTF8.GetBytes(password),
                saltBytes,
                10000, // 10,000 iterazioni (standard sicuro)
                HashAlgorithmName.SHA256))
            {
                byte[] hashBytes = pbkdf2.GetBytes(32); // 256 bit = 32 bytes
                return Convert.ToHexString(hashBytes);
            }
        }

        //admin
        //Admin!123
    }
}
