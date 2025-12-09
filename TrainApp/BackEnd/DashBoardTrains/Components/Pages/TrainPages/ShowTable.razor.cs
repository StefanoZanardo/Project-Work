using DashBoardTrains.Models;
using DashBoardTrains.Services.CRUDE; // Assicurati che il namespace sia giusto
using Microsoft.AspNetCore.Components;
using System.Reflection;
using System.Text.Json.Serialization;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    
    public partial class ShowTable<T> : ComponentBase where T : class
    {
    
        [Inject]
        public ServicesGenerics<T> Service { get; set; } = default!;


        [Parameter]
        public string Title { get; set; } = "Tabella";

        [Parameter]
        public string ApiUrl { get; set; } = "";

  
        public List<T>? Items { get; set; }
        public List<PropertyInfo> Properties { get; set; } = new();

        protected override async Task OnInitializedAsync()
        {

            Properties = typeof(T).GetProperties()
                .Where(p => p.GetCustomAttribute<JsonIgnoreAttribute>() == null && !p.Name.Contains("Id", StringComparison.OrdinalIgnoreCase))
                .ToList();


            if (!string.IsNullOrEmpty(ApiUrl))
            {
                try
                {
                    Items = await Service.GetList(ApiUrl);
                }
                catch
                {
                    Items = new List<T>(); 
                }
            }
        }

        //private async Task Canc(int id)
        //{
        //    await Service.DeleteRow()
        //}
    }
}