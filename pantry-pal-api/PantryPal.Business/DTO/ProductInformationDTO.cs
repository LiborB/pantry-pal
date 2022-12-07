
using System.Text.Json.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace PantryPal.Business.DTO;

public class ProductDTO
{
    [JsonPropertyName("product_name")]
    public string ProductName { get; set; }
}

public class ProductInformationDTO
{
    public ProductDTO Product { get; set; }
    public int Status { get; set; }
}