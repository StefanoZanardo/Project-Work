
using ApiTrain;
using ApiTrain.DependecyInjection;
using ApiTrain.EndPoints.CRUDE;
using ApiTrain.EndPoints.Mock;
using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Models;
using ApiTrain.Services.CRUDE;
using ApiTrain.Services.Mock;
using Microsoft.AspNetCore.OpenApi;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Claims;
using System.Text;

var builder = WebApplication.CreateBuilder(args);



builder.Services.AddDbContext<DbContest>(options =>
options.UseSqlServer(builder.Configuration.GetConnectionString("db")));
// Add services to the container.
builder.Services.AddAuthorization();

builder.Services._DependecyInjection();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddCors(opt =>
{
    opt.AddPolicy("AllowAll", pol =>
    {
        pol.AllowAnyHeader().
            AllowAnyMethod()
            .AllowAnyOrigin()
            .AllowAnyHeader();
    });
}
);

builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();

app.MapOpenApi();

app.UseSwaggerUI();


app.UseHttpsRedirection();

app.UseAuthorization();

//app.MapEndPointProva();

app.appEndPoints();

app.Run();
       
    
