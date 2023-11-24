package org.citizen.janamaithri.entity

import com.tst.core.breakout.data.Configurations
import com.tst.core.breakout.data.IceServers
import java.io.Serializable

/*
 *  Copyright © 2021 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Nov 2021
 */data class RoomParams(
    var token: String,
    var title: String,
    var time: String,
    var serverUrl: String,
    var iceServers: List<IceServers>,
    var role: String,
    var type: String,
    var audioMuted: Boolean,
    var meetingId: String,
    var breakout: Boolean = false,
    var breakoutParentMeetingID: String?,
//    var config: Configurations?,
    var participantCount: Int,
    ) :Serializable
