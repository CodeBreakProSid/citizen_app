package org.citizen.janamaithri

import com.tst.core.breakout.data.BreakoutRoomEnd
import com.tst.core.breakout.data.BreakoutRoomInfo
import com.tst.core.core.ConferenceManager
import com.tst.core.entity.data.*


/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Clifford P Y  e-mail - <clifford@techgentsia.com> ,  Apr 2022
 */

interface MeetingEvents {

    fun onExited()
    fun setConferenceManager(conferenceManager: ConferenceManager)
    fun onConnectionSuccess(connectionData: ConnectionData)
    fun onMode(mode: Mode)
    fun onPreviewReady()
    fun onPeerVideoConnected()
    fun onAudioMuted(statusData: MutedStatusData?)
    fun onBreakoutJoinInvitationBy(participant: Participant)
    fun onBreakoutRecall(breakoutRoomEnd: BreakoutRoomEnd)
    fun onBreakoutRoomEnd(breakoutRoomEnd: BreakoutRoomEnd)
    fun onChat(type: Int, chat: Chat?)
    fun onCoHostToken(coHostTokenData: CoHostTokenData?)
    fun onConferenceInfoUpdate(message: String?)
    fun onConfernceLocked(lockedData: LockedData?)
    fun onContentPermissionResult(requestStatus: ContentPermissionResponseData?)
    fun onContentSettingsChanged(permissionData: ContentPermissionData?)
    fun onContentShareRequest(participants: List<Participant?>?)
    fun onContentStarted(contentStatusData: ContentStatusData?, participant: Participant?)
    fun onContentStoped(contentStatusData: ContentStatusData?, participant: Participant?)
    fun onContentUpdate(contentUpdateData: ContentUpdateData?)
    fun onCowatchEvents(cowatchData: CowatchData?)
    fun onCustomConferenceEvents(type: String?, data: String?)
    fun onInitParticipantList(participantData: List<Participant?>?)
    fun onKickout()
    fun onMuteAll(muteData: MuteData?)
    fun onMuteFromServer(meData: MuteMeData?)
    fun onParticipant(participant: Participant?, joined: Boolean)
    fun onParticipantStatus(participant: Participant?)
    fun onParticipants(
        active: List<Participant?>?,
        passive: List<Participant?>?,
        waiting: List<Participant?>?
    )

    fun onPendingAccept(pendingData: PendingData?)
    fun onPromotedSuccess(promoteData: PromoteData?)
    fun onRTMPStarted(rtmpDataFromServer: RtmpDataFromServer?)
    fun onRTMPStoped(rtmpDataFromServer: RtmpDataFromServer?)
    fun onRecordStarted(recordData: RecordData?)
    fun onRecordStoped(recordData: RecordData?)
    fun onUserSpeaks(participant: Participant?)
    fun onVideoMuted(statusData: MutedStatusData?)
    fun onWaitingRoom(waitingRoom: WaitingRoom?)
    fun reconnectAndJoinToBreakoutRoom(roomInfo: BreakoutRoomInfo)
    fun reconnectMeeting()
}