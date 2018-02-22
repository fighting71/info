 direction:jdbc
 
 my ask >>> my answer
 
 java
 什么是JDBC，在什么时候会用到它？
	jdbc:java database connection 
	用于操作关系数据库
	
JDBC是如何实现Java程序和JDBC驱动的松耦合的？
	jdbc api通过反射机制来实现程序与jdbc驱动的松耦合

什么是JDBC连接，在Java中如何创建一个JDBC连接？
	jdbc连接就相当于与数据库的一个会话过程 可以比喻为程序与数据库的一个socket通讯
	创建连接：
		1.注册并加载驱动
		2.使用DriverManage获取连接对象
		
C#
	程序如何连接并操作数据库？
		1.由于vs中已经集成了与数据库操作相关的api 所以只需要调用相关类就可以实现数据库操作
			a.
				//选择sqlServer数据库
				1. using System.Data.SqlClient;

				//连接字符串
				2.server=服务器地址;database=数据库的名字; uid=登陆名; pwd=密码
				  server=.;database=AC1603;uid=sa;pwd=123;

				//创建连接对象
				3. SqlConnection con = new SqlConnection(连接字符串);

				//打开连接
				4. con.Open();

				//写sql语句(操作数据库的指令,命令)
				5. insert into 表名 values(值...)

				//创建一个执行命令的对象
				6. SqlCommand com = new SqlCommand(sql,con);

				//执行命令
				7. com.executeNonQuery();

				//关闭连接
				8. con.Close();
			b.
				//无需打开连接的操作--仅用于查询
				SqlDataAdapter sdr = new SqlDataAdapter(sql, conn);
				
				//将获取的数据进行存储
                DataSet ds = new DataSet();
                sdr.Fill(ds, "temp");
	
	如何防止sql注入?
		使用占位符
			//编辑sql语句
			string sql = "SELETE table_name WHERE colums1 = @value1 ";
			
			//创建参数数组
            SqlParameter[] parameters = new SqlParameter[]{
                new SqlParameter("@value1",value1),
            };
			
			//创建执行对象
			SqlCommand cmd = new SqlCommand(sql, conn);
			
			//添加参数信息
			cmd.Parameters.AddRange(parameters);
			
			//验证数据库连接状态
            if (conn.State != ConnectionState.Open)
                conn.Open();
			
			//执行相关操作
            cmd.ExecuteNonQuery();
	
	如何进行数据读取?
		a.通过SqlDataReader对象获取
			SqlDataReader sdr = cmd.ExecuteReader();
            if (sdr.HasRows)
            {
                while (sdr.Read())
                {//RTID, RTName, RTConsume, RTIsDisCount, RTMount
                    ProductsModel pt = new ProductsModel()
                    {
                        PTID = Convert.ToInt32(sdr["PTID"]),
                        ProductPrice = Convert.ToDouble(sdr["ProductPrice"]),
                        ProductName = sdr["ProductName"].ToString(),
                        ProductID = Convert.ToInt32(sdr["ProductID"]),
                        ProductJP = sdr["ProductJP"].ToString()
                    };
                    ptlist.Add(pt);
                }
            }
			
		b.通过SqlDataAdapter对象获取
			SqlDataAdapter ada = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            ada.Fill(dt);
	
	