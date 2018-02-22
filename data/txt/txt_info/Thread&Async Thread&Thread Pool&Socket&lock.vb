direction:Thread/Async Thread/Thread Pool/Socket/lock/Stopwatch/Process

my ask >>> my answer

author : yj

since:2017-12-07 17:55:12

	Stopwatch:计时器
		a.使用步骤：
			//创建计时对象
			Stopwatch stopwatch = new Stopwatch();
	
			//初始化计时器
            stopwatch.Restart();
			
			//开启计时器
            stopwatch.Start();
			
			//停止计时器
            stopwatch.Stop();
	
	Process:进程
		/// <summary>
        /// 开启进程
        /// </summary>
        /// <param name="processName">进程名</param>
        /// <param name="args">传递参数</param>
        public void StartProcess(string processName, string args = null)
        {
            try
            {
                Process.Start(processName, args);
            }
            catch (Exception)
            {
                Console.WriteLine("系统不存在此进程！！！");
            }
        }
	
	thread:
		
		//a.无参有返回线程：
			ThreadStart threadStart = new ThreadStart(ShowThread);//无参无返
				
			hread newThread = new Thread(threadStart);
			
		//b.有参无返线程：
			ParameterizedThreadStart parameterizedThread = ShowThread;//有参无返

			Thread newThread = new Thread(parameterizedThread);
		
		//c.线程委托：
			Thread newThread = new Thread(u =>
            {
                .....
            }, maxStackSize);
			
			补充  maxStackSize:
            //     线程要使用的最大堆栈大小；如果为 0 则使用可执行文件的文件头中指定的默认最大堆栈大小。 重要地，对于部分受信任的代码，如果 maxStackSize
            //     大于默认堆栈大小，则将其忽略。 不引发异常。
		
		//d.常用属性:
			//设置当前线程为后台线程 ， 默认为前台线程，
            //程序是否结束==前台线程是否全部关闭
            newThread.IsBackground = true;
            //设置线程优先级》》建议值
            newThread.Priority = ThreadPriority.Highest;
		
	Async Thread:
	
			Func<int, int, int> newFunc = (num1, num2) =>
            {
                Console.WriteLine("委托函数的线程id是：" + Thread.CurrentThread.ManagedThreadId);
                return (num1 + num2);
            };
		
			//同步调用委托
			//newFunc.Invoke(3, 4);
			
			//异步调用委托 
			//参数1、2 ： 委托参数
			//参数3：回调方法
			//参数4：传递给回调方法的参数  常用：传递委托  便于回调方法获取委托的结果集
			newFunc.BeginInvoke(3, 4, MyAsyncCallback, newFunc);
		
		    private void MyAsyncCallback(IAsyncResult asyncResult)
			{
				var del = (Func<int, int, int>)asyncResult.AsyncState;
				////EndoInvoke方法会阻塞当前的线程，直到异步委托指向完成之后，才能继续往下执行。
				int result = del.EndInvoke(asyncResult);
				Console.WriteLine("执行结果为：{0}",result);
				
				//获取一个值，该值指示异步操作是否已完成。
				//if (asyncResult.IsCompleted)
				//{
				//                
				//}

				////1、拿到异步委托执行的结果
				//AsyncResult result = (AsyncResult)ar;

				//var del = (Func<int, int, string>)result.AsyncDelegate;
				//string returnValue = del.EndInvoke(result);

				//Console.WriteLine("返回值是："+returnValue);

				////2、拿到给回调函数的参数。
				//Console.WriteLine("传给异步回调函数的参数："+result.AsyncState);
	
				Console.WriteLine("回调函数的线程 的id是：" + Thread.CurrentThread.ManagedThreadId);
			}
		
	Thread Pool : 线程池
		a.线程池的特点：
		 1.线程池的线程本身都是 后台线程
         
		 2.线程池的线程优势：线程可以进行重用。故执行效率很高
		 
		 
		b.Thread Pool VS NORMAL Thread
			//线程池中的线程可以复用 ， 线程无调用顺序  效率高
            //启动一个线程：开辟一个内存空间，1M内存,线程有可能占用部分的寄存器
            //线程非常多的时候，操作系统的花费大量时间用在线程切换。
		
		c.开启示例：
			  ThreadPool.QueueUserWorkItem(u =>
//            {
//                Console.WriteLine("当前线程编号：{0}",Thread.CurrentThread.ManagedThreadId);
//
//                Console.WriteLine("QueueUserWorkItem");
//
//            });
	
	补充： 
			//获取线程池最大的线程数据
            ThreadPool.GetMaxThreads(out numMax, out runNumMax);
		
		
	Socket:
			//用户列表
			List<Socket> ClientProxSocketList =new List<Socket>();
		
		a.Server create:
			//Socket服务器端 的逻辑
            //1、创建Socket对象
            //第一个参数设置 网络寻址的协议。
			//第二个参数设置 数据传输的方式。
            //第三个参数数据设置通信的协议
            Socket serverSocket =new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp );

            //2、绑定IP和端口
            IPAddress ip = IPAddress.Parse(txtIP.Text);
            IPEndPoint ipEndPoint = new IPEndPoint(ip,int.Parse(txtPort.Text));
            serverSocket.Bind(ipEndPoint);
            //3、开启侦听
            serverSocket.Listen(10);

            //4、开始接受客户端的链接
            //Accept方法一执行，当前线程阻塞，一直等到客户端链接上。
            ThreadPool.QueueUserWorkItem(new WaitCallback(this.StartAcceptClient), serverSocket);
		
		b.receiver Client Data
		private void RecieveData(object obj)
        {
            var proxSocket = (Socket) obj;
            byte[] data = new byte[1024 * 1024];
            //方法的返回值代表实际上接受的数据的长度（字节数）
            while (true)
            {
                //客户端异常退出必须try住

                //接受数据的方法会阻塞当前线程
                int realLen = proxSocket.Receive(data, 0, data.Length, SocketFlags.None);
                if (realLen == 0)
                {
                    this.txtLog.Text = string.Format("客户端：{0}{1}\r\n{2}",
                    proxSocket.RemoteEndPoint.ToString(),
                    "对方退出",
                    txtLog.Text
                    );

                    //对方退出了
                    proxSocket.Shutdown(SocketShutdown.Both);
                    proxSocket.Close();
                    ClientProxSocketList.Remove(proxSocket);
                    return;
                }
                string fromClientMsg = Encoding.Default.GetString(data, 0, realLen);

                this.txtLog.Text = string.Format("接受到客户端：{0}的消息：{1}\r\n{2}",
                    proxSocket.RemoteEndPoint.ToString(),
                    fromClientMsg,
                    txtLog.Text
                    );
            }
            
        }
		
		c.send Message to Client：
			foreach (var socket in ClientProxSocketList)
            {
                if (socket.Connected)
                {	
                    string str = this.txtMsg.Text;
                    byte[] data = Encoding.Default.GetBytes(str);
                    socket.Send(data,0,data.Length,SocketFlags.None);
                }
            }
		
		d.reciver Client connection
			 public void StartAcceptClient(object state)
			{
				var serverSocket = (Socket) state;
				while (true)
				{
					Socket proxSocket = serverSocket.Accept();

					this.txtLog.Text = string.Format("一个客户端:{0}链接上\r\n{1}", proxSocket.RemoteEndPoint.ToString(),
						this.txtLog.Text);

					ClientProxSocketList.Add(proxSocket);
					//服务器端也要接受客户端的消息
					ThreadPool.QueueUserWorkItem(new WaitCallback(this.RecieveData), proxSocket);

				}
				
			}
		
	lock：
		解析：http://www.cnblogs.com/goody9807/archive/2010/06/17/1759645.html 

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	