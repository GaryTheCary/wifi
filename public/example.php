<?php
	$connection = new MongoClient("mongodb://127.0.0.1:3001");
	$db = $connection->meteor;
	$collection = $db->data;
	$index = $collection->count();
	$prev = $index;
	$remote_ip = '172.16.2.105';
	$remote_port = 7040;
	//Reduce errors
	set_time_limit(0);
	error_reporting(~E_WARNING);
	//Create a UDP socket
	if(!($sock = socket_create(AF_INET, SOCK_DGRAM, 0)))
	{
	    $errorcode = socket_last_error();
	    $errormsg = socket_strerror($errorcode);
	     
	    die("Couldn't create socket: [$errorcode] $errormsg \n");
	}
	 
	echo "Socket created \n";
	// Bind the source address
	if( !socket_bind($sock, "0.0.0.0" , $remote_port) )
	{
	    $errorcode = socket_last_error();
	    $errormsg = socket_strerror($errorcode);
	     
	    die("Could not bind socket : [$errorcode] $errormsg \n");
	}
	 
	echo "Socket bind OK \n";

	while(1){
	  
	    //Database Index
	    $initial_count = $collection->count();
		$index = $initial_count;
		if($initial_count != $prev){
		 	$targetOBJ = $collection->findOne(array('_id'=>(string)($index-1)));
	    	$data_OBJ = $targetOBJ['data'];
	    	$transstr = null;
	    	foreach ($data_OBJ as $key) {
	    		$transstr .= $key;
	    	}

	    	$c_array = str_split($transstr);
	    	array_splice($c_array, (strlen($transstr)-1));
	    	$term = floor(count($c_array)/256);
	    	$msg = null;
	    	for($i=0;$i<$term;$i++){
	    		for($j=0;$j<256;$j++){
	    			$msg.=$c_array[$j+$i*256];
	    		}
	    		if(!socket_sendto($sock, $msg, strlen($msg), 0, $remote_ip, $remote_port)){
	    			$errorcode = socket_last_error();
	    			$errormsg = socket_strerror($errorcode);
	    			die("Could not send data: [$errorcode] $errormsg \n");
	    		}else{
	    			$num = strlen($msg);
					echo "<br>";
					echo "term is : $i ,and the message length is : $num";
	    		}
	    		$msg = null;
	    		usleep(1000);
	    	}

		}	
	}
	socket_close($sock);
?>