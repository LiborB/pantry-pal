using System;
using PantryPal.Business.DTO;

namespace PantryPal.Business.Services
{
	public interface IPantryItemService
	{
		Task<List<PantryItemDTO>> GetPantryItems(string userId);
		Task AddPantryItem(string userId, CreatePantryItemDTO createPantryItemDTO);
		Task DeletePantryItem(string userId, int pantryItemId);
	}
}

