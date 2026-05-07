using DashBoardTrains.Components;
using DashBoardTrains.Components.Pages;
using DashBoardTrains.Models;
using DashBoardTrains.Models.MockUp_Models;
using DashBoardTrains.Services;
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
            builder.Services.AddHttpClient<CategoryService>(opt => { opt.BaseAddress = new Uri("http://localhost:5136");  });
            builder.Services.AddHttpClient("GenericHttpClient", opt => { opt.BaseAddress = new Uri("http://lo   calhost:5136"); });
            builder.Services.AddScoped(typeof(ServicesGenerics<>));
            builder.Services.AddScoped<ProductService>();
            builder.Services.AddScoped<AuthService>();
            builder.Services.AddRazorComponents().AddInteractiveServerComponents();

            var app = builder.Build();

            app.Use(async (context, next) =>
            {
                context.Response.Headers.Append("Cross-Origin-Opener-Policy", "same-origin");
                context.Response.Headers.Append("Cross-Origin-Embedder-Policy", "require-corp");
                await next();
            });

            var provider = new Microsoft.AspNetCore.StaticFiles.FileExtensionContentTypeProvider();
            provider.Mappings[".pck"] = "application/octet-stream";
            provider.Mappings[".wasm"] = "application/wasm";


            app.UseStaticFiles(new StaticFileOptions
            {
                ContentTypeProvider = provider
            });



            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseAntiforgery();

           
            app.MapRazorComponents<App>()
                .AddInteractiveServerRenderMode();

            app.Run();
        }
    }
}
