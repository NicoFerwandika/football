<?php
header("Content-Type: application/json");
include "db.php";

$id = $_POST['id'] ?? '';
if ($id=='') {
  echo json_encode(["status"=>false]);
  exit;
}

$del = mysqli_query($conn, "DELETE FROM matches WHERE id='$id'");
echo json_encode(["status"=>$del?true:false]);
