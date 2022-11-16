<?php
include "Connection.php";

$id_prep = (int) $_POST["id_prep"];

$reqVerifierTop1000 = $conn->query("SELECT COUNT(id_rel_rel) as counter from rel_releve WHERE num_rel_rel = $id_prep  AND etat_rel = 1 ");


$list = [];

if ($reqVerifierTop1000->num_rows > 0) {
    $resulr = $reqVerifierTop1000->fetch_assoc();
    $list = [$resulr["counter"]];
} else {
    $list = [0];
}

echo json_encode($list, JSON_UNESCAPED_UNICODE);