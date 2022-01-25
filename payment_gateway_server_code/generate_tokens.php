<?php
$string = $_GET["name"];
echo(generateHash($string));

function generateHash($string) {
    $cert_file = getcwd() . "/CREDITOR.pfx";  // file location
    // Try to locate certificate file
    if (!$cert_store = file_get_contents($cert_file)) {
        echo "Error: Unable to read the cert file\n";
        exit;
    }
    // Try to read certificate file
    if (openssl_pkcs12_read($cert_store, $cert_info, "123")) {
        if($private_key = openssl_pkey_get_private($cert_info['pkey'])){
            $array = openssl_pkey_get_details($private_key);
            // print_r($array);
        }
    } else {
        echo "Error: Unable to read the cert store.\n";
        exit;
    }
    $hash = "";
    if(openssl_sign($string, $signature , $private_key, "sha256WithRSAEncryption")){
        $hash = base64_encode($signature);
        openssl_free_key($private_key);
    } else {
        echo "Error: Unable openssl_sign";
        exit;
    }    
    
    header('Access-Control-Allow-Origin: *');
    header('Content-type: application/json');
        $response = array();
        $response = array(
            'token' => $hash
        );
    
    echo json_encode($response); 
}
?>