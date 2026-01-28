<?php
$conn = mysqli_connect("localhost", "root", "", "db_football");

if (!$conn) {
  echo json_encode(["status"=>"error","message"=>"Koneksi gagal"]);
}
