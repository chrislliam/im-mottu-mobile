package com.mottu.marvel.im_mottu_mobile

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "com.mottu.marvel.im_mottu_mobile/connectivity/status"
  
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            NetworkInfoEventChannel(this.applicationContext)
        )
    }
    
}
