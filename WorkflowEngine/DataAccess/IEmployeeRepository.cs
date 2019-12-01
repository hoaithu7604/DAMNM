using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WorkflowEngine.Model;
namespace WorkflowEngine.DataAccess
{
    public interface IEmployeeRepository
    {
        Model.Employee InsertOrUpdate(Model.Employee employee);

        bool CheckRole(string Id, string role);

    }
}
