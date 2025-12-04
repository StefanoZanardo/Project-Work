using DashBoardTrains.Components;
using DashBoardTrains.Components.Pages;
using DashBoardTrains.Models;
using DashBoardTrains.Models.MockUp_Models;
using DashBoardTrains.Services.CRUDE;
using Microsoft.Extensions.DependencyInjection;

namespace DashBoardTrains
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddSingleton<DbFalso>();

            builder.Services.AddHttpClient<CategoryService>(opt =>
            {
                opt.BaseAddress = new Uri("https://alexi-its.azurewebsites.net");
            });

            builder.Services.AddHttpClient("GenericHttpClient", opt => 
            {
                opt.BaseAddress = new Uri("https://alexi-its.azurewebsites.net");

            }
            );
            builder.Services.AddScoped(typeof(ServicesGenerics<>));

            builder.Services.AddScoped<ProductService>();   

            // Add services to the container.
            builder.Services.AddRazorComponents()
                .AddInteractiveServerComponents();

            
            var app = builder.Build();
                
            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseAntiforgery();

            app.MapStaticAssets();
            app.MapRazorComponents<App>()
                .AddInteractiveServerRenderMode();

            app.Run();
        }
    }
}
