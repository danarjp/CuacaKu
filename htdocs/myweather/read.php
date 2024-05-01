<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

include 'koneksi.php';
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];
}
$result = $conn->query("SELECT kota FROM lokasi WHERE user_id = $user_id");

$data = array();

while ($row = $result->fetch_assoc()) {
    $kota = $row['kota'];
    $api_url = "https://api.openweathermap.org/data/2.5/weather?q=" . urlencode($kota) . "&appid=1a9d3a49a938580c632d3201c1406e26" . "&units=metric" . "&lang=id";
    

    $ch = curl_init($api_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $weather_data = curl_exec($ch);

   
    if (curl_errno($ch)) {
        die('Error: ' . curl_error($ch));
    }

    curl_close($ch);

    $data[] = json_decode($weather_data, true);
}

$conn->close();

echo json_encode($data);
?>
