<?php
	$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
	socket_recvfrom($sock, $outMsg, 256, 0, '127.0.0.1', 6771);
	echo(var_dump($outMsg));
	echo "<br>";
?>