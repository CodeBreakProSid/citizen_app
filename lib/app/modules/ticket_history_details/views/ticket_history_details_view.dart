// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/general_utils.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/ticket_history_details_controller.dart';

class TicketHistoryDetailsView extends StatefulWidget {
  //final int selectedTabIndex;

  //const TicketHistoryDetailsView({required this.selectedTabIndex});

  @override
  _TicketHistoryDetailsView createState() => _TicketHistoryDetailsView();
}

class _TicketHistoryDetailsView extends State<TicketHistoryDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<TicketHistoryDetailsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //_tabController.index = widget.selectedTabIndex;

    final arguments = Get.arguments;
    if (arguments != null && arguments['selectedTabIndex'] != null) {
      _tabController.index = arguments['selectedTabIndex'] as int;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 5.0,
        backgroundColor: primaryColor,
        title: TabBar(
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: primaryColor,
          ),
          tabs: [
            Tab(
              child: Row(
                children: [
                  const Icon(
                    Icons.local_police,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  Text(
                    'Janamaithri',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Icon(
                    Icons.train,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  Text(
                    'Railmaithri',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          JanamaithriTickets(),
          RailmaithriTickets(),
        ],
      ),
    );
  }
}

class JanamaithriTickets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketHistoryDetailsController>();
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              FormBuilder(
                key: controller.datePickerFromKey,
                child: Container(
                  decoration: const BoxDecoration(
                    color: FORGROUND_COLOR,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15)),
                    gradient:
                        LinearGradient(colors: [primaryColor, ICON_COLOR]),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        spreadRadius: -5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: SCREEN_PADDING,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ColoredBox(
                            color: Colors.white,
                            child: FormBuilderDateTimePicker(
                              name: 'from_date',
                              format: DateFormat('dd/MM/yyyy'),
                              decoration: InputDecoration(
                                hintText: 'From',
                                floatingLabelStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color(0xFF008585).withOpacity(0.8),
                                ),
                                contentPadding: EdgeInsets.all(2.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          flex: 3,
                          child: ColoredBox(
                            color: Colors.white,
                            child: FormBuilderDateTimePicker(
                              name: 'to_date',
                              format: DateFormat('dd/MM/yyyy'),
                              decoration: InputDecoration(
                                hintText: 'To',
                                floatingLabelStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color(0xFF008585).withOpacity(0.8),
                                ),
                                contentPadding: EdgeInsets.all(2.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            minWidth: 0,
                            height: 45.sp,
                            child: Icon(
                              size: 30,
                              Icons.search,
                              color: const Color(0xFF008585).withOpacity(0.8),
                            ),
                            onPressed: () {
                              controller.sreachTickets();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              GetBuilder<TicketHistoryDetailsController>(
                builder: (controller) {
                  if (controller.isTicketLoading) {
                    return Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: processingIndicator(),
                    );
                  }

                  if (controller.ticketsToDisplay.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.sp),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.ticketsToDisplay.length,
                        itemBuilder: (context, int index) {
                          final ticketId = controller
                              .ticketsToDisplay[index].ticketId
                              .toString();

                          final ticketStatus = controller.ticketStatus.entries
                              .firstWhere(
                                (element) =>
                                    element.value ==
                                    controller
                                        .ticketsToDisplay[index].ticketStatus,
                              )
                              .key;

                          late final Color ticketStatusColor =
                              getTicketStatusColor(ticketStatus);

                          final ticketAssigned = controller.policeStations
                              .firstWhere(
                                (element) =>
                                    element.stationId ==
                                    controller
                                        .ticketsToDisplay[index].stationId,
                              )
                              .stationName;

                          final ticketCreated =
                              DateFormat('dd/MM/yyyy, h:mm a').format(
                            DateTime.parse(
                              controller.ticketsToDisplay[index].createdOn,
                            ),
                          );

                          return Card(
                            color: darkModeBlack,
                            child: Padding(
                              padding: SCREEN_PADDING,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Table(
                                      children: [
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                'ID',
                                                style: TEXT_TICKET_STYLE,
                                              ),
                                            ),
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                ticketId,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                'Status',
                                                style: TEXT_TICKET_STYLE,
                                              ),
                                            ),
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                ticketStatus,
                                                style: TextStyle(
                                                  color: ticketStatusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                'Assigned To',
                                                style: TEXT_TICKET_STYLE,
                                              ),
                                            ),
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                ticketAssigned,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                'Created On',
                                                style: TEXT_TICKET_STYLE,
                                              ),
                                            ),
                                            Padding(
                                              padding: tablePadding,
                                              child: Text(
                                                ticketCreated,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            Routes.TICKET_DETAILS,
                                            arguments: {
                                              'ticket_id': controller
                                                  .ticketsToDisplay[index]
                                                  .ticketId,
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_sharp,
                                          color: const Color(0xFF008585)
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      SizedBox(height: 50.sp),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return SizedBox(
                    height: Get.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nearby_off_outlined,
                          size: 80.sp,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 8.sp),
                        Text(
                          'No janamaithri tickets',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 5.h),
              GetBuilder<TicketHistoryDetailsController>(
                builder: (controller) {
                  if (controller.noMoreTickets) {
                    return const SizedBox();
                  }

                  return controller.isMoreTicketLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.sp),
                          child: SizedBox(
                            height: 25.sp,
                            width: 25.sp,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          height: 35.sp,
                          width: 200.sp,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF008585)
                                  .withOpacity(0.8), //<-- SEE HERE
                            ),
                            onPressed: () {
                              controller.loadMoreTickets();
                            },
                            child: Text(
                              'Load more',
                              style: TextStyle(fontSize: 12.sp,color: Colors.white,),
                            ),
                          ),
                        );
                },
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }
}

class RailmaithriTickets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketHistoryDetailsController>();
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          FormBuilder(
            key: controller.datePickerRailFromKey,
            child: Container(
              decoration: const BoxDecoration(
                color: FORGROUND_COLOR,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
                gradient: LinearGradient(colors: [primaryColor, ICON_COLOR]),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    spreadRadius: -5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: SCREEN_PADDING,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ColoredBox(
                        color: Colors.white,
                        child: FormBuilderDateTimePicker(
                          name: 'from_date',
                          format: DateFormat('dd/MM/yyyy'),
                          decoration: InputDecoration(
                            hintText: 'From',
                            floatingLabelStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF008585).withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(2.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      flex: 3,
                      child: ColoredBox(
                        color: Colors.white,
                        child: FormBuilderDateTimePicker(
                          name: 'to_date',
                          format: DateFormat('dd/MM/yyyy'),
                          decoration: InputDecoration(
                            hintText: 'To',
                            floatingLabelStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF008585).withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(2.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        minWidth: 0,
                        height: 45.sp,
                        child: Icon(
                          size: 30,
                          Icons.search,
                          color: const Color(0xFF008585).withOpacity(0.8),
                        ),
                        onPressed: () {
                          controller.sreachRailTickets();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          GetBuilder<TicketHistoryDetailsController>(
            builder: (controller) {
              if (controller.isRailTicketLoading) {
                return Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: processingIndicator(),
                );
              }

              if (controller.railTickets.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.sp),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.railTickets.length,
                    itemBuilder: (context, int index) {
                      late final Icon notificationIcon;
                      late final String notificationType;
                      late final String ticketCategoryType;

                      final String notificationCreatedon =
                          DateFormat('dd/MM/yyyy, h:mm a').format(
                        DateTime.parse(
                          controller.railTickets[index].utcTimestamp.toString(),
                        ),
                      );

                      ticketCategoryType = controller
                          .railTickets[index].ticketTypeLabel
                          .toString();

                      final String ticketStatusType =
                          controller.railTickets[index].statusLabel.toString();

                      late final Color ticketStatusColor =
                          getRailTicketStatusColor(ticketStatusType);

                      switch (ticketStatusType) {
                        case RailTicketStatusTypeConst.TICKET_TYPE_1:
                          notificationIcon = Icon(
                            FontAwesomeIcons.ticket,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'OPEN';
                          break;

                        case RailTicketStatusTypeConst.TICKET_TYPE_2:
                          notificationIcon = Icon(
                            Icons.check_circle,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'ASSIGNED';
                          break;

                        case RailTicketStatusTypeConst.TICKET_TYPE_3:
                          notificationIcon = Icon(
                            FontAwesomeIcons.ban,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'REJECTED';
                          break;

                        case RailTicketStatusTypeConst.TICKET_TYPE_4:
                          notificationIcon = Icon(
                            Icons.done_all,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'ATTENDED';
                          break;

                        case RailTicketStatusTypeConst.TICKET_TYPE_5:
                          notificationIcon = Icon(
                            FontAwesomeIcons.calendarCheck,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'CLOSED';
                          break;

                        default:
                          notificationIcon = Icon(
                            FontAwesomeIcons.closedCaptioning,
                            size: 40.sp,
                            color: ticketStatusColor,
                          );
                          notificationType = 'NONE';
                          break;
                      }

                      return Card(
                        color: darkModeBlack,
                        child: Padding(
                          padding: EdgeInsets.all(2.sp),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [notificationIcon],
                              ),
                              SizedBox(width: 20.sp),
                              Expanded(
                                child: Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            'Category',
                                            style: TEXT_TICKET_STYLE,
                                          ),
                                        ),
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            ticketCategoryType,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            'Status',
                                            style: TEXT_TICKET_STYLE,
                                          ),
                                        ),
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            notificationType,
                                            style: TextStyle(
                                              color: ticketStatusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            'ID',
                                            style: TEXT_TICKET_STYLE,
                                          ),
                                        ),
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            '${controller.railTickets[index].id}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            'Date',
                                            style: TEXT_TICKET_STYLE,
                                          ),
                                        ),
                                        Padding(
                                          padding: tablePadding,
                                          child: Text(
                                            notificationCreatedon,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return SizedBox(
                height: Get.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.nearby_off_outlined,
                      size: 80.sp,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'No Rail tickets',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          //SizedBox(height: 5.h),
          // GetBuilder<TicketHistoryController>(
          //   builder: (controller) {
          //     if (controller.noMoreTickets) {
          //       return const SizedBox();
          //     }

          //     return controller.isMoreTicketLoading
          //         ? Padding(
          //             padding: EdgeInsets.symmetric(vertical: 10.sp),
          //             child: SizedBox(
          //               height: 25.sp,
          //               width: 25.sp,
          //               child: const CircularProgressIndicator(),
          //             ),
          //           )
          //         : SizedBox(
          //             height: 35.sp,
          //             width: 200.sp,
          //             child: ElevatedButton(
          //               style: OutlinedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF008585)
          //                     .withOpacity(0.8), //<-- SEE HERE
          //               ),
          //               onPressed: () {
          //                 controller.loadMoreRailTickets();
          //               },
          //               child: Text(
          //                 'Load more',
          //                 style: TextStyle(fontSize: 12.sp),
          //               ),
          //             ),
          //           );
          //   },
          // ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
