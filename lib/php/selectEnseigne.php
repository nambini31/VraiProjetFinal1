<?php
include "Connection.php";

$req = $conn->query("SELECT enseigne_ens,libelle_ens,lib_plus_ens from rel_enseigne ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list);
//echo date('Y-m-d H:i:s', strtotime('03/27/2015 01:17:55'));