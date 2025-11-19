namespace DashBoardTrains.Models
{
    public class    Category
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public ICollection<Products> Products { get; set; }
    }
}
