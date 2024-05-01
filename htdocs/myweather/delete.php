<?php
include 'koneksi.php';$npm = $_POST["npm"];
$query = mysqli_query(
    $connection, 
    "delete from mahasiswa where npm='$npm'");
if ($query){

    echo json_encode([
        'Pesan' => 'Sukses'
    ]);
}else{
    echo json_encode([
        'Pesan' => 'Gagal'
    ]);
}