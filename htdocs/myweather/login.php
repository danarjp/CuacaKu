<?php
session_start();
include 'koneksi.php';

if ($conn->connect_error) {
    die(json_encode(["status" => "failed", "message" => "Koneksi gagal: " . $conn->connect_error]));
}

// Pastikan bahwa ada validasi email dan password
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

$query = $conn->prepare("SELECT user_id FROM users WHERE email=? AND password=?");
$query->bind_param("ss", $email, $password);
$query->execute();

$result = $query->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $user_id = $row['user_id'];
    $_SESSION['user_id'] = $user_id; // Menyimpan user_id ke dalam sesi

    echo json_encode(["status" => "success", "message" => "Login berhasil", "user_id" => $user_id]);
} else {
    echo json_encode(["status" => "failed", "message" => "Email atau password salah"]);
}

$query->close();
$conn->close();

// Fungsi untuk mendapatkan user_id dari sesi

?>
