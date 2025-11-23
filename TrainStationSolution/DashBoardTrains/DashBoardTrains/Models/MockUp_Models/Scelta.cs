namespace DashBoardTrains.Models.MockUp_Models
{
    public abstract class Scelta
    {
        public int Id { get; set; }

        public abstract string TypeForm { get; }

        public abstract DateTime CreatedAt { get; }
    }

    public class Entrate : Scelta
    {
        public override string TypeForm => "Entrate";
        public double Amount { get; set; }

        public override DateTime CreatedAt => DateTime.Now;
    }
    public class Uscite : Scelta
    {
        public override string TypeForm => "Uscite";
        public double Amount { get; set; }

        public override DateTime CreatedAt => DateTime.Now;
    }
    public class Department : Scelta
    {
        public override string TypeForm => "Department";
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;

        public override DateTime CreatedAt => DateTime.Now;
    }




}
