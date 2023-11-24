class ApiConst {
  static const Key = 'access_token';
  static const TOKEN_TYPE = 'Bearer';

  // Janamaithei Cache Management//
  static const String NOTIFICATION_TYPE = 'notification_type';
  static const String GENDER_TYPE = 'gender_type';
  static const String TICKET_TYPE = 'ticket_type';
  static const String TICKET_STATUS = 'ticket_status';
  static const String ACCOUNT_STATUS = 'account_status';
  static const String USER_TYPE = 'user_type';
  static const String MEETING_STATE = 'meeting_state';
  static const String STATION_TYPE = 'station_type';
  static const String BOUNDARY_TYPE = 'boundary_type';
  static const String POLICE_STATION = 'police_station';
  static const String PUBLIC_SERVICE = 'service';
  static const String TRAIN = 'train';

  //Railway Cache Management//
  static const String SEND_FIREBASE_TOCKEN = 'fcm_device_citizen';
  static const String LOST_PROPERTY = 'lost_property_list';
  static const String CONTACT_LIST = 'contacts_list';
  static const String RAIL_NOTIFICATION = 'citizen_notifications';
  static const String AWARENESS_CLASS_LIST = 'awareness_class_list';
  static const String NOTIFICATION_LONELY = 'lonely_passenger_list';
  static const String SAFETY_TIP = 'safety_tip_list';
  static const String DISTRICT_LIST = 'district_list';
  static const String STATE_LIST = 'states';
  static const String POLICE_STN_LIST = 'police_station_list';
  static const String RAILWAY_STN_LIST = 'railway_station_list';
  static const String VOLUNTEER_CATEGORY = 'rail_volunteer_category_list';
  static const String TRAIN_LIST = 'train_list';
  static const String TRAIN_STOP_STATION_LIST = 'train_stop_list';
  static const String INTELLIGENCE_TYPE = 'intelligence_type_list';
  static const String SEVERITY_TYPE = 'severity_type_list';
  static const String STAFF_PORTER_TYPE = 'contract_staff_porter_category_list';
  static const String SHOP_CATEGORY_TYPE = 'shop_category_list';
  static const String CONTACT_CATEGORY_LIST = 'contacts_category_list';
  static const String LOST_PROPERTY_CATEGORY_LIST =
      'lost_property_category_list';
  static const String API_CALL_FROM = 'Citizen';
  static const String SHOP_LABOUR = 'shop_labour';
  static const String EXISTING_RAIL_VOLUNTEER = 'existing_volunteer';

  //Railway create post constant
  static const String CREATE_VOLUNTEER = 'rail_volunteer';
  static const String CREATE_LONELY_PASSENGER = 'lonely_passenger';
  static const String CREATE_INTELLIGENCE_REPORT = 'intelligence_report';
  static const String CREATE_NEW_INCIDENT_REPORT = 'incident_report';
  static const String CREATE_NEW_INTRUDER_ALERT = 'intruder_report';
  static const String SOS_MSG = 'sos_message';
}

class NotificationTypeConst {
  static const NOTIFICATION_TYPE_1 = 'NEW_TICKET';
  static const NOTIFICATION_TYPE_2 = 'TICKET_CLOSED';
  static const NOTIFICATION_TYPE_3 = 'MESSAGE_IN_TICKET';
}

class RailTicketStatusTypeConst {
  static const TICKET_TYPE_1 = 'Open';
  static const TICKET_TYPE_2 = 'Assigned';
  static const TICKET_TYPE_3 = 'Rejected';
  static const TICKET_TYPE_4 = 'Attended';
  static const TICKET_TYPE_5 = 'Closed';
}

class RailTicketCategoryTypeConst {
  static const CATEGORY_TYPE_1 = 'Lonely Passenger';
  static const CATEGORY_TYPE_2 = 'Incident on Train';
  static const CATEGORY_TYPE_3 = 'Incident on Track';
  static const CATEGORY_TYPE_4 = 'Incident on Platform';
  static const CATEGORY_TYPE_5 = 'Intelligence Report';
  static const CATEGORY_TYPE_6 = 'Intruder Report';
}

class GenderTypeConst {
  static const GENDER_TYPE_1 = 'Female';
  static const GENDER_TYPE_2 = 'Male';
  static const GENDER_TYPE_3 = 'Transgender';
  static const GENDER_TYPE_4 = 'Other';
  static const GENDER_TYPE = ['Female', 'Male', 'Transgender', 'Other'];
}

class TicketTypeConst {
  static const TICKET_TYPE_1 = 'GRIEVANCE';
  static const TICKET_TYPE_2 = 'REQUEST';
  static const TICKET_TYPE_3 = 'ENQUIRY';
}

class TicketStatusConst {
  static const TICKET_STATUS_1 = 'OPEN';
  static const TICKET_STATUS_2 = 'CLOSED';
  static const TICKET_STATUS_3 = 'DISPOSED';
  static const TICKET_STATUS_4 = 'REMOVED';
}

// class RailTicketStatusConst {
//   static const TICKET_STATUS_1 = 'New Ticket';
//   static const TICKET_STATUS_2 = 'Ticket Assigned';
//   static const TICKET_STATUS_3 = 'Ticket Attended';
//   static const TICKET_STATUS_4 = 'Ticket Rejected';
//   static const TICKET_STATUS_5 = 'Ticket Rejected';
// }

class UserTypeConst {
  static const USER_TYPE_1 = 'CITIZEN';
  static const USER_TYPE_2 = 'OFFICER';
  static const USER_TYPE_3 = 'MODERATOR';
  static const USER_TYPE_4 = 'ADMIN';
}

class MeetingTypeConst {
  static const MEETING_TYPE_1 = 'CREATED';
  static const MEETING_TYPE_2 = 'STARTED';
  static const MEETING_TYPE_3 = 'FINISHED';
  static const MEETING_TYPE_4 = 'STORED';
}

class ChannelTypeConst {
  static const NOTIFICATION = 'notification';
  static const RECEIVE_CALL = 'receive_call';
  static const RECEIVE_MEMO = 'receive_memo';
}

class SurveyFormConst {
  static const SURVEY_FORMS = 'survey_froms';
  static const SURVEY_ID_TYPE = 'survey_froms_id';
  static const SURVEY_NONSYNC_LIST = 'survey_nonsync_list';
  static const SURVEY_FORM_ID = 'from_id';
  static const SURVEY_FORM_SAVED = 'saved_date';
  static const SURVEY_FORM_SAVED_DATA = 'saved_form';
}         

// class RailFormConst {
//   static const RAIL_FORMS = 'rail_froms';
// }
