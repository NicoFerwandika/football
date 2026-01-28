<?php
header("Content-Type: application/json");
include "db.php";

$id = $_POST['id'] ?? '';
$title = $_POST['title'] ?? '';
$content = $_POST['content'] ?? '';
$image = $_POST['image'] ?? '';

if ($id === '' || $title === '' || $content === '') {
  echo json_encode(["status"=>false,"message"=>"Data tidak lengkap"]);
  exit;
}

$stmt = mysqli_prepare($conn, "UPDATE articles SET title=?, content=?, image=? WHERE id=?");
mysqli_stmt_bind_param($stmt, "sssi", $title, $content, $image, $id);

echo json_encode([
  "status" => mysqli_stmt_execute($stmt),
  "message" => mysqli_stmt_affected_rows($stmt) >= 0 ? "Artikel berhasil diupdate" : "Gagal update"
]);
