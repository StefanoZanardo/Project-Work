using ApiTrain.Models;
using ApiTrain.Models.NewFolder;
using Microsoft.EntityFrameworkCore;

namespace ApiTrain.Services.Mock
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
            var result = await contestoDB.Categories.ToListAsync();
            return TypedResults.Ok(result);
        } 

        public async Task<IResult> PostRailProva(Rail rail)
        {
            await contestoDB.Rails.AddAsync(rail);

            contestoDB.SaveChanges();

            return TypedResults.Ok(rail);
        }

        public async Task<IResult> DeleteRailProva(int id)
        {
            Rail rail = new Rail();
            await contestoDB.Rails.Where(a=>a.RailId==id).ExecuteDeleteAsync();

            return TypedResults.Ok(rail);
        }
        public async Task<IResult> LeftJointQueryProva()
        {
            var response = await contestoDB.Trains.Include(a=>a.Category)
                .Select(a=> new ProvaDTO
                {
                    TrainId = a.TrainId,
                    Destination = a.Destination,
                    CategoryName = a.Category.TrainCategory

                }).FirstAsync();

            return TypedResults.Ok(response);
        }

        public async Task<IResult> QueryCompose()
        {
            var response = await contestoDB.Crossroads.Include(a=>a.SegmentRail1).Include(a=>a.SegmentRail2).Select
                (a=> new CrossRoadTraitDTO
                {
                    CrossroadId = a.CrossroadId,
                    ChangeLane = a.ChangeLane,
                    IsOccupied = a.IsOccupied,
                    SegmentTrait1 = a.SegmentTrait1,
                    SegmentTrait2 = a.SegmentTrait2,
                    rail = a.SegmentRail1 ,
                    rail2 = a.SegmentRail2 
                  
                }

                ).ToListAsync();

            return TypedResults.Ok(response);
        }


    }
}
