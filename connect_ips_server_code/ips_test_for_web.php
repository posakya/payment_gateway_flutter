<?php
 $string = "MERCHANTID=569,APPID=MER-569-APP-1,APPNAME=Job Pauchha,TXNID=663760,TXNDATE=25-01-2022,TXNCRNCY=NPR,TXNAMT=1000,REFERENCEID=REF-663760,REMARKS=RMKS-663760,PARTICULARS=PART-663760,TOKEN=TOKEN";

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
    return $hash;
}

// echo '<form
// action="https://esewa.com.np/epay/main"
// method="POST"
// >
// <input value="1" name="tAmt" type="hidden" />
// <input value="1" name="amt" type="hidden" />
// <input value="0" name="txAmt" type="hidden" />
// <input value="0" name="psc" type="hidden" />
// <input value="0" name="pdc" type="hidden" />
// <input value="NP-ES-JOB" name="scd" type="hidden" />
// <input
//   value="1234321"
//   name="pid"
//   type="hidden"
// />
// <input
//   value="https://jobpauchha.com/esewa/esewa_payment_success.php"
//   type="hidden"
//   name="su"
// />
// <input
//   value="https://jobpauchha.com/esewa/esewa_payment_failed.php"
//   type="hidden"
//   name="fu"
// />
// <input
//   value="Join Now"
//   type="submit"
// />
// </form>'

echo '<form action="https://uat.connectips.com:7443/connectipswebgw/loginpage" method="post"> <br> 
    MERCHANT ID 
    <input type="text" name="MERCHANTID" id="MERCHANTID" value="569"/> 
    <br> 
    APP ID 
    <input type="text" name="APPID" id="APPID" value="MER-569-APP-1"/> 
    <br> 
    APP NAME 
    <input type="text" name="APPNAME" id="APPNAME" value="Job Pauchha"/> <br> 
    TXN ID 
    <input type="text" name="TXNID" id="TXNID" value="663760"/> 
    <br> 
    TXN DATE 
    <input type="text" name="TXNDATE" id="TXNDATE" value="25-01-2022"/> 
    <br>
    TXN CRNCY 
    <input type="text" name="TXNCRNCY" id="TXNCRNCY" value="NPR"/> 
    <br> 
    TXN AMT 
    <input type="text" name="TXNAMT" id="TXNAMT" value="1000"/> 
    <br> 
    REFERENCE ID 
    <input type="text" name="REFERENCEID" id="REFERENCEID" value="REF-663760"/> <br> 
    REMARKS 
    <input type="text" name="REMARKS" id="REMARKS" value="RMKS-663760"/> 
    <br> 
    PARTICULARS 
    <input type="text" name="PARTICULARS" id="PARTICULARS" value="PART-663760"/> <br> 
    TOKEN 
    <input type="text" name="TOKEN" id="TOKEN" value="tuOu4esWeVqoEYNdt+ULKy44nB2tjs0WisSOqpkv6O1Wi8GP/+UmI9BzmB6OKbWdK6TY6zlLqqyTjkqVWBpDvhTE69IwpPmjPL3Tcw11QhzswKpjRGQqfuZyk8QDMZOOBwm1SVFsrYdB8ComHpFN+Gsu+Rrp61Bhn/kPAX9F3s8="/> 
    <br> 
     <input type="submit" value="Submit"> 
    </form>'; 
    

?>