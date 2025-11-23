using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Models;
using ApiTrain.Services.Mock;
using Microsoft.AspNetCore.Mvc;

namespace ApiTrain.EndPoints.CRUDE
{
    public static  class CategoriesEndPoint
    {

        public static IEndpointRouteBuilder MapEndCategories(this IEndpointRouteBuilder route)
        {
            var endpoint = route.MapGroup("Category/");

            endpoint.MapGet("GetAll", GetCategoriesAsync);
            endpoint.MapPost("Post/", PostCategoryEndpoint);
            endpoint.MapDelete("Delete/{id:int}", DeleteCategoryEndPoint);
            endpoint.MapPut("Update", UpdateCategoryAsync);
            

            return route;
        }



        public static async Task<List<Category>> GetCategoriesAsync(ICategoriesService service)
        {
            var response = await service.GetCategories();

            if (response == null)
            {
                return new List<Category>();
            }
            return response;
        }

        public static async Task<IResult> PostCategoryEndpoint(ICategoriesService service, [FromBody] Category category)
        {
            var response = await service.PostCategories(category);

            return TypedResults.Ok(response);
        }

        public static async Task<IResult> DeleteCategoryEndPoint(ICategoriesService service, int id)
        {
            try
            {
                var result = await service.DeleteCategory(id);
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

        private static async Task<IResult> UpdateCategoryAsync(HttpContext context, ICategoriesService service, [FromBody] Category category)
        {
            Console.WriteLine(context);

            var response = await service.UpdateCategories(category);

            return TypedResults.Ok(response);
        }

    

    }
}

