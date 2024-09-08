using Microsoft.AspNetCore.Mvc;

namespace DevOps.TestApp.Controllers
{
    [ApiController]
    [Route("api/product")]
    public class ProductController : ControllerBase
    { 
        private readonly ILogger<ProductController> _logger;
        private readonly IEnumerable<Product> _products;

        public ProductController(ILogger<ProductController> logger)
        {
            _logger = logger;
            _products = this.GetTestProducts();
        }

        [HttpGet("list")]
        public IEnumerable<Product> GetProducts()
        {
            return this._products;
        }

        [HttpGet("{id}")]
        public string GetProductDetails(int id)
        {
            var product = this._products.FirstOrDefault(p => p.Id == id);

            if (product == null)
                return "Product not found!";

            return $"Product ID: {product.Id}, Name: {product.Name}, Price: ${product.Price:F2}";
        }

        private IEnumerable<Product> GetTestProducts()
        {
            var products = new List<Product>
            {
                new(1, "Laptop", 999.99m, "High-performance laptop with 16GB RAM and 512GB SSD", "Electronics"),
                new(2, "Smartphone", 599.99m, "Latest smartphone model with 12MP camera and 128GB storage", "Electronics"),
                new(3, "Headphones", 79.99m, "Noise-cancelling headphones with long battery life", "Electronics"),
                new(4, "T-Shirt", 19.99m, "Comfortable cotton t-shirt available in various colors", "Clothing"),
                new(5, "Book", 14.99m, "Bestselling novel by John Doe", "Books")
            };
            return products;
        }
    }
}
