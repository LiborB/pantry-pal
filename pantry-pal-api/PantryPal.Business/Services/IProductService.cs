using PantryPal.Business.DTO;

namespace PantryPal.Business.Services;

public interface IProductService
{
    Task<ProductInformationDTO?> GetProductInformation(string barcode);
}