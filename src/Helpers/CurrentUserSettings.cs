using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DAMNM.Helpers
{
    public class CurrentUserSettings
    {
        public static Guid GetCurrentUser()
        {
            Guid res = Guid.Empty;
            if (HttpContext.Current.Session["CurrentEmployee"] != null)
            {
                Guid.TryParse(HttpContext.Current.Session["CurrentEmployee"].ToString(), out res);
            }
            return res;
        }

        public static void SetUserSection(Guid userId)
        {
            HttpContext.Current.Session.Add("CurrentEmployee", userId.ToString());
        }
    }
}