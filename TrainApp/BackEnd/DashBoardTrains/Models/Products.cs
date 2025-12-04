using System.ComponentModel.DataAnnotations;

namespace DashBoardTrains.Models
{
    public class Products
    {
        public int Id { get; set; }
        [Required]
        [MaxLength(50)]
        public string Code { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(200)]
        public string? Description { get; set; }

        [Required]
        public decimal Price { get; set; }

        public int categoryId { get; set; }
        
        public Category Category { get; set; } 


    }

    public class  filejson
    {
        public string nome { get; set; }
    }
}
