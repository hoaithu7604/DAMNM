﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WorkflowEngine.Model;
using WorkflowEngine.DataAccess;
using WorkflowEngine;
using DAMNM.Helpers;

namespace DAMNM.Controllers
{
    public class HomeController : Controller
    {
        private readonly IEmployeeRepository _employeeRepository;
        private readonly IOderRepository _orderRepository;
        public HomeController()
        {
            _employeeRepository = new WorkflowEngine.EmployeeRepository();
            _orderRepository = new WorkflowEngine.OrderRepository();
        }
        public ActionResult Index()
        {
            if (DAMNM.Helpers.CurrentUserSettings.GetCurrentUser() == Guid.Empty)
                return Redirect("~/Login");
            var list = _orderRepository.Get();
            foreach(var item in list)
            {
                CreateWorkflowIfNotExists(item.Id);      
            }
            var result = list.Select(x => new Model.OrderModel()
            {
                Id = x.Id,
                State = x.State,
                OwnerName = x.OwnerName,
                OwnerId = x.OwnerId,
                Commands = GetCommands(x.Id),
            }).Where(x=>x.Commands.Length>0).ToList();

            return View(result);
        }
        public ActionResult ExecuteCommand(string Id,string commandName)
        {
            ExecuteCommand(Guid.Parse(Id), commandName);
            return Redirect("/Home/Index");
        }
        #region Workflow

        private Model.OrderCommandModel[] GetCommands(Guid id)
        {
            var result = new List<Model.OrderCommandModel>();
            var commands = WorkflowInit.Runtime.GetAvailableCommands(id, CurrentUserSettings.GetCurrentUser().ToString());
            foreach (var workflowCommand in commands)
            {
                if (result.Count(c => c.key == workflowCommand.CommandName) == 0)
                    result.Add(new Model.OrderCommandModel() { key = workflowCommand.CommandName, value = workflowCommand.LocalizedName, Classifier = workflowCommand.Classifier });
            }
            return result.ToArray();
        }

        private void ExecuteCommand(Guid id, string commandName)
        {
            var currentUser = CurrentUserSettings.GetCurrentUser().ToString();   

            var commands = WorkflowInit.Runtime.GetAvailableCommands(id, currentUser);

            var command =
                commands.FirstOrDefault(
                    c => c.CommandName.Equals(commandName, StringComparison.CurrentCultureIgnoreCase));

            if (command == null)
                return;

            WorkflowInit.Runtime.ExecuteCommand(command, currentUser, currentUser);
        }

        private void CreateWorkflowIfNotExists(Guid id)
        {
            if (WorkflowInit.Runtime.IsProcessExists(id))
                return;

            WorkflowInit.Runtime.CreateInstance("SimpleWF", id);
        }
        #endregion Workflow
    }
}