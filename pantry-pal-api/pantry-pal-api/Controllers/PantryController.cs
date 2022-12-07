using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using PantryPal.Business.DTO;
using PantryPal.Business.Services;

namespace PantryPal.Core.Controllers;

[Route("api/pantry")]
public class PantryController : Controller
{
    private readonly IPantryItemService _pantryItemService;

    public PantryController(IPantryItemService pantryItemService)
    {
        this._pantryItemService = pantryItemService;
    }

    [HttpGet]
    public async Task<List<PantryItemDTO>> GetAll()
    {
        return await this._pantryItemService.GetPantryItems("");
    }
}