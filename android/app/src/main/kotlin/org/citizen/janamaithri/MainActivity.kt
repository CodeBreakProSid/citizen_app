package org.citizen.janamaithri

import android.Manifest
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.IBinder
import android.os.PersistableBundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import org.citizen.janamaithri.platform.NativeViewFactory
import org.citizen.janamaithri.platform.TSTVideoView
import com.tst.core.breakout.data.BreakoutRoomEnd
import com.tst.core.breakout.data.BreakoutRoomInfo
import com.tst.core.core.ConferenceManager
import com.tst.core.entity.data.*
import com.tst.core.entity.params.ViewParams
import org.citizen.janamaithri.Utilities.*
import org.citizen.janamaithri.entity.JoinParamsToServer
import org.citizen.janamaithri.entity.RoomParams
import org.citizen.janamaithri.platform.NativeRemoteViewFactory
import org.citizen.janamaithri.platform.TSTRemoteVideoView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class MainActivity : FlutterActivity(), MeetingEvents {
    private val TAG = "MainActivity"
    lateinit var meetingid: String
    lateinit var name: String
    lateinit var password: String

    private lateinit var joinEventSink: EventSink
    private lateinit var joinMeetingSink: EventSink
    private lateinit var videoStatusSink: EventSink
    private lateinit var micStatusSink: EventSink
    private lateinit var handRaiseStatusSink: EventSink
    private lateinit var exitEventSink: EventSink

    private val MIC_RECORD_REQUEST_CODE = 101
    private val CAMERA_RECORD_REQUEST_CODE = 102

    private var conferenceManager: ConferenceManager? = null
    private var isVideoEnabled = true
    private var isMicEnabled = true
    private var isHandRaised = false

    var viewFactory: NativeViewFactory? = null
    var viewRemoteFactory: NativeRemoteViewFactory? = null

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun onResume() {
        super.onResume()
        if (conferenceManager != null) {
            val viewParams = ViewParams()
            viewParams.fullscreenVideo = viewRemoteFactory?.getTSTVideoView()?.videoView
            viewParams.smallVideo = viewFactory?.getTSTVideoView()?.videoView
            conferenceManager!!.onAppResumes(viewParams)
        }
    }

    override fun onPause() {
        if (conferenceManager != null) {
            conferenceManager!!.onAppPause()
        }
        super.onPause()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        viewFactory = NativeViewFactory()
        viewRemoteFactory = NativeRemoteViewFactory()
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(TSTVideoView.TAG, viewFactory!!)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(TSTRemoteVideoView.TAG, viewRemoteFactory!!)
        initializeEventChannels(flutterEngine)
        initializeMethodChannels(flutterEngine)
        setupPermissions()
    }

    private fun initializeMethodChannels(flutterEngine: FlutterEngine) {
        var channel: MethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Methods.METHOD_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                Methods.START_MEETING_SERVICE -> {
                    val resultMessage = "Service Started " + name
                    startMeetingForegroundService()
                    result.success(resultMessage)
                }
                Methods.CALL_JOIN_API -> {
                    val arguments = call.arguments() as Map<String, String>?
                    meetingid = arguments?.get("meetingid").toString()
                    name = arguments?.get("name").toString()
                    password = arguments?.get("password").toString()
                    val joinParamsToServer = JoinParamsToServer(meetingid, name, password)
                    val apiInterface = getRetrofit().create(ApiInterface::class.java)
                    GlobalScope.launch {
                        val result = apiInterface.join(meetingid, joinParamsToServer)
                        runOnUiThread() {
                            if (result != null) {
                                try {
                                    val meetingDataFromServer = result.body()
                                    val roomParamsData =
                                        Utilities.createRoomParamsForMeeting(meetingDataFromServer)
                                    roomParams = roomParamsData
                                    joinEventSink.success(true)
                                } catch (e: Exception) {
                                    joinEventSink.success(false)
                                }
                            } else {
                                joinEventSink.success(false)
                            }
                        }
                    }
                    result.success(true)
                }
                Methods.JOIN_MEETING -> {
                    val arguments = call.arguments() as Map<String, String>?
                    var token = arguments?.get("token").toString()
                    var expiryInSec = arguments?.get("expiryInSec").toString()
                    var meetingID = arguments?.get("meetingID").toString()
                    var title = arguments?.get("title").toString()
                    var role = arguments?.get("role").toString()
                    var type = arguments?.get("type").toString()
                    var bearerToken = "Bearer " + token

                    val apiInterface = getRetrofit().create(ApiInterface::class.java)
                    GlobalScope.launch {
                        val result = apiInterface.getMeetingParams(bearerToken, meetingID)
                        runOnUiThread() {
                            if (result != null) {
                                try {
                                    val meetingDataFromServer = result.body()
                                    val roomParamsData =
                                        Utilities.createRoomParamsForMeeting(meetingDataFromServer)
                                    roomParams = roomParamsData
                                    val connection = object : ServiceConnection {
                                        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                                            serviceBound = true
                                            binder = service as MeetingService.LocalBinder
                                            meetingService = binder!!.getService()
                                            meetingService.registerMeetingEvents(this@MainActivity)
                                            meetingService.initMeetingRoom(roomParams!!)
                                        }

                                        override fun onServiceDisconnected(name: ComponentName?) {
                                            serviceBound = false
                                            Log.e(TAG, "onServiceDisconnected: ")
                                        }

                                    }
                                    joinMeetingSink.success(true)
                                    startMeetingForegroundService()
                                } catch (e: Exception) {
                                   joinMeetingSink.success(false)
                                   Log.e(TAG, "calling Exception")
                                }
                            } else {
                               joinMeetingSink.success(false)
                            }
                        }
                    }
                    result.success(true)
                }
                Methods.VIDEO_MUTE_UNMUTE -> {
                    isVideoEnabled = !isVideoEnabled
                    conferenceManager!!.enableVideo(isVideoEnabled)
                    videoStatusSink.success(isVideoEnabled)
                }
                Methods.MIC_MUTE_UNMUTE -> {
                    isMicEnabled = !isMicEnabled
                    conferenceManager!!.enableAudio(isMicEnabled)
                    micStatusSink.success(isMicEnabled)
                }
                Methods.HAND_RAISE_DOWN -> {
                    isHandRaised = !isHandRaised
                    conferenceManager!!.raiseHand(isHandRaised)
                    handRaiseStatusSink.success(isHandRaised)
                }
                Methods.EXIT_MEETING -> {
                    val arguments = call.arguments() as Map<String, String>?
                    var exitcode = arguments?.get("exitcode").toString()
                    if (roomParams!!.role == Constants.ROLE_MODERATOR) {
                        handleExit(Constants.EXIT_TYPE_REMOVEALL)
                    } else {
                        handleExit(Constants.EXIT_TYPE_NORMAL)
                    }
                }
                Methods.TOGGLE_CAMERA -> {
                    conferenceManager!!.toggleCamera()
                }

            }
        }
    }

    private fun initializeEventChannels(flutterEngine: FlutterEngine) {
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.JOIN_API_RESULT_EVENT
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    joinEventSink = events
                }
            }
            override fun onCancel(args: Any?) {}
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.JOIN_MEETING
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    joinMeetingSink = events
                }
            }
            override fun onCancel(args: Any?) {}
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.VIDEO_STATUS
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    videoStatusSink = events
                }
            }
            override fun onCancel(args: Any?) {}
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.MIC_STATUS
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    micStatusSink = events
                }
            }
            override fun onCancel(args: Any?) {}
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.HAND_RAISE_STATUS
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    handRaiseStatusSink = events
                }
            }
            override fun onCancel(args: Any?) {}
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Events.ON_EXITED
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventSink?) {
                if (events != null) {
                    exitEventSink = events
                }
            }

            override fun onCancel(args: Any?) {}
        })
    }

    private fun setupPermissions() {
        val micPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        )
        val cameraPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.CAMERA
        )
        if (micPermission != PackageManager.PERMISSION_GRANTED) {
            makeMicPermissionRequest()
        } else if (cameraPermission != PackageManager.PERMISSION_GRANTED) {
            makeCameraPermissionRequest()
        }
    }

    private fun makeMicPermissionRequest() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            MIC_RECORD_REQUEST_CODE
        )
    }

    private fun makeCameraPermissionRequest() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.CAMERA),
            CAMERA_RECORD_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>, grantResults: IntArray
    ) {
        when (requestCode) {
            MIC_RECORD_REQUEST_CODE -> {
                if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    makeMicPermissionRequest()
                } else {
                    setupPermissions()
                }
            }
            CAMERA_RECORD_REQUEST_CODE -> {
                if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    makeMicPermissionRequest()
                } else {
                }
            }
        }
    }

    private fun handleExit(checkedOption: Int) {
        if (checkedOption == Constants.EXIT_TYPE_TERMINATE) {
//            isMeetingExitTypeManually = true
            conferenceManager!!.exitConfernce(Constants.EXIT_TYPE_REMOVEALL)
//            deleteConference()
        } else if (checkedOption == Constants.BREAKOUT_ROOM_EXIT_TO_MAIN) {
            conferenceManager!!.breakoutRejoinToParentRoom(roomParams!!.token)
        } else {
//            isMeetingExitTypeManually = true
            conferenceManager!!.exitConfernce(checkedOption)
        }
    }


    private fun getRetrofit(): Retrofit {
        val baseUrl = getString(R.string.app_api_base_url)
        return Retrofit.Builder().baseUrl(baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    private fun startMeetingForegroundService() {
        val connection = object : ServiceConnection {
            override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                serviceBound = true
                binder = service as MeetingService.LocalBinder
                meetingService = binder!!.getService()
                meetingService.registerMeetingEvents(this@MainActivity)
                meetingService.initMeetingRoom(roomParams!!)
            }

            override fun onServiceDisconnected(name: ComponentName?) {
                serviceBound = false
                Log.e(TAG, "onServiceDisconnected: ")
            }

        }
        Intent(activity, MeetingService::class.java).also { intent ->
            activity?.bindService(intent, connection, Context.BIND_AUTO_CREATE)
        }
    }

    private var serviceBound: Boolean = false
    private lateinit var meetingService: MeetingService
    private var roomParams: RoomParams? = null
    var binder: MeetingService.LocalBinder? = null

   /* private var connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            serviceBound = true
            binder = service as MeetingService.LocalBinder
            meetingService = binder!!.getService()
            meetingService.registerMeetingEvents(this@MainActivity)
            meetingService.initMeetingRoom(roomParams!!)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            serviceBound = false
            Log.e(TAG, "onServiceDisconnected: ")

        }

    }*/

    override fun onExited() {
        // handleMeetingExit()
        stopService()
        roomParams = null
        conferenceManager = null
        exitEventSink.success(true)
    }

    /**
     * stoping foreground service
     */
    private fun stopService() {
        binder!!.getService().stopForeground(true)
        binder!!.getService().stopSelf()
    }

    override fun setConferenceManager(conferenceManager: ConferenceManager) {
        this.conferenceManager = conferenceManager
    }

    override fun onConnectionSuccess(connectionData: ConnectionData) {
        if (connectionData.role == Constants.ROLE_MODERATOR) {
//            binding!!.header.meetingInfoBtn.visibility = View.VISIBLE
        } else {
//            binding!!.header.meetingInfoBtn.visibility = View.GONE
        }
    }

    private lateinit var mode: Mode
    override fun onMode(mode: Mode) {
        this.mode = mode
    }

    override fun onPreviewReady() {
        if (conferenceManager != null) {
//            initVideoAspectRatio()
            Utilities.initPreviewParams(
                viewFactory?.getTSTVideoView()?.videoView,
                conferenceManager,
                viewRemoteFactory?.getTSTVideoView()?.videoView
            )
            val viewParams = ViewParams(
                viewRemoteFactory?.getTSTVideoView()?.videoView,
                viewFactory?.getTSTVideoView()?.videoView
            )
            conferenceManager!!.drawVideoOnSurface(viewParams) // draw preview fullscreen
        }
    }

    private fun initPreviewParams() {
        /*  val viewParams = ViewParams()
          viewParams.fullscreenVideo = viewFactory?.getTSTVideoView()?.videoView
          viewParams.smallVideo = viewFactory?.getTSTVideoView()?.videoView
          conferenceManager.onAppResumes(viewParams)*/
        /*placePIPInCorrectPosition(
            resources.configuration.orientation,
            viewModel.isContentShareStarted()
        ) */// solving  preview goes down isse
    }

    override fun onPeerVideoConnected() {
/*        val viewParams = ViewParams(viewFactory?.getTSTVideoView()?.videoView, viewFactory?.getTSTVideoView()?.videoView)
        conferenceManager.drawVideoOnSurface(viewParams) // draw preview fullscreen*/
    }

    override fun onAudioMuted(statusData: MutedStatusData?) {

    }

    override fun onBreakoutJoinInvitationBy(participant: Participant) {

    }

    override fun onBreakoutRecall(breakoutRoomEnd: BreakoutRoomEnd) {

    }

    override fun onBreakoutRoomEnd(breakoutRoomEnd: BreakoutRoomEnd) {

    }

    override fun onChat(type: Int, chat: Chat?) {

    }

    override fun onCoHostToken(coHostTokenData: CoHostTokenData?) {

    }

    override fun onConferenceInfoUpdate(message: String?) {

    }

    override fun onConfernceLocked(lockedData: LockedData?) {

    }

    override fun onContentPermissionResult(requestStatus: ContentPermissionResponseData?) {

    }

    override fun onContentSettingsChanged(permissionData: ContentPermissionData?) {

    }

    override fun onContentShareRequest(participants: List<Participant?>?) {

    }

    override fun onContentStarted(
        contentStatusData: ContentStatusData?,
        participant: Participant?
    ) {

    }

    override fun onContentStoped(contentStatusData: ContentStatusData?, participant: Participant?) {

    }

    override fun onContentUpdate(contentUpdateData: ContentUpdateData?) {

    }

    override fun onCowatchEvents(cowatchData: CowatchData?) {

    }

    override fun onCustomConferenceEvents(type: String?, data: String?) {

    }

    override fun onInitParticipantList(participantData: List<Participant?>?) {

    }

    override fun onKickout() {

    }

    override fun onMuteAll(muteData: MuteData?) {

    }

    override fun onMuteFromServer(meData: MuteMeData?) {

    }

    override fun onParticipant(participant: Participant?, joined: Boolean) {

    }

    override fun onParticipantStatus(participant: Participant?) {

    }

    override fun onParticipants(
        active: List<Participant?>?,
        passive: List<Participant?>?,
        waiting: List<Participant?>?
    ) {

    }

    override fun onPendingAccept(pendingData: PendingData?) {

    }

    override fun onPromotedSuccess(promoteData: PromoteData?) {

    }

    override fun onRTMPStarted(rtmpDataFromServer: RtmpDataFromServer?) {

    }

    override fun onRTMPStoped(rtmpDataFromServer: RtmpDataFromServer?) {

    }

    override fun onRecordStarted(recordData: RecordData?) {

    }

    override fun onRecordStoped(recordData: RecordData?) {

    }

    override fun onUserSpeaks(participant: Participant?) {

    }

    override fun onVideoMuted(statusData: MutedStatusData?) {

    }

    override fun onWaitingRoom(waitingRoom: WaitingRoom?) {

    }

    override fun reconnectAndJoinToBreakoutRoom(roomInfo: BreakoutRoomInfo) {

    }

    override fun reconnectMeeting() {

    }

    /*  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          if (arguments == "100"){
              exitEventSink = events!!
          }else {
              eventSink = events!!
          }
      }

      override fun onCancel(arguments: Any?) {

      }*/

    override fun onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed()
        if (viewFactory != null) {
            Log.d(TAG, "onFlutterUiDisplayed: ${viewFactory?.getTSTVideoView()}")
        }

    }
}
