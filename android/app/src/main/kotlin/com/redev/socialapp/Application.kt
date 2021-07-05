package com.redev.socialapp

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
// import io.flutter.view.FlutterMain
// import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
// import io.flutter.embedding.android.FlutterActivity;
class Application : FlutterApplication(),PluginRegistrantCallback{

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
        // FlutterMain.startInitialization(this)
        FlutterLoader().startInitialization(this)
        
    }
    override fun registerWith(registry: PluginRegistry?) {
    }
}
