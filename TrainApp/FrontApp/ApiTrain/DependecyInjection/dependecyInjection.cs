    using ApiTrain.EndPoints.CRUDE;
using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Models;
using ApiTrain.Services.CRUDE;
using ApiTrain.Services.Mock;

namespace ApiTrain.DependecyInjection
{
    public static class dependecyInjection
    {

        public static void _DependecyInjection(this IServiceCollection services)
        {

            services.AddScoped<ProvaQueryEF>();
            services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
        }

        public static void appEndPoints(this WebApplication app) 
        {
            
            app.MapGenericEndPointsCrude<Category>("/category");
            app.MapGenericEndPointsCrude<Train>("/train");
            app.MapGenericEndPointsCrude<Rail>("/rail");
            app.MapGenericEndPointsCrude<SegmentRail>("/segmentrail");
            app.MapGenericEndPointsCrude<Crossroad>("/crossroad");
            app.MapGenericEndPointsCrude<Stoplight>("/stoplight");
            app.MapGenericEndPointsCrude<Wagon>("/wagon");
        }
    }
}
