import 'package:get/get.dart';

import '../modules/add_ticket/bindings/add_ticket_binding.dart';
import '../modules/add_ticket/views/add_ticket_view.dart';
import '../modules/call_history/bindings/call_history_binding.dart';
import '../modules/call_history/views/call_history_view.dart';
import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/page_awareness_class/bindings/page_awareness_class_binding.dart';
import '../modules/page_awareness_class/views/page_awareness_class_view.dart';
import '../modules/page_contact_details/bindings/page_contact_details_binding.dart';
import '../modules/page_contact_details/views/page_contact_details_view.dart';
import '../modules/page_incident_platform/bindings/page_incident_platform_binding.dart';
import '../modules/page_incident_platform/views/page_incident_platform_view.dart';
import '../modules/page_incident_track/bindings/page_incident_track_binding.dart';
import '../modules/page_incident_track/views/page_incident_track_view.dart';
import '../modules/page_incident_train/bindings/page_incident_train_binding.dart';
import '../modules/page_incident_train/views/page_incident_train_view.dart';
import '../modules/page_intelligence/bindings/page_intelligence_binding.dart';
import '../modules/page_intelligence/views/page_intelligence_view.dart';
import '../modules/page_intruder_alert/bindings/page_intruder_alert_binding.dart';
import '../modules/page_intruder_alert/views/page_intruder_alert_view.dart';
import '../modules/page_lonely/bindings/page_lonely_binding.dart';
import '../modules/page_lonely/views/page_lonely_view.dart';
import '../modules/page_lost_property/bindings/page_lost_property_binding.dart';
import '../modules/page_lost_property/views/page_lost_property_view.dart';
import '../modules/page_porter_registration/bindings/page_porter_registration_binding.dart';
import '../modules/page_porter_registration/views/page_porter_registration_view.dart';
import '../modules/page_rail_volunteer/bindings/page_rail_volunteer_binding.dart';
import '../modules/page_rail_volunteer/views/page_rail_volunteer_view.dart';
import '../modules/page_safety_tip/bindings/page_safety_tip_binding.dart';
import '../modules/page_safety_tip/views/page_safety_tip_view.dart';
import '../modules/page_shop_labours/bindings/page_shop_labours_binding.dart';
import '../modules/page_shop_labours/views/page_shop_labours_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/sos_page/bindings/sos_page_binding.dart';
import '../modules/sos_page/views/sos_page_view.dart';
import '../modules/ticket_details/bindings/ticket_details_binding.dart';
import '../modules/ticket_details/views/ticket_details_view.dart';
import '../modules/ticket_history/bindings/ticket_history_binding.dart';
import '../modules/ticket_history/views/ticket_history_view.dart';
import '../modules/ticket_history_details/bindings/ticket_history_details_binding.dart';
import '../modules/ticket_history_details/views/ticket_history_details_view.dart';
import '../modules/vedio_calling/bindings/vedio_calling_binding.dart';
import '../modules/vedio_calling/views/vedio_calling_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ROOT,
      page: () => const RootView(),
      binding: RootBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_DETAILS,
      page: () => const TicketDetailsView(),
      binding: TicketDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TICKET,
      page: () => const AddTicketView(),
      binding: AddTicketBinding(),
    ),
    GetPage(
      name: _Paths.VEDIO_CALLING,
      page: () => const VedioCallingView(),
      binding: VedioCallingBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_HISTORY,
      page: () => const TicketHistoryView(),
      binding: TicketHistoryBinding(),
    ),
    GetPage(
      name: _Paths.CALL_HISTORY,
      page: () => const CallHistoryView(),
      binding: CallHistoryBinding(),
    ),
    GetPage(
      name: _Paths.SOS_PAGE,
      page: () => const SosPageView(),
      binding: SosPageBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    // GetPage(
    //   name: _Paths.RAIL_TICKET,
    //   page: () => const RailTicketView(),
    //   binding: RailTicketBinding(),
    // ),
    GetPage(
      name: _Paths.PAGE_LONELY,
      page: () => const PageLonelyView(),
      binding: PageLonelyBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_INCIDENT_TRAIN,
      page: () => const PageIncidentTrainView(),
      binding: PageIncidentTrainBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_INCIDENT_TRACK,
      page: () => const PageIncidentTrackView(),
      binding: PageIncidentTrackBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_INCIDENT_PLATFORM,
      page: () => const PageIncidentPlatformView(),
      binding: PageIncidentPlatformBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_INTELLIGENCE,
      page: () => const PageIntelligenceView(),
      binding: PageIntelligenceBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_INTRUDER_ALERT,
      page: () => const PageIntruderAlertView(),
      binding: PageIntruderAlertBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_RAIL_VOLUNTEER,
      page: () => const PageRailVolunteerView(),
      binding: PageRailVolunteerBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_PORTER_REGISTRATION,
      page: () => const PagePorterRegistrationView(),
      binding: PagePorterRegistrationBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_LOST_PROPERTY,
      page: () => const PageLostPropertyView(),
      binding: PageLostPropertyBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_AWARENESS_CLASS,
      page: () => const PageAwarenessClassView(),
      binding: PageAwarenessClassBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_SAFETY_TIP,
      page: () => const PageSafetyTipView(),
      binding: PageSafetyTipBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_SHOP_LABOURS,
      page: () => const PageShopLaboursView(),
      binding: PageShopLaboursBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_CONTACT_DETAILS,
      page: () => PageContactDetailsView(),
      binding: PageContactDetailsBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_HISTORY_DETAILS,
      page: () => TicketHistoryDetailsView(),
      binding: TicketHistoryDetailsBinding(),
    ),
  ];
}
