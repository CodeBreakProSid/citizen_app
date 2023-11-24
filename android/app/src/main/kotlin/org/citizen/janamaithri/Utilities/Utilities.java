package org.citizen.janamaithri.Utilities;/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */

import com.tst.core.breakout.data.IceServers;
import com.tst.core.core.ConferenceManager;
import com.tst.core.entity.params.ConferenceParams;
import com.tst.core.entity.params.SignalParams;
import com.tst.core.entity.params.ViewParams;
import org.citizen.janamaithri.MeetingService;
import org.citizen.janamaithri.R;
import org.citizen.janamaithri.entity.MeetingDataFromServer;
import org.citizen.janamaithri.entity.RoomParams;

import org.webrtc.PeerConnection;
import org.webrtc.SurfaceViewRenderer;

import java.util.List;

public class Utilities {
    public static  RoomParams roomParams = null;
    public static ConferenceParams createConferenceParameters(RoomParams roomParams, MeetingService meetingService) {
        ConferenceParams conferenceParams = new ConferenceParams();
        conferenceParams.setContext(meetingService);
        //signal params
        SignalParams signalParams = new SignalParams(roomParams.getServerUrl(),
                Constants.SIGNAL_PATH,
                roomParams.getToken());
        conferenceParams.setSignalParams(signalParams);
//        conferenceParams.getSignalParams().setSignalUrl(roomParams.getServerUrl());
//        conferenceParams.getSignalParams().setSignalPath(Constants.SIGNAL_PATH);
//        conferenceParams.getSignalParams().setToken(roomParams.getToken());

        //conference event listner
        conferenceParams.setOnConferenceEvents(meetingService);
        if (roomParams.getBreakout()) {
            conferenceParams.setParentMeetingId(roomParams.getBreakoutParentMeetingID());
        }
        conferenceParams.getVideoParams().setVideoFPS(30);
        conferenceParams.getVideoParams().setPrefMaxWidth(1280);
        conferenceParams.getVideoParams().setScaleDownWidth(1280);
        conferenceParams.getVideoParams().setScaleDownHeight(720);
        conferenceParams.getVideoParams().setMinAspectRatio(1.7);
        conferenceParams.setBaseUrl(meetingService.getString(R.string.app_api_base_url));
        List<IceServers> customIceServers = roomParams.getIceServers();
        if (customIceServers != null) {
            for (IceServers customIceServer : customIceServers) {
                String username = "";
                String credentials = "";
                if (customIceServer.getUsername() != null) {
                    username = customIceServer.getUsername();
                }
                if (customIceServer.getCredential() != null) {
                    credentials = customIceServer.getCredential();
                }
                PeerConnection.TlsCertPolicy tlsCertPolicy = PeerConnection.TlsCertPolicy.TLS_CERT_POLICY_INSECURE_NO_CHECK;
                PeerConnection.IceServer iceServer = new PeerConnection.IceServer(
                        customIceServer.getUrls(),
                        username,
                        credentials,
                        tlsCertPolicy
                );
                conferenceParams.getIceServers().add(iceServer);
            }
        }
        return conferenceParams;
    }
    /**
     * @param dataFromServer
     * @return
     */
    public static RoomParams createRoomParamsForMeeting(MeetingDataFromServer dataFromServer) {
        RoomParams roomParams = new RoomParams(
                dataFromServer.getToken(),
                dataFromServer.getTitle(),
                "02 April 2020, 12:12:30 PM",
                dataFromServer.getServer(),
                dataFromServer.getIceServers(),
                dataFromServer.getRole(),
                dataFromServer.getType(),
                dataFromServer.getAudioMuted(),
                dataFromServer.getMeetingID(),
                dataFromServer.getBreakout(),
                dataFromServer.getBreakoutParentMeetingID(),
//                dataFromServer.getConfig(),
                dataFromServer.getParticipantCount());
        return roomParams;
    }

    public static void initPreviewParams(SurfaceViewRenderer videoView, ConferenceManager conferenceManager,SurfaceViewRenderer remoteVideoview) {
        ViewParams viewParams = new ViewParams();
        viewParams.setFullscreenVideo(videoView);
        viewParams.setSmallVideo(remoteVideoview);
        conferenceManager.onAppResumes(viewParams);
//        placePIPInCorrectPosition(getResources().getConfiguration().orientation, viewModel.isContentShareStarted()); // solving  preview goes down isse
    }
}
