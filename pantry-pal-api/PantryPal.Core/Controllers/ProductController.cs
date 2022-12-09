using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PantryPal.Business.DTO;
using PantryPal.Business.Services;

namespace PantryPal.Core.Controllers;

[Route("api/product")]
public class ProductController : Controller
{
    private readonly IProductService _productService;

    public ProductController(IProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public async Task<ActionResult<ProductInformationDTO>> Get([FromQuery] string barcode)
    {
        var productInfo = await _productService.GetProductInformation(barcode);

        if (productInfo == null)
        {
            return new NotFoundResult();
        }

        return productInfo;
    }
}