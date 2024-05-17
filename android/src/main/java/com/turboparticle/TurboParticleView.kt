package com.turboparticle

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PorterDuff
import android.util.AttributeSet
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.ViewGroup.LayoutParams
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.FrameLayout
import androidx.annotation.ColorInt
import androidx.annotation.Dimension
import java.util.Timer
import java.util.TimerTask
import kotlin.random.Random

internal data class Particle(
  var radius: Float,
  var x: Float,
  var y: Float,
  var vx: Int,
  var vy: Int,
  var alpha: Int,
)

class TurboParticleView
  @JvmOverloads
  constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
  ) : FrameLayout(context, attrs, defStyleAttr) {
    init {
      addView(
        ParticleView(context).apply {
          layoutParams = LayoutParams(MATCH_PARENT, MATCH_PARENT)
        },
      )
    }
  }

class ParticleView
  @JvmOverloads
  constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
  ) : SurfaceView(context, attrs, defStyleAttr), SurfaceHolder.Callback {
    private val particles = mutableListOf<Particle>()
    private var surfaceViewThread: SurfaceViewThread? = null
    private var hasSurface: Boolean = false
    private var hasSetup = false

    private val path = Path()

    // Attribute Defaults
    private var _particleCount = 5000

    @Dimension
    private var _particleMinRadius = 10

    @Dimension
    private var _particleMaxRadius = 16

    @ColorInt
    private var _particleColor = Color.WHITE

    // Core Attributes
    var particleCount: Int
      get() = _particleCount
      set(value) {
        _particleCount =
          when {
            value > 50 -> 50
            value < 0 -> 0
            else -> value
          }
      }

    var particleMinRadius: Int
      @Dimension get() = _particleMinRadius
      set(
      @Dimension value
      ) {
        _particleMinRadius =
          when {
            value <= 0 -> 1
            value >= particleMaxRadius -> 1
            else -> value
          }
      }

    var particleMaxRadius: Int
      @Dimension get() = _particleMaxRadius
      set(
      @Dimension value
      ) {
        _particleMaxRadius =
          when {
            value <= particleMinRadius -> particleMinRadius + 1
            else -> value
          }
      }

    var particleColor: Int
      @ColorInt get() = _particleColor
      set(
      @ColorInt value
      ) {
        _particleColor = value
        particlePaint.color = value
      }

    // Paints
    private val particlePaint: Paint =
      Paint().apply {
        isAntiAlias = true
        style = Paint.Style.FILL
        strokeWidth = 2F
        color = particleColor
      }

    init {
      if (holder != null) holder.addCallback(this)
      hasSurface = false
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
      hasSurface = true

      if (surfaceViewThread == null) {
        surfaceViewThread = SurfaceViewThread()
      }

      surfaceViewThread?.start()
      Timer().schedule(
        object : TimerTask() {
          override fun run() {
            resume()
          }
        },
        5000L,
      )
      resume()
    }

    fun resume() {
      if (surfaceViewThread == null) {
        surfaceViewThread = SurfaceViewThread()

        if (hasSurface) {
          surfaceViewThread?.start()
        }
      }
    }

    fun pause() {
      surfaceViewThread?.requestExitAndWait()
      surfaceViewThread = null
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
      hasSurface = false
      surfaceViewThread?.requestExitAndWait()
      surfaceViewThread = null
    }

    override fun surfaceChanged(
      holder: SurfaceHolder,
      format: Int,
      w: Int,
      h: Int,
    ) {
      // ignored
    }

    private fun setupParticles() {
      if (!hasSetup) {
        hasSetup = true
        particles.clear()
        for (i in 0 until particleCount) {
          particles.add(
            Particle(
              Random.nextInt(particleMinRadius, particleMaxRadius).toFloat(),
              Random.nextInt(0, width).toFloat(),
              Random.nextInt(0, height).toFloat(),
              Random.nextInt(-2, 2),
              Random.nextInt(-2, 2),
              Random.nextInt(150, 255),
            ),
          )
        }
      }
    }

    private inner class SurfaceViewThread : Thread() {
      private var running = true
      private var canvas: Canvas? = null

      override fun run() {
        setupParticles()

        while (running) {
          try {
            canvas = holder.lockCanvas()

            synchronized(holder) {
              // Clear screen every frame
              canvas?.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)

              for (i in 0 until particleCount) {
                particles[i].x += particles[i].vx
                particles[i].y += particles[i].vy

                if (particles[i].x < 0) {
                  particles[i].x = width.toFloat()
                } else if (particles[i].x > width) {
                  particles[i].x = 0F
                }

                if (particles[i].y < 0) {
                  particles[i].y = height.toFloat()
                } else if (particles[i].y > height) {
                  particles[i].y = 0F
                }

                particlePaint.alpha = particles[i].alpha
                canvas?.drawCircle(particles[i].x, particles[i].y, particles[i].radius, particlePaint)
              }
            }
          } catch (e: Exception) {
            e.printStackTrace()
          } finally {
            if (canvas != null) {
              holder.unlockCanvasAndPost(canvas)
            }
          }
        }
      }

      fun requestExitAndWait() {
        running = false

        try {
          join()
        } catch (e: InterruptedException) {
          // ignored
        }
      }
    }
  }
