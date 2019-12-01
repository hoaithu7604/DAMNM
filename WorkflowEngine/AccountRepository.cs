using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine
{
    public class AccountRepository : DataAccess.IAccountRepository
    {
        public Guid Login(string username, string password)
        {
            using (var context = new DataModelDataContext())
            {
                var account = context.Accounts.FirstOrDefault(a => a.Username == username && a.Password == password);
                if (account != null)
                    return account.EmployeeId;
            }
            return Guid.Empty;
        }
    }
}
