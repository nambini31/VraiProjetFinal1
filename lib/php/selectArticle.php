<?php
include "Connection.php";

$req = $conn->query("SELECT id_rel_rel,num_rel_rel,ref_rel,libelle_art_rel,gencod_rel,prix_ref_rel,id_art_conc_rel,lib_art_concur_rel,gc_concur_rel,lib_plus_rel,prix_concur_rel,etat_rel,dt_maj_releve,date_val_releve from rel_releve ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}

echo json_encode($list, JSON_UNESCAPED_UNICODE);
//echo date('Y-m-d H:i:s', strtotime('03/27/2015 01:17:55'));