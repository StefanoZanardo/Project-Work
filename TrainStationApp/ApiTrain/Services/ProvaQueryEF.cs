using ApiTrain.Models;
using ApiTrain.Models.NewFolder;
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
            var result = await contestoDB.category.ToListAsync();
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
        public async Task<IResult> LeftJointQueryProva()
        {
            var response = await contestoDB.trains.Include(a=>a.category)
                .Select(a=> new ProvaDTO
                {
                    TrainId = a.trainid,
                    Destination = a.destination,
                    CategoryName = a.category.traincategory

                }).FirstAsync();

            return TypedResults.Ok(response);
        }

        public async Task<IResult> QueryCompose()
        {
            var response = await contestoDB.crossroads.Include(a=>a.SegmentRail1).Include(a=>a.SegmentRail2).Select
                (a=> new CrossRoadTraitDTO
                {
                    crossroadid = a.crossroadid,
                    changelane = a.changelane,
                    isoccupied = a.isoccupied,
                    segmenttrait1 = a.segmenttrait1,
                    segmenttrait2 = a.segmenttrait2,
                    rail = a.SegmentRail1 ,
                    rail2 = a.SegmentRail2 
                  
                }

                ).ToListAsync();

            return TypedResults.Ok(response);
        }


    }
}
