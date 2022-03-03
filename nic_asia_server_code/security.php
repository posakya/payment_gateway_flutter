<?php

define ('HMAC_SHA256', 'sha256');
define ('SECRET_KEY', '9c127b44a72740ceb5edc672263c3cd621e865d8ef374930aa1aa14cfbb9b1c6df0ff59477544ec28ec8c353e8d2b5a46b095d55848c4d03a5e361b3ddb7b62c00579fa737ff45e2b666399c3693204b296417145f3f4889a62e91fa680337745fce8c9b73044568bf647dc65035e1251b19e75706974455a4cc38ad7da31ab6');

function sign ($params) {
  return signData(buildDataToSign($params), SECRET_KEY);
}

function signData($data, $secretKey) {
    return base64_encode(hash_hmac('sha256', $data, $secretKey, true));
}

function buildDataToSign($params) {
        $signedFieldNames = explode(",",$params["signed_field_names"]);
        foreach ($signedFieldNames as $field) {
           $dataToSign[] = $field . "=" . $params[$field];
        }
        return commaSeparate($dataToSign);
}

function commaSeparate ($dataToSign) {
    return implode(",",$dataToSign);
}

?>
