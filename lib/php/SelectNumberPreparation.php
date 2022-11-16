<?php
include "Connection.php";

$id_prep = (int) $_POST['id_prep'];

$reqVerifierPrep = $conn->query("SELECT id_releve from rel_index_releve WHERE id_releve = $id_prep AND etat_rel = 1 ");
$list = [];

if ($reqVerifierPrep->num_rows > 0) {
    $list = [1];
} else {
    $list = [0];
}

echo json_encode($list, JSON_UNESCAPED_UNICODE);