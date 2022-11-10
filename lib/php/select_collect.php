<?php
include "Connection.php";

$req = $conn->query("SELECT * from rel_article ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list);