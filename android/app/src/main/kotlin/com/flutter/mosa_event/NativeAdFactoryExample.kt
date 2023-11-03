package com.srhdp.mosa_event

import android.view.LayoutInflater
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.makeramen.roundedimageview.RoundedImageView
import com.wortise.ads.flutter.natives.GoogleNativeAdFactory

class NativeAdFactoryExample(private val layoutInflater: LayoutInflater) : GoogleNativeAdFactory {

    override fun createNativeAd(nativeAd: NativeAd): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.my_native_ad, null) as NativeAdView

        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        val iconView = adView.findViewById<RoundedImageView>(R.id.iv_list_tile_native_ad_icon)
        val icon = nativeAd.icon
        if (icon != null) {
            iconView.setImageDrawable(icon.drawable)
        }

        headlineView.setText(nativeAd.headline)

        bodyView.setText(nativeAd.body)

        // adView.setBackgroundColor(Color.YELLOW)
        adView.setNativeAd(nativeAd)
        adView.setBodyView(bodyView)
        adView.setHeadlineView(headlineView)

        return adView
    }
}