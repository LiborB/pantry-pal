using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using PantryPal.Business.DTO;
using PantryPal.Business.Services;

namespace PantryPal.Core.Controllers
{
    [Route("api/[controller]")]
    public class PantryController : Controller
    {
        private readonly IPantryItemService _pantryItemService;

        PantryController(IPantryItemService pantryItemService)
        {
            this._pantryItemService = pantryItemService;
        }

        [HttpGet]
        public List<PantryItemDTO> Get()
        {
            return this._pantryItemService.GetPantryItems("");
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        [HttpPost]
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}

