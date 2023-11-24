import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../data/meeting_history.dart';

class CallHistoryBaseController extends GetxController {
  final datePickerFromKey       = GlobalKey<FormBuilderState>();
  final int maxInt              = 4294967296;
  
  late Future<bool>               isDataLoaded;
  late Map<String, dynamic>       meetingState;
  
  int startingMeetingId         = 4294967296;
  int numOfMeetingToDisplay     = 10;

  List<MeetingHistory> meetings = [];

  bool _noMoreMeetings          = false;
  bool _isMeetingsLoading       = false;
  bool _isMoreMeetingsLoading   = false;

  bool get noMoreMeetings => _noMoreMeetings;
  set noMoreMeetings(bool v) => {_noMoreMeetings = v, update()};

  bool get isMeetingsLoading => _isMeetingsLoading;
  set isMeetingsLoading(bool v) => {_isMeetingsLoading = v, update()};

  bool get isMoreMeetingsLoading => _isMoreMeetingsLoading;
  set isMoreMeetingsLoading(bool v) => {_isMoreMeetingsLoading = v, update()};
}
