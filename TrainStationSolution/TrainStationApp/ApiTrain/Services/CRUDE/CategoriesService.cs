using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using System.Runtime.InteropServices;

namespace ApiTrain.Services.CRUDE
{
    public class CategoriesService : ICategoriesService
    {
        public DbContest _dbContest;

        public CategoriesService(DbContest dbContest)
        {
            _dbContest = dbContest;
        }

        public async Task<List<Category>> GetCategories()
        {
            var result = await _dbContest.Categories.ToListAsync();
            return result;
        }


        public async Task<IResult> PostCategories(Category category)
        {
            await _dbContest.Categories.AddAsync(category);
            var result = await _dbContest.SaveChangesAsync();
            if (result > 0)
            {
                return TypedResults.NoContent();
            }
            return TypedResults.Ok(result);
        }
        public async Task<IResult> UpdateCategories(Category categories)
        {
            var result = await _dbContest.Categories.Where(id => categories.CategoryId == id.CategoryId)
                        .ExecuteUpdateAsync(category =>
                        category.SetProperty(a => a.PriorityValue, categories.PriorityValue)
                        .SetProperty(a => a.TrainCategory, categories.TrainCategory));
            if (result > 0)
            {
                return TypedResults.NoContent();
            }
            return TypedResults.Ok(result);
        }

        public async Task<IResult> DeleteCategory(int id)
        {
            await _dbContest.Categories.Where(a => a.CategoryId == id).ExecuteDeleteAsync();
            var result = await _dbContest.SaveChangesAsync();
            if (result > 0)
            {
                return TypedResults.NoContent();
            }
            return TypedResults.Ok(result);
        }

    }
}
