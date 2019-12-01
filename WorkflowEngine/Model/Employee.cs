﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkflowEngine.Model
{
    public class Employee
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public Guid? RoleId { get; set; }
    }
}
