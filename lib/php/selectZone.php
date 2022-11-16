<?php
include "Connection.php";

$req = $conn->query("SELECT * from rel_zone_prix ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list, JSON_UNESCAPED_UNICODE);
//echo date('Y-m-d H:i:s', strtotime('03/27/2015 01:17:55'));