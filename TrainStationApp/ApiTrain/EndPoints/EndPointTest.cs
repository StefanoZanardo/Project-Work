using ApiTrain.Models;
using ApiTrain.Services;
using Microsoft.AspNetCore.Mvc;

namespace ApiTrain.EndPoints
{
    public static class EndPointTest
    {
        public static IEndpointRouteBuilder MapEndPointProva(this IEndpointRouteBuilder route)
        {
            var endpoint = route.MapGroup("Prova/");

            endpoint.MapGet("OttieniEntrate", GetProvaAsync);
            endpoint.MapPost("inserisci/",PostProvaEndpoint);
            endpoint.MapDelete("cancella/{id:int}", DeleteProvaEndPoint);

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

        public static async Task<IResult> PostProvaEndpoint(ProvaQueryEF service, [FromBody] Rail rail)
        {
            var response = await service.PostRailProva(rail);

            return TypedResults.Ok(response);
        }

        public static async Task<IResult> DeleteProvaEndPoint(ProvaQueryEF service, int id)
        {
            try
            {
                var result = await service.DeleteRailProva(id);
                if (result == null)
                {
                    return TypedResults.NotFound(result);
                }
                return TypedResults.Ok(result);
            }
            catch (Exception ex) 
            {

                return TypedResults.InternalServerError(ex);
            }
        }

    }
}
