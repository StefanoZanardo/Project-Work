
using ApiTrain;
using ApiTrain.EndPoints;
using ApiTrain.Services;
using Microsoft.AspNetCore.OpenApi;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Claims;
using System.Text;
   
var builder = WebApplication.CreateBuilder(args);



builder.Services.AddDbContext<DbContest>(options =>
options.UseNpgsql(builder.Configuration.GetConnectionString("db")));
// Add services to the container.
builder.Services.AddAuthorization();

builder.Services.AddScoped<ProvaQueryEF>();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();

app.MapOpenApi();

app.UseSwaggerUI(setup =>
{
    setup.SwaggerEndpoint("/openapi/v1.json", builder.Environment.ApplicationName);//In non si dovrebbe più usare swagger UI
});


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapEndPointProva();

app.Run();
       
    
