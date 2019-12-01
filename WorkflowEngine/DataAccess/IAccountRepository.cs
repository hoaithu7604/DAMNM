using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine.DataAccess
{
    public interface IAccountRepository
    {
        Guid Login(string username, string passowrd);
    }
}
