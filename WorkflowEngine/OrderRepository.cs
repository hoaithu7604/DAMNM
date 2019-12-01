using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine
{
    public class OrderRepository: DataAccess.IOderRepository
    {
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
    }
}
