using System;
using PantryPal.Business.DTO;
using PantryPal.Data;
using Microsoft.EntityFrameworkCore;
using AutoMapper;

namespace PantryPal.Business.Services
{
    public class PantryItemService : IPantryItemService
    {
        private readonly PantryPalContext _context;
        private readonly IMapper _mapper;

        public PantryItemService(PantryPalContext context, IMapper mapper)
        {
            this._context = context;
            this._mapper = mapper;
        }

        public async Task AddPantryItem(string userId, CreatePantryItemDTO createPantryItemDTO)
        {
            _context.PantryItems.Add(new()
            {
                UserId = userId,
                Name = createPantryItemDTO.Name
            });

            await _context.SaveChangesAsync();
        }

        public async Task DeletePantryItem(string userId, int pantryItemId)
        {
            var pantryItem = _context.PantryItems.FirstOrDefault(x => x.UserId == userId && x.PantryItemId == pantryItemId);

            if (pantryItem != null)
            {
                _context.Remove(pantryItem);

                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<PantryItemDTO>> GetPantryItems(string userId)
        {
            var pantryItems = _context.PantryItems.Where(x => x.UserId == userId).ToList();

            return this._mapper.Map<List<PantryItemDTO>>(pantryItems);
        }
    }
}

