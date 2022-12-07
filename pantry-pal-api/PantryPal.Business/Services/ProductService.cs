using System.Net.Http.Json;
using System.Text.Json;
using Newtonsoft.Json.Serialization;
using PantryPal.Business.DTO;

namespace PantryPal.Business.Services;

public class ProductService : IProductService
{
    private readonly HttpClient _httpClient;

    public ProductService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }
    
    public async Task<ProductInformationDTO?> GetProductInformation(string barcode)
    {
        var response = await _httpClient.GetAsync($"https://world.openfoodfacts.org/api/v0/product/{barcode}");

        if (!response.IsSuccessStatusCode)
        {
            throw new Exception($"Failed to parse response for barcode {barcode}");
        }

        var body = await response.Content.ReadFromJsonAsync<ProductInformationDTO>();

        if (body == null || body.Status == 0)
        {
            return null;
        }

        return body;
    }
}