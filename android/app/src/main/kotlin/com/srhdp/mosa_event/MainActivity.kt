package com.srhdp.mosa_event

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import com.wortise.ads.flutter.natives.GoogleNativeAdManager

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
         GoogleMobileAdsPlugin.registerNativeAdFactory(
                 flutterEngine, "listTile", ListTileNativeAdFactory(context))

        GoogleNativeAdManager.registerAdFactory(
            "test-factory", NativeAdFactoryExample(layoutInflater))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
         GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")

        GoogleNativeAdManager.unregisterAdFactory("test-factory")
    }
}
