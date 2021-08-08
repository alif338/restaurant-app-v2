package com.example.restaurant_app

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "toast.flutter.io/toast";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "showToastShort" -> {
                    val toast = Toast.makeText(context, "${call.arguments}", Toast.LENGTH_SHORT)
                    toast.show()
                }
                "showToastLong" -> {
                    val toast = Toast.makeText(context, "${call.arguments}", Toast.LENGTH_LONG)
                    toast.show()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
