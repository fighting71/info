direction:强类型/实体验证

author:yj

since:2017-12-09 15:20:34

	页面使用：
		@model receiver_address
		
	//MetadataType 元数据共享  用于共享实体验证
    [MetadataType(typeof(GuestValid))]

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
				
	实体验证：
		1.js
			<script src="~/Scripts/jquery.unobtrusive-ajax.min.js"></script>
	
			<script src="~/Scripts/jquery.validate.unobtrusive.min.js"></script>
					
		2.开启验证：
						@using (Ajax.BeginForm(
						"AddInfo",//Controller名称
						"ReceiverAddress",//Action名称
						new AjaxOptions()//提交参数
						{
							HttpMethod = "POST",//提交方式
							OnSuccess = "afterAdd",//提交成功后执行的js函数
							Confirm = "是否确认提交？"//提交的提示内容
						}))
						{
							@Html.ValidationSummary(true)//是否开启实体验证
							
							<fieldset>
								<legend>标题</legend>
								<div class="editor-label">
									@Html.LabelFor(model => model.#columnName)
								</div>
								<div class="editor-field">
									@Html.EditorFor(model => model.#columnName)
									@Html.ValidationMessageFor(model => model.#columnName)
								</div>
								....
							</fieldset>
							
						}
				
		3.控制层
			public ActionResult Edit(#Model model)
			{
				if (ModelState.IsValid)//验证通过
				{
					.....
				}

				return View(info);
			}
				
				
				
				
				