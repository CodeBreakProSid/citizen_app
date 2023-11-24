import 'package:flutter/foundation.dart';

import 'api_helper/api_const.dart';

class ApiUrls {
  static const String LOCAL_URL =
      'https://janamaithri.keralapolice.gov.in/api/v1';

  static const String PRODUCTION_URL =
      'https://janamaithri.keralapolice.gov.in/api/v1';

  static const String APIURL = kDebugMode ? LOCAL_URL : PRODUCTION_URL;

  static const String SOCKET_URL =
      'wss://janamaithri.keralapolice.gov.in/api/v1/signal/connect?';

  //Rail temporary URL
  //static const String RAIL_URL = 'http://192.168.4.63:8000';
  static const String RAIL_URL = 'http://103.10.168.42:8000';
  //static const String RAIL_URL                          = 'http://192.168.4.87:8000';
  //static const String RAIL_URL = 'https://railmaithri.keralapolice.gov.in:8000';

  //Citizen Management//
  static const String TOKEN = '$APIURL/citizen/token/create';
  static const String CHECK_VALIDITY = '$APIURL/citizen/token/check';
  static const String USER_DETAILS = '$APIURL/citizen/profile/details';
  static const String UPDATE_PROFILE = '$APIURL/citizen/profile/edit?';
  static const String SIGNOUT = '$APIURL/citizen/token/delete';

  //Sign Up//
  static const String SIGNUP = '$APIURL/citizen/signup';
  static const String SIGNUP_CAPTCHA_ID = '$APIURL/citizen/signup/captcha';
  static const String SIGNUP_CAPTCHA_IMAGE =
      '$APIURL/citizen/signup/captcha_pic';

  //Reset Password//
  static const String RESET_PASSWORD = '$APIURL/citizen/reset_password';
  static const String RESET_PASSWORD_CAPTCHA_ID =
      '$APIURL/citizen/reset_password/captcha';
  static const String RESET_PASSWORD_CAPTCHA_IMAGE =
      '$APIURL/citizen/reset_password/captcha_pic';

  //Phone verification//
  static const String PHONE_VERIFICATION_CAPTCHA_ID =
      '$APIURL/citizen/phone_verification/captcha';
  static const String PHONE_VERIFICATION_CAPTCHA_IMAGE =
      '$APIURL/citizen/phone_verification/captcha_pic';
  static const String PHONE_VERIFICATION_SENT_OTP =
      '$APIURL/citizen/phone_verification/send_otp?';
  static const String PHONE_VERIFICATION_VERIFY_OTP =
      '$APIURL/citizen/phone_verification/verify_with_otp?';

  //Ticket Management//
  static const String CREATE_NEW_TICKET = '$APIURL/citizen/ticket/new';
  static const String ADD_NEW_COMPONENT_GROUP =
      '$APIURL/citizen/ticket/component/add';
  static const String GET_RESOURCE_COMPONENT =
      '$APIURL/citizen/ticket/component/file/get?';
  static const String COMPONENT_GROUP_DETAILS =
      '$APIURL/citizen/ticket/component/details?';
  static const String COMPONENT_GROUP_LIST =
      '$APIURL/citizen/ticket/component/list?';
  static const String TICKET_CREATED_FOR_ME = '$APIURL/citizen/ticket/list?';

  //location Service//
  static const String CONTAINING_POLICE_STATION =
      '$APIURL/beat_officer/location/beat_ps?';
  static const String UPDATE_LOCATION = '$APIURL/citizen/location/update?';
  static const String GET_JURISDICTION_DETAILS =
      '$APIURL/beat_officer/location/beat_pd?';

  //Meeting Service//
  static const String MEETING_STARTED_BY_ME =
      '$APIURL/citizen/citizen_support/call/list?';
  static const String MEETING_CONNECT_OFFICER =
      '$APIURL/citizen/meeting/connect_officer?';
  static const String MEETING_CONNECT_SERVICE =
      '$APIURL/citizen/citizen_support/call';
  static const String MEETING_RECORDING =
      '$APIURL/citizen/citizen_support/call/download?';

  //Notification Service//
  static const String USER_NOTIFICATION =
      '$APIURL/citizen/notification/created_for_me?';
  static const String NOTIFICATION_JOIN_CHANNEL =
      '$APIURL/citizen/notifications/join_channel';

  //Janamaithri Cache Management//
  static const String POLICE_STATION = '$APIURL/beat_officer/beat_ps/list';
  static const String POLICE_STATION_TYPE =
      '$APIURL/beat_officer/cache/${ApiConst.STATION_TYPE}';
  static const String PUBLIC_SERVICES =
      '$APIURL/citizen/cache/${ApiConst.PUBLIC_SERVICE}';
  static const String GENDER =
      '$APIURL/beat_officer/cache/${ApiConst.GENDER_TYPE}?prettify=true';
  static const String USER_TYPE =
      '$APIURL/beat_officer/cache/${ApiConst.USER_TYPE}';
  static const String ACCOUNT_STATUS =
      '$APIURL/beat_officer/cache/${ApiConst.ACCOUNT_STATUS}';
  static const String MEETING_STATE =
      '$APIURL/beat_officer/cache/${ApiConst.MEETING_STATE}';
  static const String NOTIFICATION_TYPE =
      '$APIURL/beat_officer/cache/${ApiConst.NOTIFICATION_TYPE}';
  static const String TICKET_STATUS =
      '$APIURL/beat_officer/cache/${ApiConst.TICKET_STATUS}';
  static const String TICKET_TYPE =
      '$APIURL/beat_officer/cache/${ApiConst.TICKET_TYPE}';
  static const String POLICE_STATION_USERS =
      '$APIURL/beat_officer/beat_ps/officer/list?';
  static const String OFFICER_DETAILS =
      '$APIURL/beat_officer/public_data/officer_details?';
  static const String SURVEY_FORMS =
      '$APIURL/officer/survey_management/list_survey_forms';
  static const String SURVEY_FORMS_DATA =
      '$APIURL/citizen/rail_ticket/rail_form?';
  static const String SRUVEY_SAVE =
      '$APIURL/citizen/rail_ticket/add_component_group';
  static const String RAILWAY_TICKET = '$APIURL/citizen/rail_ticket/new_ticket';
  static const String RAIL_TICKET_CREATED_FOR_ME =
      '$APIURL/citizen/rail_ticket/created_by_me?';
  static const String TRAIN = '$APIURL/citizen/cache/${ApiConst.TRAIN}';

  //Rail Cache Management
  static const String DISTRICT_LIST =
      '$RAIL_URL/accounts/dropdown/${ApiConst.DISTRICT_LIST}/';
  static const String RAILWAY_STN_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.RAILWAY_STN_LIST}/?mobile=true';
  static const String VOLUNTEER_CATEGORY =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.VOLUNTEER_CATEGORY}/';
  static const String TRAIN_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.TRAIN_LIST}/';
  static const String TRAIN_STOP_STATION_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.TRAIN_STOP_STATION_LIST}/';
  static const String INTELLIGENCE_TYPE =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.INTELLIGENCE_TYPE}/';
  static const String SEVERITY_TYPE =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.SEVERITY_TYPE}/';
  static const String STAFF_PORTER_TYPE =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.STAFF_PORTER_TYPE}/';
  static const String STATE_LIST =
      '$RAIL_URL/accounts/dropdown/${ApiConst.STATE_LIST}/';
  static const String SHOP_CATEGORY_TYPE =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.SHOP_CATEGORY_TYPE}/';
  static const String CONTACT_CATEGORY_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.CONTACT_CATEGORY_LIST}/';
  static const String LOST_PROPERTY_CATEGORY_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.LOST_PROPERTY_CATEGORY_LIST}/';
  static const String POLICE_STN_LIST =
      '$RAIL_URL/accounts/dropdown/${ApiConst.POLICE_STN_LIST}/';
  static const String LOST_PROPERTY_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.LOST_PROPERTY}/';
  static const String CONTACT_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.CONTACT_LIST}/?';

  static const String EMR_CONTACT_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.CONTACT_LIST}/?'; //is_emergency=true

  // static const String EMERGENCY_CONTACT_LIST =
  //     '$RAIL_URL/railmaithri/dropdown/${ApiConst.CONTACT_LIST}/?';
  static const String RAIL_NOTIFICATION =
      '$RAIL_URL/api/v1/${ApiConst.RAIL_NOTIFICATION}/?';
  static const String NOTIFICATION_LONELY =
      '$RAIL_URL/railmaithri/citizen/${ApiConst.NOTIFICATION_LONELY}/?ordering=-date_of_journey';
  static const String AWARENESS_CLASS_LIST =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.AWARENESS_CLASS_LIST}/';
  static const String SAFETY_TIP =
      '$RAIL_URL/railmaithri/dropdown/${ApiConst.SAFETY_TIP}/';
  static const String CREATE_RAIL_VOLUNTEER =
      '$RAIL_URL/api/v1/rail_volunteer/';
  static const String CREATE_SHOP_LABOUR = '$RAIL_URL/api/v1/shop/';
  static const String SHOP_LABOUR = '$RAIL_URL/api/v1/${ApiConst.SHOP_LABOUR}/';
  static const String CREATE_STAFF_PORTER =
      '$RAIL_URL/api/v1/contract_staff_porter/';
  static const String SEND_FIREBASE_TOCKEN =
      '$RAIL_URL/api/v1/${ApiConst.SEND_FIREBASE_TOCKEN}/';

  //Rail POST API calls
  static const String CREATE_LONELY_PASSENGER =
      '$RAIL_URL/api/v1/${ApiConst.CREATE_LONELY_PASSENGER}/';
  static const String CREATE_INTELLIGENCE_REPORT =
      '$RAIL_URL/api/v1/${ApiConst.CREATE_INTELLIGENCE_REPORT}/';
  static const String CREATE_NEW_INCIDENT_REPORT =
      '$RAIL_URL/api/v1/${ApiConst.CREATE_NEW_INCIDENT_REPORT}/';
  static const String CREATE_NEW_INTRUDER_ALERT =
      '$RAIL_URL/api/v1/${ApiConst.CREATE_NEW_INTRUDER_ALERT}/';
  static const String CREATE_NEW_SOS_MSG =
      '$RAIL_URL/api/v1/${ApiConst.SOS_MSG}/';
}
