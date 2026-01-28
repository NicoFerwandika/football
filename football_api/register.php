<?php
header("Content-Type: application/json");
include "db.php";

$email    = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if ($email === '' || $password === '') {
  echo json_encode([
    "status" => false,
    "message" => "Email/Password kosong"
  ]);
  exit;
}

// cek email sudah dipakai
$cek = mysqli_query($conn, "SELECT id FROM users WHERE email='$email' LIMIT 1");
if (mysqli_num_rows($cek) > 0) {
  echo json_encode([
    "status" => false,
    "message" => "Email sudah terdaftar"
  ]);
  exit;
}

// insert user baru
$insert = mysqli_query($conn, "INSERT INTO users(email,password) VALUES('$email','$password')");

if ($insert) {
  $id = mysqli_insert_id($conn);
  echo json_encode([
    "status" => true,
    "message" => "Register berhasil",
    "user" => [
      "id" => (string)$id,
      "email" => $email
    ]
  ]);
} else {
  echo json_encode([
    "status" => false,
    "message" => "Register gagal"
  ]);
}
