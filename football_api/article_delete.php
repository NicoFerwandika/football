<?php
header("Content-Type: application/json");
include "db.php";

$id = $_POST['id'] ?? '';
if ($id === '') {
  echo json_encode(["status"=>false,"message"=>"ID kosong"]);
  exit;
}

$stmt = mysqli_prepare($conn, "DELETE FROM articles WHERE id=?");
mysqli_stmt_bind_param($stmt, "i", $id);

echo json_encode([
  "status" => mysqli_stmt_execute($stmt),
  "message" => "Artikel berhasil dihapus"
]);
