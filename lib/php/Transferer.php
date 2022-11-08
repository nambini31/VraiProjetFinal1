<?php
include "Connection.php";
$a = 0;
$b = 0;

if (isset($_POST['etat']) && $_POST['etat'] != null) {


    $id_prep = (int) $_POST['id_prep'];
    $etat = (int) $_POST['etat'];
    $date_maj_prep = $_POST['date_maj_prep'];

    // $top1000 = $_POST['top1000'];

    $req = $conn->query("UPDATE rel_index_releve SET etat = $etat , dt_maj_releve = '$date_maj_prep' WHERE id_releve = $id_prep");

    $list = [$id_prep];

    $id_prep = (int) $_POST['id_prep'];
    $id_releve = (int) $_POST['id_releve'];
    $etat_art = (int) $_POST['etat_art'];
    $ref_art_conc = (int) $_POST['ref_art_conc'];
    $date_maj_releve = $_POST['date_maj_releve'];
    $date_val_releve = $_POST['date_val_releve'];
    $prix_art_conc = floatval($_POST['prix_art_conc']);
    $id_zone = (int) $_POST["id_zone"];
    $id_enseigne = (int) $_POST["id_enseigne"];

    // $top1000 = $_POST['top1000'];
    //and etat_art != 2
    $req = $conn->query("UPDATE rel_releve SET etat_rel = $etat , dt_maj_releve = '$date_maj_releve' ,date_val_releve = '$date_val_releve' , prix_concur_rel = $prix_art_conc WHERE id_rel_rel = $id_releve AND num_rel_rel = $id_prep AND etat_rel != 2 ");

    $req1 = $conn->query("INSERT INTO rel_pvn(ens_pv , id_art_conc , prix_pv , zone_pv , dt_maj_pv )  VALUES($id_enseigne,$ref_art_conc,$prix_art_conc,$id_zone,'$date_maj_releve')   ");

    echo json_encode($list);
}