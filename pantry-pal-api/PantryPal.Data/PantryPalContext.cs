using Microsoft.EntityFrameworkCore;
using PantryPal.Data.Entities;

namespace PantryPal.Data
{
	public class PantryPalContext : DbContext
	{

		public PantryPalContext(DbContextOptions<PantryPalContext> contextOptions) : base(contextOptions)
		{
			
		}
		public DbSet<PantryItem> PantryItems { get; set; }

	}
}

