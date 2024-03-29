﻿using System;
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
        void ChangeState(Guid id, string nextState, string nextStateName);
        void UpdateOrderHistory(Guid id, string currentState, string nextState, string command, Guid? employeeId);
        List<Model.OrderHistory> GetOrderHistory(Guid id);
    }
}
