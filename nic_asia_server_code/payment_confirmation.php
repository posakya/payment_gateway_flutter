<?php include 'security.php';

$transaction_type = $_GET["transaction_type"] ?? "sale";
$amount = $_GET["amount"];
$bill_to_forename = $_GET["bill_to_forename"] ?? "Kab";
$bill_to_surname = $_GET["bill_to_surname"] ?? "Mart";
$bill_to_email = $_GET["bill_to_email"] ?? "kabmart@gmail.com";
$bill_to_phone = $_GET["bill_to_phone"] ?? "9860306332";
$bill_to_address_city = $_GET["bill_to_address_city"] ?? "Kathmandu";
$bill_to_address_line1 = $_GET["bill_to_address_line1"] ?? "Sankhamul";
$bill_to_address_country = $_GET["bill_to_address_country"] ?? "NP";
$bill_to_address_postal_code = $_GET["bill_to_address_postal_code"] ?? "43600";

$params = [
    'access_key' => '5aa3a7845d35324f851858de58ac8c73',
    'profile_id' => '7C6DE62A-341F-48D0-8297-850600624162',
    'transaction_uuid'   => uniqid(),
    'signed_field_names' => 'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method,bill_to_forename,bill_to_surname,bill_to_address_line1,bill_to_address_city,bill_to_phone,bill_to_address_country,bill_to_email,bill_to_address_postal_code',
    'unsigned_field_names' => '',
    'signed_date_time' => gmdate("Y-m-d\TH:i:s\Z"),
    'locale' => 'en',
    'transaction_type' => $transaction_type,
    'reference_number' => rand(1000000000000,9999999999999),
    'amount' => $amount,
    'currency' => 'NPR',
    'payment_method' => 'card',
    'bill_to_forename' => $bill_to_forename,
    'bill_to_surname' => $bill_to_surname,
    'bill_to_email' => $bill_to_email,
    'bill_to_phone' => $bill_to_phone,
    'bill_to_address_city' => $bill_to_address_city,
    'bill_to_address_line1' => $bill_to_address_line1,
    'bill_to_address_country' => $bill_to_address_country,
    'bill_to_address_postal_code' => $bill_to_address_postal_code,
    
    ];

    // print_r($params);
    // die();

?>

<html>
<head>
    <title>Secure Acceptance - Payment Form Example</title>
    <link rel="stylesheet" type="text/css" href="payment.css"/>
</head>
<body>
<form id="payment_confirmation" action="https://testsecureacceptance.cybersource.com/pay" method="post"/>


    <?php
        foreach($params as $name => $value) {
            echo "<input type=\"hidden\"  id=\"" . $name . "\" name=\"" . $name . "\" value=\"" . $value . "\"/>\n";
        }
        echo "<input   id=\"signature\" type=\"hidden\" name=\"signature\" value=\"" . sign($params) . "\"/>\n";
        //  echo "<input  type=\"submit\" value=\"submit\" />";
        // print_r($params);
        //  print_r(sign($params));
    // die();
    ?>

</form>
<script type="text/javascript">
// setTimeout(function() {   //calls click event after a certain time
//  document.getElementById('payment_confirmation').submit(); 
// }, 3000);
    document.getElementById('payment_confirmation').submit(); // SUBMIT FORM
</script>
</body>
</html>
