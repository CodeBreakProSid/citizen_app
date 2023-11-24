package org.citizen.janamaithri.platform

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Clifford P Y  e-mail - <clifford@techgentsia.com> ,  Aug 2022
 */

class NativeViewFactory: PlatformViewFactory(StandardMessageCodec.INSTANCE) {
     var tstVideoView: TSTVideoView? = null
    fun getTSTVideoView():TSTVideoView?{
        return tstVideoView
    }
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        tstVideoView = TSTVideoView(context, viewId, creationParams)

        print("configureFlutterEngine 2 $viewId   view $tstVideoView")
        return tstVideoView!!
    }



}