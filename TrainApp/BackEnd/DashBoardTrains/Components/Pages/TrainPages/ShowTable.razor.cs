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

        private PropertyInfo? _currentSortProperty;
        private bool _sortAscending = true;

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

        private void SortBy(PropertyInfo property)
        {
            if (Items == null || Items.Count == 0)
            {
                return;
            }

            if (_currentSortProperty == property)
            {
                // Toggle direction
                _sortAscending = !_sortAscending;
            }
            else
            {
                _currentSortProperty = property;
                _sortAscending = true;
            }

            Func<T, string?> keySelector = item =>
            {
                var value = property.GetValue(item);
                return value?.ToString();
            };

            if (_sortAscending)
            {
                Items = Items
                    .OrderBy(keySelector, StringComparer.OrdinalIgnoreCase)
                    .ToList();
            }
            else
            {
                Items = Items
                    .OrderByDescending(keySelector, StringComparer.OrdinalIgnoreCase)
                    .ToList();
            }
        }

        private string GetSortIconClass(PropertyInfo property)
        {
            if (_currentSortProperty != property)
            {
                return "bi bi-arrow-down-up text-muted";
            }

            return _sortAscending
                ? "bi bi-arrow-up-short"
                : "bi bi-arrow-down-short";
        }

        //private async Task Canc(int id)
        //{
        //    await Service.DeleteRow()
        //}
    }
}