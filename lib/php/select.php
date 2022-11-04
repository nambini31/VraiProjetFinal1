<?php
include "Connection.php";

$req = $conn->query("SELECT id_releve,enseigne_releve ,zone_releve,libelle_releve,date_releve,lib_plus_releve  ,dt_maj_releve from rel_index_releve where etat = 0 ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list);
//echo date('Y-m-d H:i:s', strtotime('03/27/2015 01:17:55'));