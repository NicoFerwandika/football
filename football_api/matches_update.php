<?php
header("Content-Type: application/json");
include "db.php";

$id   = $_POST['id'] ?? '';
$home = $_POST['home_team'] ?? '';
$away = $_POST['away_team'] ?? '';
$date = $_POST['match_date'] ?? '';

if ($id=='' || $home=='' || $away=='' || $date=='') {
  echo json_encode(["status"=>false,"message"=>"Data kosong"]);
  exit;
}

$up = mysqli_query($conn, "UPDATE matches SET home_team='$home', away_team='$away', match_date='$date' WHERE id='$id'");
echo json_encode(["status"=>$up?true:false]);
