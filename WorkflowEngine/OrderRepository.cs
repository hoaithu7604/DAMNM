using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WorkflowEngine.Model;

namespace WorkflowEngine
{
    public class OrderRepository: DataAccess.IOderRepository
    {
        private Order Get(Guid id, DataModelDataContext context)
        {
            var order = context.Orders.FirstOrDefault(c => c.Id == id);

            if (order == null) return null;
            return order;
        }
        public void ChangeState(Guid id, string nextState, string nextStateName)
        {
            using (var context = new DataModelDataContext())
            {
                var order = Get(id, context);
                if (order == null)
                    return;

                order.State = nextState;
                order.StateName = nextStateName;
                context.SubmitChanges();
            }
        }
        public Model.Order InsertOrUpdate(Model.Order order)
        {
            using (var context = new DataModelDataContext())
            {
                Order target = null;
                if (order.Id != Guid.Empty)
                {
                    target = context.Orders.SingleOrDefault(e => e.Id == order.Id);
                    if (target == null)
                        return null;
                    target.State = order.State;
                }
                else
                {
                    target = new Order
                    {
                        Id = Guid.NewGuid(),
                        State = "ManagerApproving",
                        StateName = "Manager approving",
                    };
                    context.Orders.InsertOnSubmit(target);
                }
                
                context.SubmitChanges();

                order.Id = target.Id;
                return order;
            }
        }
        public List<Model.Order> Get()
        {
            using (var context = new DataModelDataContext())
            {
                var result = context.Orders.Select(o => Mappings.Mapper.Map<Model.Order>(o)).ToList();
                foreach (var order in result)
                {
                    order.OwnerName = GetCustomerString(order.OwnerId, context);
                }
                return result;
            }
        }
        private string GetCustomerString(Guid idendityGuid, DataModelDataContext context)
        {
            var customers = context.Customers.Where(e => idendityGuid==e.Id).ToList();

            var sb = new StringBuilder();
            bool isFirst = true;
            foreach (var customer in customers)
            {
                if (!isFirst)
                    sb.Append(",");
                isFirst = false;

                sb.Append(customer.Name);
            }

            return sb.ToString();
        }
        private string GetEmployeeString(Guid idendityGuid, DataModelDataContext context)
        {
            var employees = context.Employees.Where(e => idendityGuid == e.Id).ToList();

            var sb = new StringBuilder();
            bool isFirst = true;
            foreach (var employee in employees)
            {
                if (!isFirst)
                    sb.Append(",");
                isFirst = false;

                sb.Append(employee.Name);
            }

            return sb.ToString();
        }

        public void UpdateOrderHistory(Guid id, string currentState, string nextState, string command, Guid? employeeId)
        {
            using (var context = new DataModelDataContext())
            {
               var historyItem = new OrderHistory
                {
                    Id = Guid.NewGuid(),           
                    DestinationState = nextState,
                    OrderId = id,
                    InitialState = currentState
                };
                context.OrderHistories.InsertOnSubmit(historyItem);
               
                historyItem.Command = command;
                historyItem.TransitionTime = DateTime.Now;
                historyItem.EmployeeId = employeeId;

                context.SubmitChanges();
            }
        }

        public List<Model.OrderHistory> GetOrderHistory(Guid id)
        {
            using (var context = new DataModelDataContext())
            {
                var result = context.OrderHistories.Where(h => h.OrderId == id).OrderBy(x=>x.Order).Select(h=>Mappings.Mapper.Map<Model.OrderHistory>(h)).ToList();
                foreach (var history in result)
                {
                    if (history.EmployeeId!=null)
                        history.EmployeeName = GetEmployeeString((Guid)history.EmployeeId, context);
                }
                return result;
            }
        }
    }
}
