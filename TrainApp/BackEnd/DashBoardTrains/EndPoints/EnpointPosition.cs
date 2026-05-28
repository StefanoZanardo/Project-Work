using DashBoardTrains.Models;
using DashBoardTrains.Services.CRUDE;
using System.Runtime.CompilerServices;

namespace DashBoardTrains.EndPoints
{
    public static class EnpointPosition
    {
        public static IEndpointRouteBuilder MapEndPoint(this IEndpointRouteBuilder endpoints)
        {
            var end = endpoints.MapPut("/TrainPosition", UpdatePosition);
            var end2 = endpoints.MapPut("/TrainPositionCanc", DeletePosition);


            return endpoints;
        }

        public static async Task<IResult> UpdatePosition(Train train, TrainListService trainListService)
        {
            await trainListService.UpdateRow(train);
            return Results.Ok();
        }

        public static async Task<IResult> DeletePosition(Train train, TrainListService trainListService)
        {
            await trainListService.DeleteRow(train);
            return Results.Ok();

        }
    }
}
