import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/general_utils.dart';
import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';

class HomeTicketsView extends StatefulWidget {
  const HomeTicketsView({super.key});

  @override
  State<HomeTicketsView> createState() => _HomeTicketsViewState();
}

class _HomeTicketsViewState extends State<HomeTicketsView> {
  final controller = Get.find<HomeController>();
  final _decoration = const BoxDecoration(
    color: FORGROUND_COLOR,
    borderRadius: HOME_BOX_BORDER,
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        spreadRadius: -5,
        offset: Offset(2, -5),
      ),
    ],
  );
  final _tablePadding = EdgeInsets.only(bottom: 2.sp, top: 2.sp);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: SCREEN_PADDING,
      padding: EdgeInsets.all(2.sp),
      decoration: _decoration,
      child: Column(
        children: [
          Container(
            padding: SCREEN_PADDING,
            decoration: const BoxDecoration(
              color: COLOREDBOX_COLOR,
              borderRadius: HOME_BOX_BORDER,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45.sp,
                  height: 45.sp,
                  //child: OutlinedButton(
                  // onPressed: () {
                  //   if (controller.user!.isVerified) {
                  //     Get.toNamed(Routes.ADD_TICKET);
                  //   } else {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: const Text('Warning'),
                  //           content: Text(
                  //             'Only verified users can create support tickets, please verify your phone number',
                  //             textAlign: TextAlign.justify,
                  //             style: TextStyle(fontSize: 16.sp),
                  //           ),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () => Navigator.pop(context),
                  //               child: const Text('Cancel'),
                  //             ),
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //                 Get.toNamed(Routes.PROFILE);
                  //               },
                  //               child: const Text('Verify'),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   }
                  // },
                  // child: Text(
                  //   'New',
                  //   style: TextStyle(fontSize: 12.sp),
                  // ),
                  child: OutlinedButton(
                    onPressed: () {
                      controller.loadTickets(controller.startingTicketId);
                    },
                    child: const Icon(Icons.restart_alt_outlined),
                  ),
                  //),
                ),
                Expanded(
                  child: Text(
                    'Support Tickets',
                    textAlign: TextAlign.center,
                    style: TEXT_HEADER_STYLE,
                  ),
                ),
                GetBuilder<HomeController>(
                  builder: (controller) {
                    return SizedBox(
                      width: 45.sp,
                      height: 45.sp,
                      child: OutlinedButton(
                        onPressed: () {
                          // Get.toNamed(Routes.TICKET_HISTORY);
                          Get.toNamed(Routes.TICKET_HISTORY_DETAILS);
                        },
                        child: const Icon(Icons.history_sharp),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          GetBuilder<HomeController>(
            builder: (controller) {
              if (controller.isTicketLoading) {
                return Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: processingIndicator(),
                );
              }
              if (controller.tickets.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.tickets.length,
                  itemBuilder: (context, int index) {
                    final ticketId =
                        controller.tickets[index].ticketId.toString();
                    final ticketStatus = controller.ticketStatus.entries
                        .firstWhere(
                          (element) =>
                              element.value ==
                              controller.tickets[index].ticketStatus,
                        )
                        .key;
                    late final Color ticketStatusColor =
                        getTicketStatusColor(ticketStatus);
                    final ticketAssigned = controller.policeStations
                        .firstWhere(
                          (element) =>
                              element.stationId ==
                              controller.tickets[index].stationId,
                        )
                        .stationName;
                    final ticketCreated = DateFormat('dd/MM/yyyy, h:mm').format(
                      DateTime.parse(
                        controller.tickets[index].createdOn,
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
                              flex: 5,
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: _tablePadding,
                                        child: Text(
                                          'ID',
                                          style: TEXT_TICKET_STYLE,
                                        ),
                                      ),
                                      Padding(
                                        padding: _tablePadding,
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
                                        padding: _tablePadding,
                                        child: Text(
                                          'Status',
                                          style: TEXT_TICKET_STYLE,
                                        ),
                                      ),
                                      Padding(
                                        padding: _tablePadding,
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
                                        padding: _tablePadding,
                                        child: Text(
                                          'Assigned To',
                                          style: TEXT_TICKET_STYLE,
                                        ),
                                      ),
                                      Padding(
                                        padding: _tablePadding,
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
                                        padding: _tablePadding,
                                        child: Text(
                                          'Created On',
                                          style: TEXT_TICKET_STYLE,
                                        ),
                                      ),
                                      Padding(
                                        padding: _tablePadding,
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
                            Expanded(
                              child: Column(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.TICKET_DETAILS,
                                        arguments: {
                                          'ticket_id': controller
                                              .tickets[index].ticketId,
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.remove_red_eye_sharp,
                                    ),
                                  ),
                                  SizedBox(height: 50.sp),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Text(
                'NO TICKETS',
                style: TEXT_WATER_MARK,
              );
            },
          ),
        ],
      ),
    );
  }
}
