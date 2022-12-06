using System;
using AutoMapper;
using PantryPal.Business.DTO;
using PantryPal.Data.Entities;

namespace PantryPal.Business
{
	public class AutomapperProfile : Profile
	{
		public AutomapperProfile()
		{
			CreateMap<PantryItem, PantryItemDTO>();
		}
	}
}

