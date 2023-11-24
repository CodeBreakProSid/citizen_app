package org.citizen.janamaithri.Utilities

/*
 *  Copyright © 2022 Techgentsia  Software Technologies Private Limited - All rights reserved.
 *  This software is produced by Techgentsia. This is Proprietary and confidential
 *  Unauthorized redistribution, reproduction, or usage of
 *  this software in whole or in part without the express
 *  written consent of Techgentsia is strictly prohibited.
 *  Author - Sreenath K  e-mail - <sreenath@techgentsia.com> ,  Aug 2022
 */class Constants {
    companion object {
        const val SIGNAL_PATH = "/socket.io/api/v1"
        const val ROLE_MODERATOR: String = "moderator"

        /**Exit Types*/
        const val EXIT_TYPE_NORMAL = 0
        const val EXIT_TYPE_REMOVEALL = 1
        const val EXIT_TYPE_TERMINATE = 2
        const val BREAKOUT_ROOM_EXIT_TO_MAIN = 3
    }
}