using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine.Model
{
    public class Order
    {
        public Guid Id { get; set; }
        public string State { get; set; }
        public string StateName { get; set; }
        public Guid OwnerId { get; set; }
        public string OwnerName { get; set; }
    }
}
