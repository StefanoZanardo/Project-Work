using ApiTrain.Interfaces.CRUDE;
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

        public async Task<T> AddAsync(T entity)
        {
            await _db.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
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
