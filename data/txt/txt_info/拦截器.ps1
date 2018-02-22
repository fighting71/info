direction:拦截器

author:yj

since:2017-12-10 17:51:32

	使用拦截器：
		a.自定义拦截器通过特性进行使用
		b.Controller具有拦截器的功能，只需要重新父类的方法即可实现

		/// <summary>
		/// Action拦截器
		/// </summary>
		public class ActionFilterAttribute : System.Web.Mvc.FilterAttribute, System.Web.Mvc.IActionFilter
		{
			#region 属性
			/// <summary>
			/// 记录是否登陆
			/// </summary>
			public bool IsLogin { get; set; }
			#endregion
	
			#region 执行action后执行这个方法
			/// <summary>
			/// 执行action后执行这个方法
			/// </summary>
			/// <param name="filterContext"></param>
			void System.Web.Mvc.IActionFilter.OnActionExecuted(System.Web.Mvc.ActionExecutedContext filterContext)
			{
	
			}
			#endregion
	
	
			#region 执行action前执行这个方法 
			/// <summary>
			/// 执行action前执行这个方法
			/// </summary>
			/// <param name="filterContext"></param>
			void System.Web.Mvc.IActionFilter.OnActionExecuting(System.Web.Mvc.ActionExecutingContext filterContext)
			{
	
				if (!this.IsLogin)  //未登陆 重定向 到登陆页面
				{
					if (filterContext.HttpContext.Request.IsAjaxRequest())   //判断是否ajax请求
					{
	
						filterContext.Result = new System.Web.Mvc.JsonResult() { Data = new { statusCode = 301 }, ContentEncoding = System.Text.Encoding.UTF8, JsonRequestBehavior = JsonRequestBehavior.AllowGet, ContentType = "json" };
						return;
					}
					else  //验证不通过
					{
						//filterContext.Result = new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary(new { controller = "ActionFilterTest", action = "Login" }));  //重定向
						//filterContext.Result = new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary(new Dictionary<string, object>() { { "controller", "ActionFilterTest" }, { "action", "Login" } }));   //重定向
	
						//filterContext.Result = new System.Web.Mvc.RedirectToRouteResult("Default", new System.Web.Routing.RouteValueDictionary(new Dictionary<string, object>() { { "controller", "ActionFilterTest" }, { "action", "Login" } }));    //重定向
	
						//filterContext.Result = new System.Web.Mvc.RedirectToRouteResult("Default", new System.Web.Routing.RouteValueDictionary(new Dictionary<string, object>() { { "controller", "ActionFilterTest" }, { "action", "Login" } }),true);  //重定向
	
						filterContext.Result = new System.Web.Mvc.RedirectToRouteResult("MyRoute", new System.Web.Routing.RouteValueDictionary(new Dictionary<string, object>() { { "controller", "ActionFilterTest" }, { "action", "Login" } }), true);    //重定向
						return;
					}
	
				}
	
			}
			#endregion
	
		}

	data:https://www.cnblogs.com/linJie1930906722/p/5769335.html