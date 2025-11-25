using ApiTrain.Interfaces.CRUDE;
using System.Runtime.CompilerServices;

namespace ApiTrain.EndPoints.CRUDE
{
    public static class CrudeEndPointGenerics
    {
        public static void MapGenericEndPointsCrude<T>(this IEndpointRouteBuilder app, string route) where T : class
        {
            var group = app.MapGroup(route)
                       .WithTags(typeof(T).Name);

            group.MapGet("/", async (IRepository<T> repo) =>
                await repo.GetAllAsync());

            group.MapGet("/{id}", async (int id, IRepository<T> repo) =>
                await repo.GetAsync(id));

            group.MapPost("/", async (T entity, IRepository<T> repo) =>
                await repo.AddAsync(entity));

            group.MapPut("/", async (T entity, IRepository<T> repo) =>
            {
                await repo.UpdateAsync(entity);
                return Results.Ok(entity);
            });

            group.MapDelete("/{id}", async (int id, IRepository<T> repo) =>
            {
                await repo.DeleteAsync(id);
                return Results.Ok();
            });
        }
    }
}
