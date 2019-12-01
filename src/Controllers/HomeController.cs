using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WorkflowEngine.Model;
using WorkflowEngine.DataAccess;

namespace DAMNM.Controllers
{
    public class HomeController : Controller
    {
        private readonly IEmployeeRepository _employeeRepository;

        public HomeController()
        {
            _employeeRepository = new WorkflowEngine.EmployeeRepository();
        }
        public ActionResult Index()
        {
            var temp = new Employee()
            {
                Name = "Testing",
            };
            _employeeRepository.InsertOrUpdate(temp);

            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}