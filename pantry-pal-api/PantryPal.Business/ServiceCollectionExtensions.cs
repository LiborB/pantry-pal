using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using PantryPal.Data;

namespace PantryPal.Business
{
    public static class ServiceCollectionExtensions
    {
        public static void AddDb(this IServiceCollection services, string connectionString)
        {
            services.AddDbContext<PantryPalContext>(x => x.UseNpgsql(connectionString));
        }
    }
}