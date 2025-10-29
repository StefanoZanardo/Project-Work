using ApiTrain.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiTrain.Services
{
    public class ProvaQueryEF
    {
        public DbContest contestoDB;
        public ProvaQueryEF(DbContest contestoDB)
        {
            this.contestoDB = contestoDB;
        }

        public async Task<IResult> GetTrainsDB()
        {
            var result = await contestoDB.rail.ToListAsync();
            return TypedResults.Ok(result);
        } 

        public async Task<IResult> PostRailProva(Rail rail)
        {
            await contestoDB.rail.AddAsync(rail);

            contestoDB.SaveChanges();

            return TypedResults.Ok(rail);
        }

        public async Task<IResult> DeleteRailProva(int id)
        {
            Rail rail = new Rail();
            await contestoDB.rail.Where(a=>a.railid==id).ExecuteDeleteAsync();

            return TypedResults.Ok(rail);
        }
    }
}
