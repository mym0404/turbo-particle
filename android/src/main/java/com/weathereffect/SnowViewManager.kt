package com.weathereffect

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SnowViewManagerDelegate
import com.facebook.react.viewmanagers.SnowViewManagerInterface

@ReactModule(name = SnowViewManager.NAME)
class SnowViewManager :
  SimpleViewManager<SnowView>(),
  SnowViewManagerInterface<SnowView> {
  private val mDelegate: ViewManagerDelegate<SnowView>

  init {
    mDelegate = SnowViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<SnowView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): SnowView {
    return SnowView(context)
  }

  @ReactProp(name = "speed")
  override fun setSpeed(
    view: SnowView?,
    value: Double,
  ) {
  }

  companion object {
    const val NAME = "SnowView"
  }
}
