<?php
include "Connection.php";

$req = $conn->query("SELECT * from rel_index_releve where etat_rel = 0 ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list, JSON_UNESCAPED_UNICODE);