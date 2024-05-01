<?php
$connection = mysqli_connect("localhost", "root", "", "myweather");
$username = $_POST["username"];
$email = $_POST["email"];
$profile = $_POST["profile"];
$password = $_POST["password"];

$query = mysqli_query(
    $connection, 
    "INSERT INTO users 
    SET 
    username    = '$username', 
    email       = '$email', 
    profile     = '$profile', 
    password    = '$password'
    "
);

if ($query) {
    echo json_encode([
        'Pesan' => 'Sukses'
    ]);
} else {
    echo json_encode([
        'Pesan' => 'Gagal'
    ]);
}

?>