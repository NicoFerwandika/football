<?php
header("Content-Type: application/json");
include "db.php";

$title = $_POST['title'] ?? '';
$content = $_POST['content'] ?? '';
$image = $_POST['image'] ?? '';

if ($title === '' || $content === '') {
  echo json_encode(["status"=>false,"message"=>"Data tidak lengkap"]);
  exit;
}

$stmt = mysqli_prepare($conn, "INSERT INTO articles (title, content, image) VALUES (?, ?, ?)");
mysqli_stmt_bind_param($stmt, "sss", $title, $content, $image);

if (mysqli_stmt_execute($stmt)) {
  echo json_encode(["status"=>true,"message"=>"Artikel berhasil ditambahkan"]);
} else {
  echo json_encode(["status"=>false,"message"=>"Gagal menambahkan artikel"]);
}
