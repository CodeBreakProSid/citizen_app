import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/general_utils.dart';
import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/ticket_history_controller.dart';

class TicketHistory extends StatelessWidget {
  const TicketHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketHistoryController>();
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    return SingleChildScrollView(
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
          GetBuilder<TicketHistoryController>(
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
                                controller.ticketsToDisplay[index].ticketStatus,
                          )
                          .key;

                      late final Color ticketStatusColor =
                          getTicketStatusColor(ticketStatus);

                      final ticketAssigned = controller.policeStations
                          .firstWhere(
                            (element) =>
                                element.stationId ==
                                controller.ticketsToDisplay[index].stationId,
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
                                              .ticketsToDisplay[index].ticketId,
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
          GetBuilder<TicketHistoryController>(
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
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    );
            },
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
