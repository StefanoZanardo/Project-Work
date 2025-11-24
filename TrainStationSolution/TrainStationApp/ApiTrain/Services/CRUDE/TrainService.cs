using ApiTrain.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiTrain.Services.CRUDE
{
    public class TrainService
    {
        private readonly DbContest _dbContest;

        public TrainService(DbContest dbContest)
        {
            _dbContest = dbContest;
        }

        public async Task<List<Train>> GetTrains()
        {
            var result = await _dbContest.Trains.Include(b=>b.Category).ToListAsync();
            return result;
        }
    }
}
