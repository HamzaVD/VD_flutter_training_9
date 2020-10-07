package com.example.platformchannel

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.annotation.RequiresApi
import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.test/test"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler(
                object : MethodCallHandler {
                    @Suppress("DEPRECATION")
                    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//                        when (call.method) {
//                            "changeLife" -> result.success(sendResult(call))
//                            else -> result.notImplemented()
//                        }
                        when (call.method){
                            "vibrate"-> {
                                val message = "Vibrated device for 2500ms"
                                val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    vibrator.vibrate(VibrationEffect.createOneShot(2500, VibrationEffect.DEFAULT_AMPLITUDE))
                                } else {
                                    vibrator.vibrate(2500)
                                }
                            }
                        }
//                        if (call.method.equals("vibrate")) {
//                            val message = "Vibrated device for 2500ms"
//                            val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
//                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                                vibrator.vibrate(VibrationEffect.createOneShot(2500, VibrationEffect.DEFAULT_AMPLITUDE))
//                            } else {
//                                vibrator.vibrate(2500)
//                            }
//                            return result.success(message)
//                        }

                    }
                }
        )
    }




    private fun sendResult(call: MethodCall): String {
        return "Vibrated successfully";
    }
}
