<?php
    
    // Get the image file uploaded 
    $target_dir = ""; # Public folder
    $target_file = $target_dir . basename($_FILES["wifichoose"]["name"]);
    $uploadOK = 1;
    $imageFileType = pathinfo($target_file, PATHINFO_EXTENSION);
    $square = 16;
    $rect_w = 32;
    $rect_h = 8;    
    if (file_exists($target_file)) {
        echo "Sorry, file already exists.";
        echo "<br>";
        $uploadOk = 0;
    }else{
        echo "No exists file found.";
        echo "<br>";
    }

    if ($_FILES["wifichoose"]["size"] > 500000) {
        echo "Sorry, your file is too large.";
        echo "<br>";
        $uploadOk = 0;
    }else{
        $uploadOK = 1;
        echo "File size OK.";
        echo "<br>";
    }

    if(isset($_POST["submit"])) {
        $check = getimagesize($_FILES["wifichoose"]["tmp_name"]);
        if($check !== false && (($check[0] == $square && $check[1] == $square))) {
            echo "File is an image - " . $check["mime"] . "and its dimention is allowed";
            echo "<br>";
            $uploadOk = 1;
        } else {
            echo "File is not an image.";
            echo "<br>";
            $uploadOk = 0;
        }
    }

    if($imageFileType != "gif" && $imageFileType != "png" && $imageFileType != "jpg" && $imageFileType != "jpeg") {
        echo "Sorry, the file type is not supported.";
        echo "<br>";
        $uploadOk = 0;
    }else{
        echo "Yes, it is an image file";
        echo "<br>";
        $uploadOK = 1;
    }

    if ($uploadOk == 0) {
        echo "Sorry, your file was not uploaded.";
    // if everything is ok, try to upload file
    }else {
        if(move_uploaded_file($_FILES["wifichoose"]["tmp_name"], $target_file)) {
            echo "The file ". basename( $_FILES["wifichoose"]["name"]). " has been uploaded.";
        } else {
            echo "Sorry, there was an error uploading your file.";
        }
    }
    
    // Using Php connect to Meteor MongDB
	$server = "mongodb://127.0.0.1:3001";
	$connection = new Mongo($server);
	$db = $connection->meteor;
	$collection = $db->data;
    $collection_backup = $db->backup;
    $dir_to_save = "gifFrame/";
    $head_name = explode(".", $target_file);
    $new_name = $head_name[0];

    // check the type of file is gif or not
    if(!is_dir($dir_to_save)) mkdir($dir_to_save);
	$picture = new Imagick();
    $picture->readimage($target_file);
	$i=0;
    $path_array = [];
    $img_byte_array = [];
    $img_backup = [];
   	foreach($picture as $frame){
        $frame->setImageAlphaChannel(11);
        $frame->setImageBackgroundColor('white');
        $frame->setImageFormat("jpg");
        $f=$new_name.$i.'.jpg';
        $frame->stripImage();
        $frame->writeImage($dir_to_save.$f);
        $path_array[$i] = $dir_to_save.$f;
    	$i++;
    }
    $de_index = 0;
    // Now begin the decoding of each frame and save it into mongo collection
    for($j = 0; $j<$i; $j++){
        $img_collection = imagecreatefromjpeg($path_array[$j]);
        $img_width = imagesx($img_collection);
        $img_height = imagesy($img_collection);
        echo "<br>";
        for($y = 0;$y < $img_height;$y++){
            for($x = 0;$x < $img_width;$x++){
                $rgb = imagecolorat($img_collection, $x, $y);
                $r = ($rgb >> 16) & 0xFF;
                $g = ($rgb >> 8) & 0xFF;
                $b = $rgb & 0xFF;
                $temp= ($r&224 | ($g&224)>>3 | ($b&192)>>6);
                // echo(gettype($rgb));
                $img_byte_array[$de_index] = $temp;
                $img_backup[$de_index] = $temp;
                $de_index++;
            }
        }
    }

    // Now destroy the upload files
    // First the gif file 
    unlink($target_file);
    // Then the jpg frames that stores in the path_array
    $len = count($path_array);
    for($i=0;$i<$len;$i++){
        unlink($path_array[$i]);
    }
    
    if(!is_null($img_byte_array)){
        echo "the data array is not null and the size of the array is: " . count($img_byte_array);
        echo "<br>"; 
        $insert_data = array('_id' => (string)($collection->count()), 'format'=>$imageFileType, 'data'=>$img_byte_array);
        $insert_backup = array('_id'=> (string)($collection->count()), 'data'=>$img_backup);
        $collection->insert($insert_data);
        $collection_backup->insert($insert_backup);
        echo($collection->count());
        echo "<br>";
        echo($collection_backup->count());
    }

?>
