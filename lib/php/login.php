<?php
include "Connection.php";

$user = $_POST['username'];
$pass = $_POST['password'];

$result = $conn->query(" select mdp from utilisateur where utilisateur ='" . $user . "' and mdp = '" . $pass . "'  ");
//$result = $conn->query(" select * from user where username ='".$user."' and password = '".$pass."'  ");
// $result = array();

if ($result->num_rows <= 0) {
    $re = [0];
    echo json_encode($re);
} else {
    $re = [1];
    echo json_encode($re);
}

//     $result[] = $fetchData;
// }

?>