using System;
using Microsoft.EntityFrameworkCore;
using PantryPal.Data.Entities;

namespace PantryPal.Data
{
	public class PantryPalContext : DbContext
	{
		public DbSet<PantryItem> PantryItems { get; set; }

		protected override void OnConfiguring(DbContextOptionsBuilder builder)
		{
			builder.UseNpgsql(Environment.GetEnvironmentVariable("DB_CONNECTION_STRING"));
		}
	}
}

