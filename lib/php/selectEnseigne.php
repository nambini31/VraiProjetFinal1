<?php
include "Connection.php";

$req = $conn->query("SELECT * FROM rel_enseigne ");

$list = [];

while ($row = $req->fetch_assoc()) {
    $list[] = $row;
}
echo json_encode($list, JSON_UNESCAPED_UNICODE);
//JSON_HEX_QUOT, 
//JSON_HEX_TAG, JSON_HEX_AMP, 
//JSON_HEX_APOS, JSON_NUMERIC_CHECK,
//JSON_PRETTY_PRINT, JSON_UNESCAPED_SLASHES,
// JSON_FORCE_OBJECT, JSON_UNESCAPED_UNICODE