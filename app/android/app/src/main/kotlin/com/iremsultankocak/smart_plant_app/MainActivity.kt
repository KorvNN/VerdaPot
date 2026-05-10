package com.iremsultankocak.smart_plant_app

import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        // Android 11+ : ekrandaki tüm display mode'ları tara, en yüksek
        // refresh rate'i (örn. 90/120/144Hz) seç. Eski cihazlarda no-op.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val display = display ?: return
            val highest = display.supportedModes.maxByOrNull { it.refreshRate } ?: return
            val attrs = window.attributes
            attrs.preferredDisplayModeId = highest.modeId
            window.attributes = attrs
        }
    }
}
