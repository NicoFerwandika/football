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

$query = mysqli_query(
  $conn,
  "SELECT id, email FROM users WHERE email='$email' AND password='$password' LIMIT 1"
);

if (mysqli_num_rows($query) > 0) {
  $user = mysqli_fetch_assoc($query);

  echo json_encode([
    "status" => true,
    "message" => "Login berhasil",
    "user" => $user
  ]);
} else {
  echo json_encode([
    "status" => false,
    "message" => "Login gagal"
  ]);
}
