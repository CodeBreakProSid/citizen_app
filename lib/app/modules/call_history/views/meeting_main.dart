import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../util/general_utils.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/call_history_controller.dart';

class MeetingMain extends StatelessWidget {
  const MeetingMain({super.key});

  @override
  Widget build(BuildContext context) {
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);
    final controller = Get.find<CallHistoryController>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          FormBuilder(
            key: controller.datePickerFromKey,
            child: Container(
              decoration: const BoxDecoration(
                color: FORGROUND_COLOR,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
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
                            labelText: 'From',
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
                            labelText: 'To',
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
                          Icons.search,
                          size: 30,
                          color: const Color(0xFF008585).withOpacity(0.8),
                        ),
                        onPressed: () {
                          controller.sreachMeetings();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          GetBuilder<CallHistoryController>(
            builder: (controller) {
              if (controller.isMeetingsLoading) {
                return Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: processingIndicator(),
                );
              }

              if (controller.meetings.isNotEmpty) {
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
                        DateFormat('dd/MM/yyyy, h:mm a').format(
                      DateTime.parse(
                        controller.meetings[index].createdOn,
                      ),
                    );
                    final meetingDuration = durationToString(
                      DateTime.parse(controller.meetings[index].endTime)
                          .toLocal()
                          .difference(
                            DateTime.parse(controller.meetings[index].startTime)
                                .toLocal(),
                          )
                          .inMinutes,
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
                                          'Duration',
                                          style: TEXT_TICKET_STYLE,
                                        ),
                                      ),
                                      Padding(
                                        padding: tablePadding,
                                        child: Text(
                                          meetingDuration,
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
                                SizedBox(height: 50.sp),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return SizedBox(
                height: Get.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_cell,
                      size: 80.sp,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'No meetings',
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
          GetBuilder<CallHistoryController>(
            builder: (controller) {
              if (controller.noMoreMeetings) {
                return const SizedBox();
              }

              return controller.isMoreMeetingsLoading
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
                        onPressed: () {
                          controller.loadMoreMeetings();
                        },
                        child: Text(
                          'Load more',
                          style: TextStyle(fontSize: 12.sp,color: Colors.white,
                          ),
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
