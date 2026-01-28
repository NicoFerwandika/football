<?php
header("Content-Type: application/json");
include "db.php";

$home = $_POST['home_team'] ?? '';
$away = $_POST['away_team'] ?? '';
$date = $_POST['match_date'] ?? '';

if ($home=='' || $away=='' || $date=='') {
  echo json_encode(["status"=>false,"message"=>"Data kosong"]);
  exit;
}

$ins = mysqli_query($conn, "INSERT INTO matches(home_team, away_team, match_date) VALUES('$home','$away','$date')");
echo json_encode(["status"=>$ins?true:false]);
