using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WorkflowEngine.DataAccess;
using DAMNM.Model;

namespace DAMNM.Controllers
{
    public class LoginController : Controller
    {
        private readonly IAccountRepository _accountRepository;

        public LoginController()
        {
            _accountRepository = new WorkflowEngine.AccountRepository();
        }

        // GET: Login
        public ActionResult Index()
        {
            return View();
        }
        
        [HttpPost]
        public ActionResult Login(LoginModel login)
        {
            var Id = _accountRepository.Login(login.Username, login.Password);
            if (Id != Guid.Empty)
            {
                DAMNM.Helpers.CurrentUserSettings.SetUserSection(Id);
                return Redirect("~/Home");
            }
            else
                return View("Index");
        }

        
    }
}