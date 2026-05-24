using ApiTrain.Interfaces.CRUDE;
using ApiTrain.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiTrain.Services.CRUDE
{
    public class Repository<T> : IRepository<T> where T : class
    {
        private readonly DbContest _context;
        private readonly DbSet<T> _db;

        public Repository(DbContest context)
        {
            _context = context;
            _db = context.Set<T>();
        }

        public async Task<IEnumerable<T>> GetAllAsync() => await _db.ToListAsync();
        public async Task<T?> GetAsync(int id) => await _db.FindAsync(id);

        public async Task<int> AddAsync(T entity)
        {
            try
            {

                if (entity is Train)
                {
                    var value = entity as Train;
                    await _context.Trains.AddAsync(value);
                    var result = await _context.SaveChangesAsync();
                }
                else
                {

                    await _db.AddAsync(entity);
                    var result = await _context.SaveChangesAsync();
                }
                return 0;



            }
            catch (Exception ex) 
            {
                Console.Write(ex.Message);
                return default!;
            }
         }

        public async Task UpdateAsync(T entity)
        {
            _db.Update(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _db.FindAsync(id);
            if (entity != null)
            {
                _db.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }

}
