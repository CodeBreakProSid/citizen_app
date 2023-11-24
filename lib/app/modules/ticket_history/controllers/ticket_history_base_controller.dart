import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../data/police_station.dart';
import '../../../data/rail_ticket_details.dart';
import '../../../data/ticket_details.dart';
import '../../../data/train.dart';
import '../../../data/user.dart';
import '../../../services/user_services.dart';

class TicketHistoryBaseController extends GetxController {
  final datePickerFromKey = GlobalKey<FormBuilderState>();
  final datePickerRailFromKey = GlobalKey<FormBuilderState>();
  final int maxInt = 4294967296;

  final userServices = UserServices();

  late String userName;
  late final Map<String, dynamic> ticketStatus;
  late final List<PoliceStation> policeStations;
  late final Future<bool> isDataLoaded;
  late List<TicketDetails> tickets;
  User? _user;
  TabController? tabController;

  int startingTicketId = 429496729600;
  int railTicketsToShow = 10;
  int noOfTicketsToLoad = 10;
  int endingTicketId = 1;

  List _railTickets = [];
  List<TicketDetails> ticketsToDisplay = [];
  List<Train> trains = [];
  List<RailTicketDetails> railTicketsToDisplay = [];

  bool _isTicketLoading = false;
  bool _isRailTicketLoading = false;
  bool _isMoreTicketLoading = false;
  bool _noMoreTickets = false;
  bool _noMoreRailTicket = false;

  bool get noMoreRailTicket => _noMoreRailTicket;
  set noMoreRailTicket(bool v) => {_noMoreRailTicket = v, update()};

  bool get isTicketLoading => _isTicketLoading;
  set isTicketLoading(bool v) => {_isTicketLoading = v, update()};

  bool get isRailTicketLoading => _isRailTicketLoading;
  set isRailTicketLoading(bool v) => {_isRailTicketLoading = v, update()};

  bool get noMoreTickets => _noMoreTickets;
  set noMoreTickets(bool v) => {_noMoreTickets = v, update()};

  bool get isMoreTicketLoading => _isMoreTicketLoading;
  set isMoreTicketLoading(bool v) => {_isMoreTicketLoading = v, update()};

  List get railTickets => _railTickets;
  set railTickets(List v) => {_railTickets = v, update()};

  User? get user => _user;
  set user(User? v) => {_user = v, userName = user?.username ?? '', update()};
}
