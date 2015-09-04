<?php
	$connection = new MongoClient("mongodb://127.0.0.1:3001");
	$db = $connection->meteor;
	$collection = $db->data;
	$com = $db->backup;
	$test = $collection->findOne(array('_id' => "2"));
	$com_test = $com->findOne(array('_id'=>"2"));
	$value = $test['data'];
	$value2 = $com_test['data'];
	$value3 = [];
	$str = null;
	foreach ($value as $key) {
		$str.= $key;
	}

	$a = str_split($str);
	array_splice($a, (sizeof($a)-1));
    $term = floor(sizeof($a)/256);
   	$msg_array = [];
	$msg = null;
	for($f=0;$f<$term;$f++){
		for($i=0;$i<256;$i++){
			$msg .= $a[$f*256+$i];
		}
		$msg_array[$f] = $msg;
		$msg = null;
	}

	$counter = 0;
	$b = str_split($msg_array[0]);
	foreach ($b as $key) {
		$d = (unpack("C*",$key));
		$value3[$counter] = $d['1'];
		$counter++;
	}

	//echo count($value3);

	$x = 16;
	$y = 16;

	$gd = imagecreatetruecolor($x, $y);
	  

	for ($i = 0; $i < 16; $i++) {
		for($j = 0; $j < 16; $j++){
			$r = (($value3[$i*16+$j]&0xE0));
			$g = (($value3[$i*16+$j]&0x1C)<<3);
			$b = ((($value3[$i*16+$j])&0x03)<<6);
			$color = imagecolorallocate($gd, $r, $g, $b);
			imagesetpixel($gd, $i,$j, $color);
		}
	}
	 
	header('Content-Type: image/png');
	imagepng($gd);

?>