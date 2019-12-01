using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WorkflowEngine.Model;

namespace WorkflowEngine
{
    public class EmployeeRepository: DataAccess.IEmployeeRepository
    {
        public Model.Employee InsertOrUpdate(Model.Employee employee)
        {
            using (var context = new DataModelDataContext())
            {
                Employee target = null;
                if (employee.Id != Guid.Empty)
                {
                    target = context.Employees.SingleOrDefault(e => e.Id == employee.Id);
                    if (target == null)
                        return null;
                }
                else
                {
                    target = new Employee
                    {
                        Id = Guid.NewGuid(),
                    };
                    context.Employees.InsertOnSubmit(target);
                }
                target.Name = employee.Name;
                target.RoleId = employee.RoleId;
                context.SubmitChanges();

                employee.Id = target.Id;
                return employee;
            }
        }
    }
}
