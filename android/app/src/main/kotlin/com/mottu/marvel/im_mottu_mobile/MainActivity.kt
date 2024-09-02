package com.mottu.marvel.im_mottu_mobile

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    
    private val EVENT_CHANNEL = "com.mottu.marvel.im_mottu_mobile/connectivity/event"
    private val METHOD_CHANNEL = "com.mottu.marvel.im_mottu_mobile/connectivity/method" 
      
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            NetworkInfoEventChannel(this.applicationContext)
        )
      
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            NetworkInfoMethodChannel(this.applicationContext).onMethodCall(call, result)
        }
    }
    
}
