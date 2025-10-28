using ApiTrain.Services;

namespace ApiTrain.EndPoints
{
    public static class EndPointTest
    {
        public static IEndpointRouteBuilder MapEndPointProva(this IEndpointRouteBuilder route)
        {
            var endpoint = route.MapGroup("Prova/");

            endpoint.MapGet("OttieniEntrate", GetProvaAsync);

            return route;
        }

        public static async Task<IResult> GetProvaAsync(ProvaQueryEF service)
        {
            var response = await service.GetTrainsDB();

            if (response == null)
            {
               return TypedResults.NotFound(response);
            }
            return TypedResults.Ok(response);   
        }

    }
}
