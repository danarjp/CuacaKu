<?php
include "koneksi.php";
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    // Menggunakan prepared statement untuk menghindari SQL injection
    $stmt = $conn->prepare("SELECT * FROM `users` WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();

    $result = $stmt->get_result();
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);

    echo json_encode($data);
} else {
    echo json_encode(['error' => 'Missing user_id parameter']);
}
?>
