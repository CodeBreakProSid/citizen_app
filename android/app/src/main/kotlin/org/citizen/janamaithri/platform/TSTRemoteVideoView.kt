package org.citizen.janamaithri.platform

import android.content.Context
import android.graphics.Color
import android.view.View
import io.flutter.plugin.platform.PlatformView
import org.webrtc.SurfaceViewRenderer

/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */
class TSTRemoteVideoView(context: Context?, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    companion object{
        public const val TAG = "TSTRemoteVideoView"
    }
    val context = context
    val id = id
    val creationParams = creationParams

    val videoView: SurfaceViewRenderer
    override fun getView(): View? {
        print("Id of video view 2 : $id ")
        return videoView
    }

    init {
        videoView = SurfaceViewRenderer(context)
        videoView.setBackgroundColor(Color.TRANSPARENT)
        print("Id of video view 2 : ${videoView.id}")
    }

    override fun dispose() {
        videoView.clearImage();
    }
}