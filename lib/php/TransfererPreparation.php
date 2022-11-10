<?php
include "Connection.php";
$a = 0;
$b = 0;

if (isset($_POST['etat']) && $_POST['etat'] != null) {


    $id_prep = (int) $_POST['id_prep'];
    $etat = (int) $_POST['etat'];
    $date_maj_prep = $_POST['date_maj_prep'];
    $list = [$id_prep];
    $reqVerifierPrep = $conn->query("SELECT etat_rel from rel_index_releve WHERE id_releve = $id_prep AND etat_rel = 0 ");

    if ($reqVerifierPrep->num_rows > 0) {
        $req2 = $conn->query("UPDATE rel_index_releve SET etat_rel = $etat , dt_maj_releve = '$date_maj_prep' WHERE id_releve = $id_prep");
    } else {
    }

    echo json_encode($list);
}