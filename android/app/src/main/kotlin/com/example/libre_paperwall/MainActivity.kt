package com.example.libre_paperwall

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.MediaScannerConnection
import android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.libre_paperwall/media"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            context,
                            arrayOf(path),
                            null
                        ) { _, _ -> 
                            result.success(null)
                        }
                    } else {
                        result.error("INVALID_PATH", "Path cannot be null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
