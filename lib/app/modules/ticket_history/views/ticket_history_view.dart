// ignore_for_file: must_be_immutable, avoid_unused_constructor_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/ticket_history_controller.dart';
import 'widgets/rail_ticket_history.dart';
import 'widgets/ticket_history.dart';

class TicketHistoryView extends GetView<TicketHistoryController> {
  const TicketHistoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF008585).withOpacity(0.8),
          title: Row(
            children: [
              const Expanded(flex: 2, child: SizedBox()),
              // Image.asset(
              //   AssetUrls.ICON_LOGO,
              //   scale: HEADER_LOGO_SCALE,
              // ),
              SizedBox(width: 4.w),
              Center(
                child: Text(
                  'Ticket History',
                  style: appHeaderStyle,
                ),
              ),
              const Expanded(flex: 4, child: SizedBox()),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(30, 25),
                    topRight: Radius.elliptical(30, 25),
                  ),
                ),
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_police,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 15.h,
                              ),
                              const Text(
                                'Janamaithri',
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.train,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 15.h,
                              ),
                              const Text(
                                'Railmaithri',
                              ),
                            ],
                          ),
                        ),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      controller: controller.tabController,
                      //controller: TicketHistoryController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF008586),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          FutureBuilder<bool>(
                            future: controller.isDataLoaded,
                            initialData: false,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.done:
                                  {
                                    return (snapshot.hasData && snapshot.data!)
                                        ? const TicketHistory()
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                  }

                                default:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                              }
                            },
                          ),
                          FutureBuilder<bool>(
                            future: controller.isDataLoaded,
                            initialData: false,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.done:
                                  {
                                    return (snapshot.hasData && snapshot.data!)
                                        ? const RailTicketHistory()
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                  }

                                default:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
