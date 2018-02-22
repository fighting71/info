direction:linq to entity

my ask >>> my answer

	使用linq查询的利与弊？
		弊端：
			a.不利于进行复杂的判断
			b.部分自定义判断不能作为筛选条件
		
		有利:
			a.方便代码维护
			b.由于其是通过entity进行筛选，所以大大提高了筛选的安全性与严谨性
			c.通过deletage进行筛选、查询 降低了耦合性 提高了程序的灵活性
			d.减少代码量，提高编码效率
			e.linq to entity 类似于数据库的查询 便于上手
			
	linq基础语法及常用方法?
		a.basic search
			//from 自定义变量名 in 数据集
			from u in dataList
			//筛选条件
			where (condition)
			//排序
			orderby u.column
			//查询列
			select u
			
		b.分组查询
			from u in dataList1
			from u2 in dataList2
			group new {u,u2} by u
		
		c.分页查询
			dataList.
			//略过count条数据量
			Skip(count)
			//获取pageSize条数据量
			.Tak(pageSize);
			
		d.聚合查询
			dataList.Max(selector);//获取最大值，用于数值类型
			dataList.Min(selector);//获取最小值，用于数值类型
			dataList.Count(selector);//获取行数，常用于分页
			
		e.首行查询
			dataList.FirstOrDefault(selector);//若存在满足条件的行则返回所有结果中的第一行否则返回null，常用于主键查询
			
		f.连表查询
			from u in dataList
			join u2 in dataList2 
			//连接关系
			on u.column equals u2.column
			//连表后将数据保存至一个新的结果集
			into newInfo
			select newInfo
		
		h.类型转换
			linqExpression.ToList();
			linqExpression.AsEnumerable
		
		.........
		
	linq 有什么特性?
		1.延时加载:只要使用的时候才会执行，定义Linq表达式时并不会执行
		2.通过deletage 和 扩展方法 实现不同类型的不同筛选，当筛选的数据集为关系模型时会生成相应的sql语句
		3.linq 中可以嵌套 linq 复用性强
		4.语法规范
		5.提供扩展方法 可扩展性高
		
	linq初始化过程？
		1.声明元素类型
		2.建立Expression对象，将Linq表达式进行解析，拆分，解析成一个表达式树，也就是对Lambda表达式的解析过程，
		  Expression对象以二叉树结构存储解析结果。
		3.根据LINQ表达式类型给IQueryableProvider provider属性赋值。 
		4.在你需要读取数据的时候Provider属性就去解析Expression表达式树执行查询返回。
		
		