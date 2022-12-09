using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PantryPal.Business.DTO;
using PantryPal.Business.Services;
using PantryPal.Core.Models;

namespace PantryPal.Core.Controllers;

[Route("api/pantry")]
public class PantryController : Controller
{
    private readonly IPantryItemService _pantryItemService;

    public PantryController(IPantryItemService pantryItemService)
    {
        _pantryItemService = pantryItemService;
    }

    [HttpGet]
    public async Task<List<PantryItemDTO>> GetAll()
    {
        return await _pantryItemService.GetPantryItems("");
    }

    [HttpPost]
    public async Task Add([FromBody] CreatePantryItemModel model)
    {
        await _pantryItemService.CreatePantryItem(User.FindFirstValue(ClaimTypes.NameIdentifier), new ()
        {
            Name = model.Name
        });
    }
}