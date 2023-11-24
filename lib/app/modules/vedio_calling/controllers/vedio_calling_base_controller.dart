// ignore_for_file: cancel_subscriptions
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VedioCallingBaseController extends GetxController {

  late final WebSocketChannel? websocket;
  late final Future<bool>     isDataLoaded;

  Position?                   currentLocation;

  late MethodChannel          applicationchannel;
  late EventChannel           exitbuttonclickevent;
  late EventChannel           videobuttonstatusevent;
  late EventChannel           micbuttonstatusevent;
  late EventChannel           joinmeetingstatusevent;
  late EventChannel           exitstatusevent;

  late StreamSubscription     streamSubscription;
  late StreamSubscription     videostreamSubscription;
  late StreamSubscription     micstreamSubscription;
  late StreamSubscription     joinmeetingstreamSubscription;

  
  bool _isVedioStreaming      = false;
  bool _isVedioMuted          = false;
  bool _isAudioMuted          = false;
  bool _istoggleCamera        = false;

  bool get isVedioStreaming => _isVedioStreaming;
  set isVedioStreaming(bool v) => {_isVedioStreaming = v, update()};

  bool get isVedioMuted => _isVedioMuted;
  set isVedioMuted(bool v) => {_isVedioMuted = v, update()};

  bool get isAudioMuted => _isAudioMuted;
  set isAudioMuted(bool v) => {_isAudioMuted = v, update()};

  bool get istoggleCamera => _istoggleCamera;
  set istoggleCamera(bool v) => {_istoggleCamera = v, update()};
}
