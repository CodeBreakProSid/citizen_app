package org.citizen.janamaithri.platform

import android.content.Context
import org.citizen.janamaithri.platform.TSTVideoView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */class NativeRemoteViewFactory: PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    var tstVideoView: TSTRemoteVideoView? = null
    fun getTSTVideoView(): TSTRemoteVideoView?{
        return tstVideoView
    }
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        tstVideoView = TSTRemoteVideoView(context, viewId, creationParams)

        print("configureFlutterEngine 2 $viewId   view $tstVideoView")
        return tstVideoView!!
    }



}