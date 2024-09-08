namespace DevOps.TestApp
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }

        public Product(int id, string name, decimal price, string description, string category)
        {
            Id = id;
            Name = name;
            Price = price;
            Description = description;
            Category = category;
        }
    }
}
