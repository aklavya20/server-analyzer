<?php
$command = escapeshellcmd($_POST['command']);

$command = preg_replace('/-output\s+.*$/', '', $command);

$output = shell_exec($command);

if ($output === null) {
    http_response_code(500);
    echo "Error executing Nikto command: $command";
} else {
    echo $output;
}
?>