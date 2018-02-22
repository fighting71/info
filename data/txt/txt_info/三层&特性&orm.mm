direction:三层/特性/orm

my ask my answer

date:2017/12/7 10:12

	传统三层：
		UI : 表示层 
			 用于界面显示
			 与用户进行操作交互
			 定制交互协议
		
		BLL:业务逻辑层
			
			1.限制数据的传输
			2.对用户提交的信息进行验证处理
			
		DAL:数据处理层
		
			1.操作关系数据库
			2.进行数据操作
			3.间接充当数据源
			
		
		UI - MVC:
			M:Model 实体模型层
				作为数据传输的载体
				常用于定制表单实体验证规则
			
			V:View  视图层
				提供访问渠道
			
			C:Controller 控制层
				表示层的业务逻辑控制
				
		orm : object relation mapper 对象关系映射
		
		常见特性：
			
			1.Action相关：
				[HttpGet]//仅Get请求可访问此Action
				
				[HttpPost]//仅Post请求可访问此Action
				
				[NonAction]//非Action方法
				
				[ActionName("name")]//指定Action 的访问名，默认与方法名保持一致
			
			2.实体验证
				//MetadataType 元数据共享  用于共享实体验证
				[MetadataType(typeof(className))]
				
				[Required(ErrorMessage = "ErrorMessage")]//Required  必填

				//StringLength  常用于限制string的长度
				[StringLength(maximumLength:11,MinimumLength = 11,ErrorMessage = "ErrorMessage")]

				//RegularExpression  使用正则表达式进行验证
				[RegularExpression(pattern: "^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$", ErrorMessage = "邮箱格式有误")]
				

				//DataType 用于指定属性的数据类型 
				//此特性用于在视图使用Html帮助类生成控件时 生成相应的 验证功能 及 控件属性
				[DataType(DataType.DateTime)]

				//Range 可验证多种类型的长度  比StringLength 更灵活
				[Range(minimum:0,maximum:1,ErrorMessage = "性别类型有误")]

				//Compare 用于比较两个属性的值
				[Compare("propertyName",ErrorMessage = "两次密码输入不一致！")]
			
		如何自定义MVC拦截器
			1.实现FilterAttribute,IActionFilter
			
			2.重新相关方法
				    /// <summary>
					/// 在Action执行时执行
					/// </summary>
					/// <param name="filterContext">上下文</param>
					public void OnActionExecuting(ActionExecutingContext filterContext)
					{
						.....
					}

					/// <summary>
					/// 在Action执行后
					/// </summary>
					/// <param name="filterContext">上下文</param>
					public void OnActionExecuted(ActionExecutedContext filterContext)
					{
						.....
					}
					
		如何获取自定义特性的特性值？
			1.继承Attribute
			
			2.给拥有此特性的类编写相应的扩展类(针对少数类提供)
				注：menu枚举类也可以使用
				/// <summary>
				/// 扩展类
				/// </summary>
				public static class #ClassExtension
				{

					/// <summary>
					/// 显示特性信息
					/// </summary>
					/// <param name="info"></param>
					public static #retrunType ShowAttribute(this #ClassName info)
					{
						Type type = info.GetType();

						//获取属性信息
						FieldInfo fieldInfo = type.GetField(info.ToString());

						if (fieldInfo != null)
						{
							//获取特性信息
							object[] attributes = fieldInfo.GetCustomAttributes(typeof (#AttributeClassName), false);

							foreach (#AttributeClassName item in attributes)
							{
								....
							}

						}
							
					}

				}
				
			
		
			
			
			
			
			
			
			
			
			
			
			
		