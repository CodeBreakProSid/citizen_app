package org.citizen.janamaithri.platform

import org.citizen.janamaithri.platform.TSTRemoteVideoView
import io.flutter.embedding.engine.plugins.FlutterPlugin


/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Clifford P Y  e-mail - <clifford@techgentsia.com> ,  Aug 2022
 */

class PlatformViewPlugin: FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding
            .platformViewRegistry
            .registerViewFactory(TSTVideoView.TAG, NativeViewFactory())
        binding
            .platformViewRegistry
            .registerViewFactory(TSTRemoteVideoView.TAG, NativeViewFactory())

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}