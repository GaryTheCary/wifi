<?php
	
	set_time_limit(0);
	    
	error_reporting(~E_WARNING);
	 
	$server = '127.0.0.1';
	$port = 7023;
	 
	if(!($sock = socket_create(AF_INET, SOCK_DGRAM, 0)))
	{
	    $errorcode = socket_last_error();
	    $errormsg = socket_strerror($errorcode);
	     
	    die("Couldn't create socket: [$errorcode] $errormsg \n");
	}
	 
	echo "Socket created \n";
	 
	//Communication loop
	while(1)
	{
	    if(!socket_recvfrom($sock , $reply , strlen($reply) ,$server, $port))
	    {
	        $errorcode = socket_last_error();
	        $errormsg = socket_strerror($errorcode);
	        die("Could not receive data: [$errorcode] $errormsg \n");
	    }else{
	    	echo($reply);
	    	echo "<br>";
		}
	}
	     
?>