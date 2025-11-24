using DashBoardTrains.Models;
using System.Data.SqlTypes;
using DashBoardTrains.Infrastracture;
using System.Text.Json.Serialization;
using System.Runtime.Serialization.Json;
using System.Text.Json;
using DashBoardTrains.Services;
using Microsoft.VisualBasic;

namespace DashBoardTrains.Components.Pages.TrainPages
{
    public partial class CategoryTrains
    {
        private Category categoria { get; set; } = NewImplementation.NewClass<Category>();

        public List<Category> categories {  get; set; } = new List<Category>();

        public string errorMessage { get; set; } = string.Empty;

        protected override async Task OnInitializedAsync()
        {
            categories = await categoryService.GetAllCategory();

            StateHasChanged();

        }
        protected override async Task OnParametersSetAsync()
        {
            await GetAllCategory();
        }


        public async Task GetAllCategory()
        {
            categories = await categoryService.GetAllCategory();
            StateHasChanged();
        }

        public async Task InserisciCategoria()
        {
            try
            {
                await categoryService.PostCategoryAsync(categoria);

                await GetAllCategory();

                StateHasChanged();
            }
            catch (Exception ex) 
            {
                errorMessage = ex.Message;
            }
        }

        public async Task EliminaCategoria(int id)
        {
            try
            {
                await categoryService.DeleteCategoryAsync(id);

                await GetAllCategory();

                StateHasChanged();
            }
            catch (Exception ex) 
            {
                errorMessage = ex.Message;
            }
        }

    }
}
