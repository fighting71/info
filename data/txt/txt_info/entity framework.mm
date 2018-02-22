entity framework >> 

	EF的利与弊？(note)
		1.极大的提高开发效率:EF所属于微软，于VS开发工具集成度较好，开发中代码都是
		  强类型的，有利于提高编码效率、自动化程度高、是一种命令式的编程。
		  
		2.EF提供的模型设计器非常强大，不仅仅带来了设计数据库的革命，也附带带来了
		  自动化生成模型代码的功能也极大的提高开发和架构设计的效率
		
		3.EF跨数据支持是ORM框架主要功能点之一，只需提高改变配置就能做到跨数据库的能力
		
		4.缺陷：性能差（生成sql脚本阶段），在复杂查询的时候生成的sql脚本效率不是很高。
			    由于存在一个生成sql语句的过程，所以其效率低于ado.net

		5.自带缓存机制
		
	在什么情况下，不建议使用EF?（network）
		• 实时的应用程序。 
		• 只能通过存储过程访问数据库。 EF的优势是：跟踪实体状态Change时，不仅仅在存储过程上.（即使EF确实对存储过程支持有限的）。 
		• 频繁插入操作（Insert）,  并且EF不支持大数据Bulk 插入。 
		• 频繁更新操作，更新的目标主要是当多行（用一个单值） 
		   例如：UPDATE 表名 SET ColumA = 10 Where ColumnB =？ 
		   这种更新操作更好的使用的ExecuteNonQuery（也可从Context上下文或直接从Ado.Net）。 
		• 反范式的表设计和高性能查询。 EF产生查询，他们是难以维护的，它并不能很好地支持映射到不规范的表。

		• 对程序有非常的性能要求, 需要对每个查询进行监控.
		
	.edmx 文件概述（实体框架）
	
	ef事务处理：
	
		using (TransactionScope scope = new TransactionScope())  
		{  
			//Do something with context1  
			//Do something with context2  
		   
			//Save Changes but don't discard yet  
			context1.SaveChanges(false);  
		   
			//Save Changes but don't discard yet  
			context2.SaveChanges(false);  
		   
			//if we get here things are looking good.  
			scope.Complete();  
			context1.AcceptAllChanges();  
			context2.AcceptAllChanges();  
		   
		}  
		用SaveChanges(false)先将必要的数据库操作命令发送给数据库，这是注意context1与context2并没有真正发生改变，
		如果事务终止，自动回滚，两者的更改都没有真正提交到数据库，所以是可以成功回滚的。
	
	transactionScope的理解：

		1.不只是用在数据库的事务中，也可以管理别的类型的事务，功能很强大，性能较差
		2.应该尽量使用同一个context进行数据库的操作，原因：
		节省资源，没创建一个context都是耗费资源的操作。
		不同dal中使用同一个context同样可以达到事务处理的目的，所以在一般的数据库事务处理中transactionScope不是必要的
