<?php
session_start();
include 'koneksi.php';

if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

$kota = $_POST['kota'] ?? '';
$user_id = $_POST['user_id'] ?? null;
if ($user_id !== null) {
    $query = $conn->prepare("INSERT INTO lokasi (kota, user_id) VALUES (?, ?)");
    $query->bind_param("si", $kota, $user_id);

    if ($query->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Data berhasil disimpan']);
    } else {
        echo json_encode(['status' => 'failed', 'message' => 'Gagal menyimpan data']);
    }

    $query->close();
} else {
    echo json_encode(['status' => 'failed', 'message' => 'user_id tidak valid']);
}

$conn->close();
?>
