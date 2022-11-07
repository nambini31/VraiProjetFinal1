<?php
$servername = "localhost";
$username = "infor";
$password = "servinfodistant";
$db = "apps2m";
// Create connection
$conn = new mysqli($servername, $username, $password, $db);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}