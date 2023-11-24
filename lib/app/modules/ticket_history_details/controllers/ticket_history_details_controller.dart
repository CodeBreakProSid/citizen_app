// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/rail_ticket_details.dart';
import '../../../data/rail_ticket_history_details.dart';
import '../../../data/ticket_details.dart';
import '../../../services/home_services.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'ticket_history_details_base_controller.dart';

class TicketHistoryDetailsController
    extends TicketHistoryDetailsBaseController {
  @override
  void onInit() {
    super.onInit();
    isDataLoaded = loadData();
  }

  static final box = GetStorage();
  List<RailTicketHistoryDetails> tempListOfRailNotification = [];
  List<RailTicketHistoryDetails> tempListOfRailNotification1 = [];

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      policeStations = await box.read(ApiConst.POLICE_STATION) == null
          ? await HomeServices.getPoliceStations(isUpdate: true)
          : await HomeServices.getPoliceStations();
      ticketStatus = await box.read(ApiConst.TICKET_STATUS) == null
          ? await OtherServices.getTicketStatus(isUpdate: true)
          : await OtherServices.getTicketStatus();
      trains = await box.read(ApiConst.TRAIN) == null
          ? await HomeServices.getTrains(isUpdate: true)
          : await HomeServices.getTrains();
      user = await userServices.getUser();

      userName = user != null ? user!.fullName ?? user!.username : '';

      await loadTickets();
      await loadRailTicket(
        DateTime.parse('1990-05-27T10:38:19.016877Z'),
        DateTime.now(),
      );

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Search janamaithri tickets********************
  Future<void> sreachTickets() async {
    try {
      if (datePickerFromKey.currentState?.saveAndValidate() ?? false) {
        if (datePickerFromKey.currentState?.fields['from_date']?.value ==
                null ||
            datePickerFromKey.currentState?.fields['to_date']?.value == null) {
          return;
        }
        noMoreTickets = true;

        await loadTickets(
          createdAfter: datePickerFromKey
              .currentState?.fields['from_date']?.value as DateTime,
          createdBefore: datePickerFromKey
              .currentState?.fields['to_date']?.value as DateTime,
        );
      }
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type: SnackbarType.error,
        message: 'Something went wrong! try again',
      );
    }
  }

  //******************************Load janamaithri tickets**********************
  Future<void> loadTickets({
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    isTicketLoading = true;
    ticketsToDisplay = [];

    final List<TicketDetails> tickets = await HomeServices.getTicketDetails(
      startingTicketId,
      noOfTicketsToLoad + 1,
      createdAfter: createdAfter,
      createdBefore: createdBefore,
    );

    if (tickets.length <= noOfTicketsToLoad) {
      noMoreTickets = true;
      ticketsToDisplay.addAll(tickets);
    } else {
      noMoreTickets = false;
      endingTicketId = tickets.last.ticketId;
      tickets.removeLast();
      ticketsToDisplay.addAll(tickets);
    }
    isTicketLoading = false;
  }

  //**************************Load more janamaithri tickets*********************
  Future<bool> loadMoreTickets() async {
    try {
      isMoreTicketLoading = true;
      late final DateTime? createdAfter;
      late final DateTime? createdBefore;
      datePickerFromKey.currentState?.save();

      if (datePickerFromKey.currentState?.fields['from_date']?.value != null &&
          datePickerFromKey.currentState?.fields['to_date']?.value != null) {
        createdAfter = datePickerFromKey
            .currentState?.fields['from_date']?.value as DateTime;
        createdBefore = datePickerFromKey.currentState?.fields['to_date']?.value
            as DateTime;
      } else {
        createdAfter = null;
        createdBefore = null;
      }

      final List<TicketDetails> tickets = await HomeServices.getTicketDetails(
        endingTicketId,
        noOfTicketsToLoad + 1,
        createdAfter: createdAfter,
        createdBefore: createdBefore,
      );

      if (tickets.length <= noOfTicketsToLoad) {
        noMoreTickets = true;
        ticketsToDisplay.addAll(tickets);
      } else {
        noMoreTickets = false;
        endingTicketId = tickets.last.ticketId;
        tickets.removeLast();
        ticketsToDisplay.addAll(tickets);
      }
      isMoreTicketLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Search rail tickets***************************
  Future<void> sreachRailTickets() async {
    try {
      if (datePickerRailFromKey.currentState?.saveAndValidate() ?? false) {
        if (datePickerRailFromKey.currentState?.fields['from_date']?.value ==
                null ||
            datePickerRailFromKey.currentState?.fields['to_date']?.value ==
                null) {
          return;
        }
        noMoreRailTicket = true;

        final DateTime createdAfterLoc = datePickerRailFromKey
            .currentState?.fields['from_date']?.value as DateTime;
        final DateTime createdBeforeLoc = datePickerRailFromKey
            .currentState?.fields['to_date']?.value as DateTime;

        railTickets.clear();
        await loadRailTicket(
          createdAfterLoc,
          createdBeforeLoc,
        );
      }
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type: SnackbarType.error,
        message: 'Something went wrong! try again',
      );
    }
  }

  //******************************Load rail tickets*****************************
  Future<bool> loadRailTicket(
    DateTime? createdAfter,
    DateTime? createdBefore,
  ) async {
    isRailTicketLoading = true;
    try {
      final Map<String, String> queryParam = {
        'citizen_id': '${user?.citizenId}',
        'utc_timestamp__gte': '$createdAfter',
        'utc_timestamp__lte': '$createdBefore',
      };

      final List<RailTicketHistoryDetails> apiResponse =
          await RailServices.getRailTicketStatus(queryParam);

      tempListOfRailNotification = apiResponse;

      tempListOfRailNotification.sort(
        (a, b) {
          final int aDate =
              DateTime.parse(a.utcTimestamp ?? '').microsecondsSinceEpoch;
          final int bDate =
              DateTime.parse(b.utcTimestamp ?? '').microsecondsSinceEpoch;

          return bDate.compareTo(aDate);
        },
      );

      if (tempListOfRailNotification.isNotEmpty) {
        if (tempListOfRailNotification.length > railTicketsToShow) {
          for (var i = 0; i < tempListOfRailNotification.length; i++) {
            railTickets.add(tempListOfRailNotification[i]);
          }
          noMoreRailTicket = false;
        } else {
          noMoreRailTicket = true;
          railTickets = tempListOfRailNotification;
        }
      } else {
        railTickets.clear();
      }

      isRailTicketLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;
      railTickets = [];
      isRailTicketLoading = false;

      return false;
    }
  }

  //******************************Load more rail tickets************************
  Future<bool> loadMoreRailTickets() async {
    try {
      isMoreTicketLoading = true;
      late final DateTime? createdAfter;
      late final DateTime? createdBefore;
      datePickerRailFromKey.currentState?.save();

      if (datePickerRailFromKey.currentState?.fields['from_date']?.value !=
              null &&
          datePickerRailFromKey.currentState?.fields['to_date']?.value !=
              null) {
        createdAfter = datePickerRailFromKey
            .currentState?.fields['from_date']?.value as DateTime;
        createdBefore = datePickerRailFromKey
            .currentState?.fields['to_date']?.value as DateTime;
      } else {
        createdAfter = null;
        createdBefore = null;
      }

      final List<RailTicketDetails> railTickets =
          await HomeServices.getRailTicketDetails(
        endingTicketId,
        noOfTicketsToLoad + 1,
        createdAfter: createdAfter,
        createdBefore: createdBefore,
      );
      if (railTickets.length <= noOfTicketsToLoad) {
        noMoreTickets = true;
        railTicketsToDisplay.addAll(railTickets);
      } else {
        noMoreTickets = false;
        endingTicketId = railTickets.last.ticketId;
        railTickets.removeLast();
        railTicketsToDisplay.addAll(railTickets);
      }
      isMoreTicketLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }
}
