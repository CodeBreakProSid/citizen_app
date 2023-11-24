import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/general_utils.dart';
import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';

class CallHistoryView extends StatefulWidget {
  const CallHistoryView({super.key});

  @override
  State<CallHistoryView> createState() => _CallHistoryViewState();
}

class _CallHistoryViewState extends State<CallHistoryView> {
  final controller = Get.find<HomeController>();
  final _decoration = const BoxDecoration(
    color: FORGROUND_COLOR,
    borderRadius: HOME_BOX_BORDER,
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        spreadRadius: -5,
        offset: Offset(2, -2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    return Container(
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
                  child: OutlinedButton(
                    onPressed: () {
                      controller.loadCallHistory();
                    },
                    child: const Icon(Icons.restart_alt_outlined),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Meeting History',
                    textAlign: TextAlign.center,
                    style: TEXT_HEADER_STYLE,
                  ),
                ),
                SizedBox(
                  width: 45.sp,
                  height: 45.sp,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(Routes.CALL_HISTORY);
                    },
                    child: const Icon(Icons.manage_history),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          GetBuilder<HomeController>(
            builder: (controller) {
              if (controller.isCallHistoryLoading) {
                return Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: processingIndicator(),
                );
              }

              if (controller.meetings.isEmpty) {
                return Text(
                  'NO CALLS',
                  style: TEXT_WATER_MARK,
                );
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.meetings.length,
                itemBuilder: (context, int index) {
                  final int meetingId = controller.meetings[index].meetingId;
                  final meetingType = controller.meetingState.entries
                      .firstWhere(
                        (element) =>
                            element.value ==
                            controller.meetings[index].meetingState,
                      )
                      .key;
                  late final Color meetingTypeColor =
                      getMeetingColor(meetingType);
                  final meetingCreated =
                      DateFormat('dd/MM/yyyy, h:mm').format(
                    DateTime.parse(
                      controller.meetings[index].createdOn,
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
                                        '$meetingId',
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
                                        meetingType,
                                        style: TextStyle(
                                          color: meetingTypeColor,
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
                                        'Created On',
                                        style: TEXT_TICKET_STYLE,
                                      ),
                                    ),
                                    Padding(
                                      padding: tablePadding,
                                      child: Text(
                                        meetingCreated,
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
                                onPressed: () {
                                  Get.toNamed(
                                    Routes.ADD_TICKET,
                                    arguments: meetingId,
                                  );
                                },
                                child: const Icon(
                                  Icons.add_circle_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
