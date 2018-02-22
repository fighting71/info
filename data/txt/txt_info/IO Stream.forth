
direction:IO Stream

my ask >>> my answer

author:yj

since:2017-12-7 17:04:43

from:network

	1.首先C#与Java不同的地方，不再区分字符流、字节流，而统一采用Stream方式，然后针对Stream提供Reader与Writer的相关操作。
	
	2.常见方法：
			/// <summary>  
			/// 打印所有驱动器信息(包含里面的目录、文件)  
			/// </summary>  
			public void PrintFileTree()  
			{  
				DriveInfo[] drivers = DriveInfo.GetDrives();  
				foreach (DriveInfo item in drivers)  
				{  
						if (item.DriveType == DriveType.CDRom)//光驱  
					{  
						Console.WriteLine("光驱:" + item.Name);  
					}  
					else if (item.DriveType == DriveType.Fixed)//固定磁盘  
					{  
						Console.WriteLine("固定磁盘:" + item.Name + "__" + item.RootDirectory);  
						PrintFileTree(item.RootDirectory);  
					}  
					else if (item.DriveType == DriveType.Network)//网络驱动器  
					{  
						Console.WriteLine("网络驱动器:" + item.Name);  
					}  
					else if (item.DriveType == DriveType.NoRootDirectory)//驱动器没有根目录  
					{  
						Console.WriteLine("驱动器没有根目录:" + item.Name);  
					}  
					else if (item.DriveType == DriveType.Ram)//RAM磁盘  
					{  
						Console.WriteLine("RAM磁盘:" + item.Name);  
					}  
					else if (item.DriveType == DriveType.Removable)//可移动磁盘(软驱或者U盘等)  
					{  
						Console.WriteLine("可移动磁盘(软驱或者U盘等):" + item.Name);  
					}  
					else if (item.DriveType == DriveType.Unknown)//未知类型  
					{  
						Console.WriteLine("未知类型:" + item.Name);  
					}  
				}  
			}  
			
		/// <summary>  
        /// 递归打印目录下面的信息  
        /// </summary>  
        /// <param name="dir">上级目录</param>  
        public void PrintFileTree(DirectoryInfo dir)  
        {  
  
            //FileSystemAccessRule fsRule = new FileSystemAccessRule(System.Environment.UserName, FileSystemRights.Read, AccessControlType.Allow);  
  
            ////添加安全访问规则   
            //DirectorySecurity dirSecurity = dir.GetAccessControl();  
            //dirSecurity.AddAccessRule(fsRule);  
            //dir.SetAccessControl(dirSecurity);  
  
            //dir.GetAccessControl().GetAuditRules(true, true, typeof(System.Security.Principal.NTAccount));  
  
            bool flag = true;  
            foreach (FileSystemAccessRule item in dir.GetAccessControl().GetAccessRules(true, true, typeof(System.Security.Principal.NTAccount)))  
            {  
                //拒绝读  
                if (item.FileSystemRights == FileSystemRights.Read && item.AccessControlType == AccessControlType.Deny)  
                {  
                    flag = false;  
                    break;  
                }  
            }  
  
            if (flag)  
            {  
                FileInfo[] files = dir.GetFiles();  
                foreach (FileInfo item in files)  
                {  
                    Console.WriteLine(item.FullName);  
                }  
  
                DirectoryInfo[] dirs = dir.GetDirectories();  
                foreach (DirectoryInfo item in dirs)  
                {  
                    Console.WriteLine(item.FullName);  
                    PrintFileTree(item);  
                }  
            }  
  
            ////移除安全访问规则  
            //dirSecurity = dir.GetAccessControl();  
            //dirSecurity.RemoveAccessRule(fsRule);  
            //dir.SetAccessControl(dirSecurity);             
			}  
		}  


	读写文件  :
		1.基础模式
			//写文件
			FileStream file = new FileStream("#path", #operationType_Menu);  
		  
			String text = @"#info";  
			byte[] array = System.Text.Encoding.UTF8.GetBytes(text);  
			file.Write(array, 0, array.Length);  
			file.Close();  
		
		
			 //读文件  
			array = new byte[1024];  
			file = new FileStream("#path");  
			while (file.Read(array, 0, 1024) > 0)  
			{  
				Console.Write(System.Text.Encoding.UTF8.GetString(array));  
				............
			}  
			file.Close();  
			Console.WriteLine("Test1完成操作"); 
		
		2.BufferedStream
			//写文件
			FileStream file = new FileStream("#path", FileMode.OpenOrCreate);  
			BufferedStream writer = new BufferedStream(file, 1024);  
		  
			String text = @"#info";  
			byte[] array = System.Text.Encoding.UTF8.GetBytes(text);  
			writer.Write(array, 0, array.Length);  
			writer.Flush();  
			writer.Close();  
			file.Close();  
		
			 //读文件  
			file = new FileStream("#path", FileMode.Open);  
			BufferedStream reader = new BufferedStream(file, 1024);  
		  
			array = new byte[1024];  
			while (reader.Read(array, 0, 1024) > 0)  
			{  
				Console.Write(System.Text.Encoding.UTF8.GetString(array));  
			}  
			reader.Close();  
			file.Close();
		
		3、文件复制
		
			 //每次读取的字节数    
			 int MAX_BYTE = 1024 * 1024;  
			 byte[] array = new byte[MAX_BYTE];  
	  
	  
			 FileStream reader = new FileStream("#path", FileMode.Open);  
			 FileStream writer = new FileStream("#path2", FileMode.OpenOrCreate);  
	  
			 //循环读取  
			 long total = reader.Length;  
			 for (long i = 0; i < total / MAX_BYTE; i++)  
			 {  
				 reader.Read(array, 0, MAX_BYTE);  
				 writer.Write(array, 0, MAX_BYTE);  
				 writer.Flush();  
			 }  
	  
			 //不能整除导致剩余数据  
			 int level = (int)(total % MAX_BYTE);  
	  
			 reader.Read(array, 0, level);  
			 writer.Write(array, 0, level);  
			 writer.Flush();  
	  
			 //关闭流  
			 reader.Close();  
			 writer.Close();  
		
		4.常用操作
		
		/// <summary>
        /// 判断文件是否存在
        /// </summary>
        /// <param name="fileName">文件路径</param>
        /// <returns>是否存在</returns>
        public static bool Exists(string fileName)
        {
            if (fileName == null || fileName.Trim() == "")
            {
                return false;
            }
            return File.Exists(fileName);
        }


        /// <summary>
        /// 创建文件夹
        /// </summary>
        /// <param name="dirName">文件夹名</param>
        /// <returns></returns>
        public static bool CreateDir(string dirName)
        {
            try
            {
                if (dirName == null)
                    throw new Exception("dirName");
                if (!Directory.Exists(dirName))
                {
                    Directory.CreateDirectory(dirName);
                }
                return true;
            }
            catch (Exception er)
            {
                throw new Exception(er.Message);
            }
        }


        /// <summary>
        /// 创建文件
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <returns>创建失败返回false</returns>
        public static bool CreateFile(string fileName)
        {
            try
            {
                if (File.Exists(fileName)) return false;
                var fs = File.Create(fileName);
                fs.Close();
                fs.Dispose();
            }
            catch (IOException ioe)
            {
                throw new IOException(ioe.Message);
            }

            return true;
        }


        /// <summary>
        /// 读文件内容,转化为字符类型
        /// </summary>
        /// <param name="fileName">文件路径</param>
        /// <returns></returns>
        public static string Read(string fileName)
        {
            if (!Exists(fileName))
            {
                return null;
            }
            //将文件信息读入流中
            using (var fs = new FileStream(fileName, FileMode.Open))
            {
                return new StreamReader(fs).ReadToEnd();
            }
        }


        /// <summary>
        /// 文件转化为Char[]数组
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static char[] FileRead(string fileName)
        {
            if (!Exists(fileName))
            {
                return null;
            }
            var byData = new byte[1024];
            var charData = new char[1024];
            try
            {
                var fileStream = new FileStream(fileName, FileMode.Open);
                fileStream.Seek(135, SeekOrigin.Begin);
                fileStream.Read(byData, 0, 1024);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            var decoder = Encoding.UTF8.GetDecoder();
            decoder.GetChars(byData, 0, byData.Length, charData, 0);
            return charData;
        }



        /// <summary>
        /// 文件转化为byte[]
        /// </summary>
        /// <param name="fileName">文件路径</param>
        /// <returns></returns>
        public static byte[] ReadFile(string fileName)
        {
            FileStream pFileStream = null;
            try
            {
                pFileStream = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                var r = new BinaryReader(pFileStream);
                //将文件指针设置到文件开
                r.BaseStream.Seek(0, SeekOrigin.Begin);
                var pReadByte = r.ReadBytes((int)r.BaseStream.Length);
                return pReadByte;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);

            }
            finally
            {
                if (pFileStream != null) pFileStream.Close();
            }
        }


        /// <summary>
        /// 将byte写入文件
        /// </summary>
        /// <param name="pReadByte">字节流</param>
        /// <param name="fileName">文件路径</param>
        /// <returns></returns>
        public static bool WriteFile(byte[] pReadByte, string fileName)
        {
            FileStream pFileStream = null;
            try
            {
                pFileStream = new FileStream(fileName, FileMode.OpenOrCreate);
                pFileStream.Write(pReadByte, 0, pReadByte.Length);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                if (pFileStream != null) pFileStream.Close();
            }
            return true;

        }

        public static string ReadLine(string fileName)
        {
            if (!Exists(fileName))
            {
                return null;
            }
            using (var fs = new FileStream(fileName, FileMode.Open))
            {
                return new StreamReader(fs).ReadLine();
            }
        }


        /// <summary>
        /// 写文件
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="content">文件内容</param>
        /// <returns></returns>
        public static bool Write(string fileName, string content)
        {
            if (Exists(fileName) || content == null)
            {
                return false;
            }
            try
            {
                //将文件信息读入流中
                //初始化System.IO.FileStream类的新实例与指定路径和创建模式
                using (var fs = new FileStream(fileName, FileMode.OpenOrCreate))
                {
                    //锁住流
                    lock (fs)
                    {
                        if (!fs.CanWrite)
                        {
                            throw new System.Security.SecurityException("文件fileName=" + fileName + "是只读文件不能写入!");
                        }

                        var buffer = Encoding.Default.GetBytes(content);
                        fs.Write(buffer, 0, buffer.Length);
                        return true;
                    }
                }
            }
            catch (IOException ioe)
            {
                throw new Exception(ioe.Message);
            }

        }


        /// <summary>
        /// 写入一行
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="content">内容</param>
        /// <returns></returns>
        public static bool WriteLine(string fileName, string content)
        {
            if (string.IsNullOrEmpty(fileName))
                throw new ArgumentNullException(fileName);
            if (string.IsNullOrEmpty(content))
                throw new ArgumentNullException(content);
            using (var fs = new FileStream(fileName, FileMode.OpenOrCreate | FileMode.Append))
            {
                //锁住流
                lock (fs)
                {
                    if (!fs.CanWrite)
                    {
                        throw new System.Security.SecurityException("文件fileName=" + fileName + "是只读文件不能写入!");
                    }

                    var sw = new StreamWriter(fs);
                    sw.WriteLine(content);
                    sw.Dispose();
                    sw.Close();
                    return true;
                }
            }
        }


        /// <summary>
        /// 复制目录
        /// </summary>
        /// <param name="fromDir">被复制的目录</param>
        /// <param name="toDir">复制到的目录</param>
        /// <returns></returns>
        public static bool CopyDir(DirectoryInfo fromDir, string toDir)
        {
            return CopyDir(fromDir, toDir, fromDir.FullName);
        }


        /// <summary>
        /// 复制目录
        /// </summary>
        /// <param name="fromDir">被复制的目录</param>
        /// <param name="toDir">复制到的目录</param>
        /// <returns></returns>
        public static bool CopyDir(string fromDir, string toDir)
        {
            if (fromDir == null || toDir == null)
            {
                throw new NullReferenceException("参数为空");
            }

            if (fromDir == toDir)
            {
                throw new Exception("两个目录都是" + fromDir);
            }

            if (!Directory.Exists(fromDir))
            {
                throw new IOException("目录fromDir=" + fromDir + "不存在");
            }

            var dir = new DirectoryInfo(fromDir);
            return CopyDir(dir, toDir, dir.FullName);
        }


        /// <summary>
        /// 复制目录
        /// </summary>
        /// <param name="fromDir">被复制的目录</param>
        /// <param name="toDir">复制到的目录</param>
        /// <param name="rootDir">被复制的根目录</param>
        /// <returns></returns>
        private static bool CopyDir(DirectoryInfo fromDir, string toDir, string rootDir)
        {
            foreach (var f in fromDir.GetFiles())
            {
                var filePath = toDir + f.FullName.Substring(rootDir.Length);
                var newDir = filePath.Substring(0, filePath.LastIndexOf("\\", StringComparison.Ordinal));
                CreateDir(newDir);
                File.Copy(f.FullName, filePath, true);
            }

            foreach (var dir in fromDir.GetDirectories())
            {
                CopyDir(dir, toDir, rootDir);
            }

            return true;
        }


        /// <summary>
        /// 删除文件
        /// </summary>
        /// <param name="fileName">文件的完整路径</param>
        /// <returns></returns>
        public static bool DeleteFile(string fileName)
        {
            try
            {
                if (!Exists(fileName)) return false;
                File.Delete(fileName);
            }
            catch (IOException ioe)
            {
                throw new ArgumentNullException(ioe.Message);
            }

            return true;
        }


        public static void DeleteDir(DirectoryInfo dir)
        {
            if (dir == null)
            {
                throw new NullReferenceException("目录不存在");
            }

            foreach (var d in dir.GetDirectories())
            {
                DeleteDir(d);
            }

            foreach (var f in dir.GetFiles())
            {
                DeleteFile(f.FullName);
            }

            dir.Delete();

        }


        /// <summary>
        /// 删除目录
        /// </summary>
        /// <param name="dir">指定目录</param>
        /// <param name="onlyDir">是否只删除目录</param>
        /// <returns></returns>
        public static bool DeleteDir(string dir, bool onlyDir)
        {
            if (dir == null || dir.Trim() == "")
            {
                throw new NullReferenceException("目录dir=" + dir + "不存在");
            }

            if (!Directory.Exists(dir))
            {
                return false;
            }

            var dirInfo = new DirectoryInfo(dir);
            if (dirInfo.GetFiles().Length == 0 && dirInfo.GetDirectories().Length == 0)
            {
                Directory.Delete(dir);
                return true;
            }


            if (!onlyDir)
            {
                return false;
            }
            DeleteDir(dirInfo);
            return true;
        }


        /// <summary>
        /// 在指定的目录中查找文件
        /// </summary>
        /// <param name="dir">目录</param>
        /// <param name="fileName">文件名</param>
        /// <returns></returns>
        public static bool FindFile(string dir, string fileName)
        {
            if (dir == null || dir.Trim() == "" || fileName == null || fileName.Trim() == "" || !Directory.Exists(dir))
            {
                return false;
            }

            //传入文件路径，获取当前文件对象
            var dirInfo = new DirectoryInfo(dir);
            return FindFile(dirInfo, fileName);

        }


        /// <summary>
        /// 返回文件是否存在
        /// </summary>
        /// <param name="dir"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static bool FindFile(DirectoryInfo dir, string fileName)
        {
            foreach (var d in dir.GetDirectories())
            {
                if (File.Exists(d.FullName + "\\" + fileName))
                {
                    return true;
                }
                FindFile(d, fileName);
            }

            return false;
        }


        /// <summary>
        /// 获取指定文件夹中的所有文件夹名称
        /// </summary>
        /// <param name="folderPath">路径</param>
        /// <returns></returns>
        public static List<string> FolderName(string folderPath)
        {
            var listFolderName = new List<string>();
            try
            {
                var info = new DirectoryInfo(folderPath);

                listFolderName.AddRange(info.GetDirectories().Select(nextFolder => nextFolder.Name));
            }
            catch (Exception er)
            {
                throw new Exception(er.Message);
            }

            return listFolderName;

        }


        /// <summary>
        /// 获取指定文件夹中的文件名称
        /// </summary>
        /// <param name="folderPath">路径</param>
        /// <returns></returns>
        public static List<string> FileName(string folderPath)
        {
            var listFileName = new List<string>();
            try
            {
                var info = new DirectoryInfo(folderPath);

                listFileName.AddRange(info.GetFiles().Select(nextFile => nextFile.Name));
            }
            catch (Exception er)
            {
                throw new Exception(er.Message);
            }

            return listFileName;
        }
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		