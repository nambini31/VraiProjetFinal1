<?php

include "Connection.php";

$pass = (int)$_POST['id'];

$list = [0];

if (isset($pass) && !empty($pass)) {

    $req = $conn->query("DELETE from client WHERE idclient = '$pass' ");

    echo json_encode($list);
} else {
    # code...
}