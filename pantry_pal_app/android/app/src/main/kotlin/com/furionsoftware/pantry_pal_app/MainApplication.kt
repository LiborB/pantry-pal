import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService

class MainApplication : FlutterApplication(), PluginRegistrantCallback {
    // ...
    fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
    }

    fun registerWith(registry: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(registry)
    } // ...
}