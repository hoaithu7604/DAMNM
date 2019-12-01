﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine.Model
{
    public class Account
    {
        public Guid Id { get; set; }
        public string Username { get; set; }
        public string password { get; set; }
        public Guid EmployeeId { get; set; }
    }
}
