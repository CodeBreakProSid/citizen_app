import 'package:flutter/foundation.dart';

import '../../../services/home_services.dart';
import '../../../services/other_services.dart';
import '../../../util/global_widgets.dart';
import 'call_history_base_controller.dart';

class CallHistoryController extends CallHistoryBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      meetingState = await OtherServices.getMeetingStatus();
      await loadMeetings();

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Load meetings*********************************
  Future<void> loadMeetings({
                              DateTime? createdBefore,
                              DateTime? createdAfter, }) async {
    isMeetingsLoading = true;
    final apiResponse = await HomeServices.getMeetingHistory(
      numOfMeetingToDisplay + 1,
      createdAfter            : createdAfter,
      createdBefore           : createdBefore,
    );
    meetings.clear();
    if (apiResponse.length <= numOfMeetingToDisplay) {
      noMoreMeetings = true;
      meetings.addAll(apiResponse);
    } else {
      noMoreMeetings    = false;
      startingMeetingId = apiResponse.last.meetingId;
      apiResponse.removeLast();
      meetings.addAll(apiResponse);
    }
    isMeetingsLoading = false;
  }

  //******************************Load more meetings****************************
  Future<bool> loadMoreMeetings() async {
    try {
      isMoreMeetingsLoading = true;
      late final DateTime?    createdAfter;
      late final DateTime?    createdBefore;
      datePickerFromKey.currentState?.save();
      if (datePickerFromKey.currentState?.fields['from_date']?.value != null &&
          datePickerFromKey.currentState?.fields['to_date']?.value != null) {
        createdAfter = datePickerFromKey
                       .currentState?.fields['from_date']?.
                       value as DateTime;
        createdBefore = datePickerFromKey.currentState?.
                        fields['to_date']?.value as DateTime;
      } else {
        createdAfter  = null;
        createdBefore = null;
      }

      final apiResponse = await HomeServices.getMeetingHistory(
        numOfMeetingToDisplay + 1,
        meetingId     : startingMeetingId,
        createdAfter  : createdAfter,
        createdBefore : createdBefore,
      );
      if (apiResponse.length <= numOfMeetingToDisplay) {
        noMoreMeetings = true;
        meetings.addAll(apiResponse);
      } else {
        noMoreMeetings      = false;
        startingMeetingId   = apiResponse.last.meetingId;
        apiResponse.removeLast();
        meetings.addAll(apiResponse);
      }
      isMoreMeetingsLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Search meetings*******************************
  Future<void> sreachMeetings() async {
    try {
      if (datePickerFromKey.currentState?.saveAndValidate() ?? false) {
        if (datePickerFromKey.currentState?.fields['from_date']?.value ==
                null ||
            datePickerFromKey.currentState?.fields['to_date']?.value == null) {
          return;
        }
        noMoreMeetings = true;

        await loadMeetings(
          createdAfter: datePickerFromKey.currentState?.
                        fields['from_date']?.value as DateTime,
          createdBefore: datePickerFromKey.currentState?.
                        fields['to_date']?.value as DateTime,
        );
      }
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type    : SnackbarType.error,
        message : 'Something went wrong! try again',
      );
    }
  }
}
