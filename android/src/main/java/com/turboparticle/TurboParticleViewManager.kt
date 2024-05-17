package com.turboparticle

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.TurboParticleViewManagerDelegate
import com.facebook.react.viewmanagers.TurboParticleViewManagerInterface

@ReactModule(name = TurboParticleViewManager.NAME)
class TurboParticleViewManager :
  SimpleViewManager<TurboParticleView>(), TurboParticleViewManagerInterface<TurboParticleView> {
  private val mDelegate: ViewManagerDelegate<TurboParticleView>

  init {
    mDelegate = TurboParticleViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<TurboParticleView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): TurboParticleView {
    return TurboParticleView(context)
  }

  @ReactProp(name = "speed")
  override fun setSpeed(
    view: TurboParticleView?,
    value: Double,
  ) {
  }

  companion object {
    const val NAME = "TurboParticleView"
  }
}
