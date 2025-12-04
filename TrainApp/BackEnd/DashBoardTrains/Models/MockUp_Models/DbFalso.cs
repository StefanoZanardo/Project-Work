using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.IdentityModel.Tokens;
using static DashBoardTrains.Models.MockUp_Models.Scelta;

namespace DashBoardTrains.Models.MockUp_Models
{
    public enum TipoScelta
    {
        Entrate,
        Uscite,
        Department
    }
    public class DbFalso
    {
        public static int IdUnique = 200;
        public List<Scelta> entrate;


        public List<Scelta> uscite;

        public List<Scelta> departments;



        public DbFalso()
        {
            entrate = new List<Scelta>
            {
                new Entrate { Id = 1, Amount = 5000 },
                new Entrate { Id = 2, Amount = 7000 },
                new Entrate { Id = 3, Amount = 6000 },
                new Entrate { Id = 4, Amount = 8000 }
            };

            uscite = new List<Scelta>
            {
                new Uscite { Id = 1, Amount = 3000 },
                new Uscite { Id = 2, Amount = 4000 },
                new Uscite { Id = 3, Amount = 3500 },
                new Uscite { Id = 4, Amount = 4500 }
            };

            departments = new List<Scelta>
            {
                new Department { Id = 1, Name = "Sales", Description = "Handles sales operations" },
                new Department { Id = 2, Name = "Marketing", Description = "Responsible for marketing strategies" }
            };
        }

        public async Task<IEnumerable<object>> GetScelteByTipoAsync(TipoScelta tipo)
        {
            var result = tipo switch
            {
                TipoScelta.Entrate => entrate,
                TipoScelta.Uscite => uscite,
                TipoScelta.Department => departments,
                _ => throw new ArgumentException("Tipo di scelta non valido")
            };
            return await Task.FromResult(result);
        }

        public async Task AddSceltaAsync(Scelta scelta)
        {
            try
            {
                scelta.Id = ++IdUnique;
                switch (scelta)
                {
                    case Entrate e:
                        NotValidValue(e.Amount);
                        entrate.Add(e);
                        break;
                    case Uscite u:
                        if (u.Amount < 0)
                            NotValidValue(u.Amount);
                        uscite.Add(u);
                        break;
                    case Department d:
                        NotValidValue(d.Name);
                        NotValidValue(d.Description);
                        departments.Add(d);
                        break;
                    default:
                        throw new ArgumentException("Tipo di scelta non valido");
                }
            }
            catch (ArgumentException ex)
            {
                throw ;
            }
            await Task.CompletedTask;
            
        }
        public Scelta CreaNuovaScelta(string tipo) => tipo switch
        {
            "Entrate" => new Entrate(),
            "Uscite" => new Uscite(),
            "Department" => new Department(),
            _ => new Entrate()
        };

        public ArgumentException NotValidValue(object valore)
        {
            if (double.TryParse(valore.ToString(), out double val ) && val <= 0)
            {
                throw new ArgumentException("Il valore non può essere negativo.");
            }
            else if(valore.ToString().IsNullOrEmpty())
            {
                throw new ArgumentException("Il valore non può essere vuoto.");
            }
            else
            {
                return null;
            }
        }

    }
}
