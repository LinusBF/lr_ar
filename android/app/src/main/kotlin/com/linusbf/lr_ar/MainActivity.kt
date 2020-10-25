package com.linusbf.lr_ar

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.atan

class MainActivity: FlutterActivity() {
    private val CHANNEL = "lr_ar.linusbf.com/wrapped"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getCameraFOV") {
                val args = call.arguments as Map<String, Int>
                val cameraDetails : CameraCharacteristics =args["cameraId"]?.let {getCameraDetails(it)}!!
                val FOVx : Float = getWidthFOV(cameraDetails)
                val FOVy : Float = getHeightFOV(cameraDetails)
                result.success("{\"x\":$FOVx, \"y\": $FOVy}")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCameraDetails(cameraId: Int): CameraCharacteristics? {
        val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        if (cameraManager.cameraIdList.isEmpty()) {
            // no cameras
            return null
        }
        val wantedCamera = cameraManager.cameraIdList[cameraId]
        return cameraManager.getCameraCharacteristics(wantedCamera)
    }

    private fun getWidthFOV(cameraDetails : CameraCharacteristics): Float {
        val physicalSize = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)!!
        val activeArray = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_ACTIVE_ARRAY_SIZE)!!
        val pixelArray = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)!!
        val focalLength = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)!!
        val outputWidth = physicalSize.width * activeArray.width() / pixelArray.width
        return 2 * atan(outputWidth / (2 * focalLength.width))
    }

    private fun getHeightFOV(cameraDetails : CameraCharacteristics): Float {
        val physicalSize = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)!!
        val activeArray = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_ACTIVE_ARRAY_SIZE)!!
        val pixelArray = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)!!
        val focalLength = cameraDetails.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)!!
        val outputHeight = physicalSize.height * activeArray.height() / pixelArray.height
        return 2 * atan(outputHeight / (2 * focalLength.height))
    }
}
