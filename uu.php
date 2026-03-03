<?php
// auto_upload.php
// Script untuk upload file ke semua subdomain

// Konfigurasi
$root_path = '/home/u770139925/domains'; // Ganti dengan path folder root Anda
$source_file = 'aden.html'; // File yang akan diupload
$target_filename = 'aden.html'; // Nama file setelah diupload (bisa sama atau berbeda)

// Fungsi untuk mendapatkan semua folder subdomain
function getSubdomainFolders($root_path) {
    $folders = [];
    
    // Scan direktori root
    $items = scandir($root_path);
    
    foreach ($items as $item) {
        // Skip current dan parent directory
        if ($item == '.' || $item == '..') continue;
        
        $full_path = $root_path . '/' . $item;
        
        // Cek apakah ini direktori
        if (is_dir($full_path)) {
            // Cek apakah ada folder public_html di dalamnya
            if (is_dir($full_path . '/public_html')) {
                $folders[] = [
                    'domain' => $item,
                    'public_html' => $full_path . '/public_html'
                ];
            }
        }
    }
    
    return $folders;
}

// Fungsi untuk upload file
function uploadFile($source, $destination) {
    if (!file_exists($source)) {
        return [
            'success' => false,
            'message' => "Source file tidak ditemukan: $source"
        ];
    }
    
    if (copy($source, $destination)) {
        return [
            'success' => true,
            'message' => "Berhasil upload ke: $destination"
        ];
    } else {
        return [
            'success' => false,
            'message' => "Gagal upload ke: $destination"
        ];
    }
}

// Mulai proses
echo "<h1>Auto Upload Tool</h1>";

// Cek apakah file source ada
if (!file_exists($source_file)) {
    die("Error: File '$source_file' tidak ditemukan di direktori script ini!");
}

// Dapatkan semua folder subdomain
$subdomains = getSubdomainFolders($root_path);

if (empty($subdomains)) {
    echo "Tidak ditemukan folder subdomain dengan public_html di $root_path";
    exit;
}

echo "<h3>Ditemukan " . count($subdomains) . " subdomain:</h3>";
echo "<ul>";

$success_count = 0;
$failed_count = 0;

foreach ($subdomains as $sub) {
    $destination = $sub['public_html'] . '/' . $target_filename;
    
    echo "<li><strong>{$sub['domain']}</strong>: ";
    
    $result = uploadFile($source_file, $destination);
    
    if ($result['success']) {
        echo "<span style='color:green'>{$result['message']}</span>";
        $success_count++;
    } else {
        echo "<span style='color:red'>{$result['message']}</span>";
        $failed_count++;
    }
    
    echo "</li>";
}

echo "</ul>";
echo "<hr>";
echo "<h3>Ringkasan:</h3>";
echo "<p>Berhasil: $success_count<br>";
echo "Gagal: $failed_count</p>";

// Tambahan fitur untuk upload file berbeda
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['file_to_upload'])) {
    $uploaded_file = $_FILES['file_to_upload'];
    
    if ($uploaded_file['error'] == UPLOAD_ERR_OK) {
        $tmp_name = $uploaded_file['tmp_name'];
        $custom_filename = $uploaded_file['name'];
        
        echo "<h3>Upload file baru: $custom_filename</h3>";
        echo "<ul>";
        
        foreach ($subdomains as $sub) {
            $destination = $sub['public_html'] . '/' . $custom_filename;
            
            echo "<li><strong>{$sub['domain']}</strong>: ";
            
            if (copy($tmp_name, $destination)) {
                echo "<span style='color:green'>Berhasil upload</span>";
                $success_count++;
            } else {
                echo "<span style='color:red'>Gagal upload</span>";
                $failed_count++;
            }
            
            echo "</li>";
        }
        
        echo "</ul>";
    }
}
?>

<!-- Form untuk upload file baru -->
<hr>
<h3>Upload File Lain</h3>
<form method="POST" enctype="multipart/form-data">
    <input type="file" name="file_to_upload" required>
    <button type="submit">Upload ke Semua Subdomain</button>
</form>

<style>
body {
    font-family: Arial, sans-serif;
    margin: 20px;
    line-height: 1.6;
}
h1, h3 {
    color: #333;
}
ul {
    list-style-type: none;
    padding: 0;
}
li {
    padding: 8px;
    margin: 5px 0;
    background: #f5f5f5;
    border-radius: 4px;
}
button {
    background: #4CAF50;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
button:hover {
    background: #45a049;
}
input[type="file"] {
    padding: 10px;
    margin-right: 10px;
}
</style>