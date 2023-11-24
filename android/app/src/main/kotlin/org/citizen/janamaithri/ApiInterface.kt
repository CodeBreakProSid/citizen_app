package org.citizen.janamaithri

import org.citizen.janamaithri.entity.JoinParamsToServer
import org.citizen.janamaithri.entity.MeetingDataFromServer
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Path

/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */interface ApiInterface {
    @POST("/api/v1/meeting/join/{id}")
    suspend fun join(@Path("id") meetingId : String, @Body joinParamsToServer: JoinParamsToServer) : Response<MeetingDataFromServer>

    @POST("/api/v1/pre-auth/meeting/{id}/meeting-token")
    suspend fun getMeetingParams(
        @Header("Authorization") access_token: String?,
        @Path("id") meetingId: String?
    ): Response<MeetingDataFromServer>
}