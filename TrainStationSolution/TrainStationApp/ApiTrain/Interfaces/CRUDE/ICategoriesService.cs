using ApiTrain.Models;

namespace ApiTrain.Interfaces.CRUDE
{
    public interface ICategoriesService
    {
        Task<IResult> DeleteCategory(int id);
        Task<List<Category>> GetCategories();
        Task<IResult> PostCategories(Category category);
        Task<IResult> UpdateCategories(Category categories);
    }
}