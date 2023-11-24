package org.citizen.janamaithri

import android.app.*
import android.content.Intent
import android.os.*
import androidx.core.app.NotificationCompat
import com.tst.core.breakout.data.BreakoutRoomEnd
import com.tst.core.breakout.data.BreakoutRoomInfo
import com.tst.core.core.ConferenceManager
import com.tst.core.core.interfaces.OnConferenceEvents
import com.tst.core.entity.data.*
import com.tst.core.entity.params.ConferenceParams
import com.tst.core.log.VConsolLogger
import com.tst.core.utils.Constants
import org.citizen.janamaithri.Utilities.Utilities
import org.citizen.janamaithri.entity.RoomParams
import kotlin.random.Random

/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */class MeetingService : Service(), OnConferenceEvents {
    private val TAG = "MeetingServiceV2"
    val binder: IBinder = LocalBinder()

    inner class LocalBinder : Binder() {
        fun getService(): MeetingService = this@MeetingService
    }

    companion object {
        const val FORGROUND_CHANNEL_ID = "meeting_${BuildConfig.APPLICATION_ID}"
        var ONGOING_NOTIFICATION_ID = Random(20000).nextInt(200, 20000)
    }

    override fun onBind(intent: Intent?): IBinder? {
        createNotificationChannel()
        val notificationIntent = Intent(this, MainActivity::class.java)
        var pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
        } else {
            PendingIntent.getActivity(this, 0, notificationIntent, 0)
        }
        val notification: Notification = NotificationCompat.Builder(this, FORGROUND_CHANNEL_ID)
            .setContentTitle("Ongoing video call")
            .setContentText("Tap to return to the call")
            .setOngoing(true)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setUsesChronometer(true)
            .setSilent(true)
            .build()
        startForeground(ONGOING_NOTIFICATION_ID, notification)
        return binder
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                FORGROUND_CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(
                NotificationManager::class.java
            )
            manager.createNotificationChannel(serviceChannel)
        }
    }

    lateinit var meetingEvents: MeetingEvents
    public fun registerMeetingEvents(meetingEvents: MeetingEvents) {
        this.meetingEvents = meetingEvents
    }

    private lateinit var conferenceParams: ConferenceParams

    private lateinit var conferenceManager: ConferenceManager
    fun initMeetingRoom(roomParams: RoomParams) {
        conferenceParams = Utilities.createConferenceParameters(roomParams, this)
        conferenceManager = ConferenceManager.getInstance(this)
        meetingEvents.setConferenceManager(conferenceManager)
        var libVersion: String? = null
        try {
            libVersion = conferenceManager.initConfernce(conferenceParams)
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        }
        VConsolLogger.printi(
            "MeetingService",
            "Library version +++++++++++++++++: $libVersion"
        )
    }

    override fun onAudioMuted(statusData: MutedStatusData?) {
        meetingEvents.onAudioMuted(statusData)
    }

    override fun onBreakoutJoinInvitationBy(participant: Participant) {
        meetingEvents.onBreakoutJoinInvitationBy(participant)
    }

    override fun onBreakoutRecall(breakoutRoomEnd: BreakoutRoomEnd) {
        meetingEvents.onBreakoutRecall(breakoutRoomEnd)
    }

    override fun onBreakoutRoomEnd(breakoutRoomEnd: BreakoutRoomEnd) {
        meetingEvents.onBreakoutRoomEnd(breakoutRoomEnd)
    }

    override fun onChat(type: Int, chat: Chat?) {
        meetingEvents.onChat(type, chat)
    }

    override fun onCoHostToken(coHostTokenData: CoHostTokenData?) {
        meetingEvents.onCoHostToken(coHostTokenData)
    }

    override fun onConferenceInfoUpdate(message: String?) {
        meetingEvents.onConferenceInfoUpdate(message)
    }

    override fun onConfernceExited() {
        val handler = Handler(Looper.getMainLooper())
        handler.post {
            stopSelf(1)
            stopForeground(true)
        }
        meetingEvents.onExited()
    }

    override fun onConfernceLocked(lockedData: LockedData?) {
        meetingEvents.onConfernceLocked(lockedData)
    }

    override fun onConnectionSuccess(connectionData: ConnectionData?) {
        if (connectionData != null) {
            meetingEvents.onConnectionSuccess(connectionData)
        }
    }

    override fun onContentPermissionResult(requestStatus: ContentPermissionResponseData?) {
        meetingEvents.onContentPermissionResult(requestStatus)
    }

    override fun onContentSettingsChanged(permissionData: ContentPermissionData?) {
        meetingEvents.onContentSettingsChanged(permissionData)
    }

    override fun onContentShareRequest(participants: List<Participant?>?) {
        meetingEvents.onContentShareRequest(participants)
    }

    override fun onContentStarted(
        contentStatusData: ContentStatusData?,
        participant: Participant?
    ) {
        meetingEvents.onContentStarted(contentStatusData, participant)
    }

    override fun onContentStoped(contentStatusData: ContentStatusData?, participant: Participant?) {
        meetingEvents.onContentStoped(contentStatusData, participant)
    }

    override fun onContentUpdate(contentUpdateData: ContentUpdateData?) {
        meetingEvents.onContentUpdate(contentUpdateData)
    }

    override fun onCowatchEvents(cowatchData: CowatchData?) {
        meetingEvents.onCowatchEvents(cowatchData)
    }

    override fun onCustomConferenceEvents(type: String?, data: String?) {
        meetingEvents.onCustomConferenceEvents(type, data)
    }

    override fun onInitParticipantList(participantData: List<Participant?>?) {
        meetingEvents.onInitParticipantList(participantData)
    }

    override fun onKickout() {
        meetingEvents.onKickout()
    }

    override fun onMode(mode: Mode?) {
        if (mode != null) {
            meetingEvents.onMode(mode)
        }
    }

    override fun onMuteAll(muteData: MuteData?) {
        meetingEvents.onMuteAll(muteData)
    }

    override fun onMuteFromServer(meData: MuteMeData?) {
        meetingEvents.onMuteFromServer(meData)
    }

    override fun onParticipant(participant: Participant?, joined: Boolean) {
        meetingEvents.onParticipant(participant, joined)
    }

    override fun onParticipantStatus(participant: Participant?) {
        meetingEvents.onParticipantStatus(participant)
    }

    override fun onParticipants(
        active: List<Participant?>?,
        passive: List<Participant?>?,
        waiting: List<Participant?>?
    ) {
        meetingEvents.onParticipants(active, passive, waiting)
    }

    override fun onPeerVideoConnected() {
        meetingEvents.onPeerVideoConnected()
    }

    override fun onPendingAccept(pendingData: PendingData?) {
        meetingEvents.onPendingAccept(pendingData)
    }

    override fun onPreviewReady() {
        meetingEvents.onPreviewReady()

    }

    override fun onPromotedSuccess(promoteData: PromoteData?) {
        meetingEvents.onPromotedSuccess(promoteData)
    }

    override fun onRTMPStarted(rtmpDataFromServer: RtmpDataFromServer?) {
        meetingEvents.onRTMPStarted(rtmpDataFromServer)
    }

    override fun onRTMPStoped(rtmpDataFromServer: RtmpDataFromServer?) {
        meetingEvents.onRTMPStoped(rtmpDataFromServer)
    }

    override fun onRecordStarted(recordData: RecordData?) {
        meetingEvents.onRecordStarted(recordData)
    }

    override fun onRecordStoped(recordData: RecordData?) {
        meetingEvents.onRecordStoped(recordData)
    }

    override fun onUserSpeaks(participant: Participant?) {
        meetingEvents.onUserSpeaks(participant)
    }

    override fun onVideoMuted(statusData: MutedStatusData?) {
        meetingEvents.onVideoMuted(statusData)
    }

    override fun onWaitingRoom(waitingRoom: WaitingRoom?) {
        meetingEvents.onWaitingRoom(waitingRoom)
    }

    override fun reconnectAndJoinToBreakoutRoom(roomInfo: BreakoutRoomInfo) {
        meetingEvents.reconnectAndJoinToBreakoutRoom(roomInfo)
    }

    override fun reconnectMeeting() {
        meetingEvents.reconnectMeeting()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (conferenceManager != null) {
            conferenceManager.exitConfernce(Constants.EXIT_TYPE_NORMAL)
        }
    }
}