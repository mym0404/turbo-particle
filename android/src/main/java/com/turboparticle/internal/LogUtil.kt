package com.turboparticle.internal

import android.util.Log
import com.turboparticle.BuildConfig

private fun debugE(
  tag: String,
  message: Any?,
) {
  if (BuildConfig.DEBUG) Log.e(tag, "⭐️" + message.toString())
}

internal fun debugE(vararg message: Any?) {
  var str = ""
  for (i in message) {
    str += i.toString() + ", "
  }
  debugE("RNCNaverMapView", str)
}
