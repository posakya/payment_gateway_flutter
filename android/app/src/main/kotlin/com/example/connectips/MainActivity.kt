package com.example.connectips

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.esewa.android.sdk.payment.ESewaConfiguration
import com.esewa.android.sdk.payment.ESewaPayment
import com.esewa.android.sdk.payment.ESewaPaymentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.app.codekarkhana/androidEsewa"
    private var results = ""
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "androidesewa"){
                pendingResult = null
                val eSewaConfiguration: ESewaConfiguration = ESewaConfiguration()
                    .clientId("JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R")
                    .secretKey("BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==")
                    .environment(ESewaConfiguration.ENVIRONMENT_TEST)
                val amount = call.argument<String>("amount")
                val productId = call.argument<String>("productId")
                val productName = call.argument<String>("productName")

                val eSewaPayment = ESewaPayment(amount,
                    productName, productId, "https://codekarkhana.com")

                val intent = Intent(this, ESewaPaymentActivity::class.java)
                intent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration)

                intent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment)
                startActivityForResult(intent, 1011)
                pendingResult = result
                if(results != ""){
                    result.success(results)
                }

//                result.success("Hello from kotlin")
            }
            // Note: this method is invoked on the main thread.
            // TODO
        }
    }



    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1011) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val s = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
//                    CHANNEL.invokeMethod("callBack", "data1")
                    Log.i("Proof of Payment", s.toString())
                    pendingResult?.success("Success")
//                    results = "Success"
                    Toast.makeText(this, "SUCCESSFUL PAYMENT", Toast.LENGTH_SHORT).show()
                }
                Activity.RESULT_CANCELED -> {
                    results = "Cancelled"
                    pendingResult?.success("Cancel")
                    Toast.makeText(this, "Cancelled By User", Toast.LENGTH_SHORT).show()
                }
                ESewaPayment.RESULT_EXTRAS_INVALID -> {
                    results = "Failed payment"
                    pendingResult?.success("Failed Payment")
                    val s = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                    Log.i("Proof of Payment", s.toString())
                }
            }
        }
    }

}
