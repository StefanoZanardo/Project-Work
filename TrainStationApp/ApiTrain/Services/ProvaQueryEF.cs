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
    }
}
