using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Services.CRUDE;
using ApiTrain.Services.Mock;

namespace ApiTrain.DependecyInjection
{
    public static class dependecyInjection
    {

        public static void _DependecyInjection(this IServiceCollection services)
        {

            services.AddScoped<ProvaQueryEF>();
            services.AddScoped<ICategoriesService, CategoriesService>();
        }
    }
}
