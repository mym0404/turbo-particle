package com.weathereffect

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.WeatherEffectViewManagerInterface
import com.facebook.react.viewmanagers.WeatherEffectViewManagerDelegate

@ReactModule(name = WeatherEffectViewManager.NAME)
class WeatherEffectViewManager : SimpleViewManager<WeatherEffectView>(),
  WeatherEffectViewManagerInterface<WeatherEffectView> {
  private val mDelegate: ViewManagerDelegate<WeatherEffectView>

  init {
    mDelegate = WeatherEffectViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<WeatherEffectView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): WeatherEffectView {
    return WeatherEffectView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: WeatherEffectView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "WeatherEffectView"
  }
}
