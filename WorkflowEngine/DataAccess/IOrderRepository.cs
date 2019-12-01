using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine.DataAccess
{
    public interface IOderRepository
    {
        Model.Order InsertOrUpdate(Model.Order order);
        List<Model.Order> Get();
    }
}
