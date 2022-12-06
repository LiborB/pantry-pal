using System;
using Microsoft.Extensions.DependencyInjection;
using PantryPal.Data;

namespace PantryPal.Business
{
    public static class ServiceCollectionExtensions
    {
        public static void AddDb(this IServiceCollection services)
        {
            services.AddDbContext<PantryPalContext>();
        }
    }
}