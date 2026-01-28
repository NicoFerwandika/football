<?php
header("Content-Type: application/json");
include "db.php";

$q = mysqli_query($conn, "SELECT * FROM matches ORDER BY match_date ASC");
$data = [];
while($row = mysqli_fetch_assoc($q)){
  $data[] = $row;
}

echo json_encode([
  "status" => true,
  "data" => $data
]);
