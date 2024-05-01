<?php
include 'koneksi.php';

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    // Gunakan prepared statement untuk mencegah SQL injection
    $stmt = $conn->prepare("SELECT * FROM lokasi WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    
    $result = $stmt->get_result();

    if ($result) {
        // Fetch hasil query ke dalam bentuk array asosiatif
        $data = $result->fetch_all(MYSQLI_ASSOC);

        // Konversi hasil ke dalam format JSON
        echo json_encode($data);
    } else {
        // Error handling jika query gagal
        echo json_encode(array('error' => 'Failed to fetch data.'));
    }

    // Tutup statement
    $stmt->close();
} else {
    // Error handling jika user_id tidak diset
    echo json_encode(array('error' => 'User ID is not set.'));
}

// Tutup koneksi
$conn->close();
?>
