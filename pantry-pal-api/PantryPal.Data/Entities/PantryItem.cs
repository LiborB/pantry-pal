using System;
using Microsoft.EntityFrameworkCore;

namespace PantryPal.Data.Entities
{
	public class PantryItem
	{
		public int PantryItemId { get; set; }
		public string UserId { get; set; }
		public string Name { get; set; }
	}
}

