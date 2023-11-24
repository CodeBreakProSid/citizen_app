import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/contact_category.dart';
import '../../../data/railway_station_details.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_contact_details_controller.dart';

class PageContactDetailsView extends StatefulWidget {
  @override
  _PageContactDetailsView createState() => _PageContactDetailsView();
}

class _PageContactDetailsView extends State<PageContactDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<PageContactDetailsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_switchTabIndex);
  }

  void _switchTabIndex() {
    //print(_tabController.index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _showFilterSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return FormBuilder(
            key: controller.contactFormKey,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 16.sp),
              child: Padding(
                padding: SCREEN_PADDING,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.sp),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.filter_alt_rounded,
                            color: Colors.blue,
                            size: 15.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        const Expanded(
                          child: Text('Select filtering options'),
                        ),
                        Container(
                          width: 20.sp,
                          height: 20.sp,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: IconButton(
                            iconSize: 14.sp,
                            splashRadius: 25,
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownSearch<ContactCategory>(
                            items: controller.contactCategoryTypes,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(13.sp),
                                  child: Text(
                                    item.name,
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                );
                              },
                            ),
                            itemAsString: (item) => item.name,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.all(3.sp),
                                hintText: 'Category',
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedContactCategoryType = value;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8.h,
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownSearch<RailwayStationDetails>(
                            items: controller.railwayStaionList,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Text(
                                    '${item.name}',
                                    style: TextStyle(fontSize: 8.sp),
                                  ),
                                );
                              },
                            ),
                            itemAsString: (item) => '${item.name}',
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.all(3.sp),
                                hintText: 'Railway Station',
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedRailwayStation = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.loadContactList();
                            // Navigator.pop(context);
                          },
                          child: const Text('Apply',style: TextStyle(color: Colors.white,),),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.resetFilter();
                            // Navigator.pop(context);
                          },
                          child: const Text('Reset',style: TextStyle(color: Colors.white,),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        elevation: 5.0,
        backgroundColor: primaryColor,
        title: TabBar(
          dividerColor:Colors.transparent,
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
                    Icons.person,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  Text(
                    'Contacts',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Icon(
                    Icons.emergency_share,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  Text(
                    'Emergency',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.filter_alt_rounded),
              onPressed: () {
                _showFilterSheet();
              },
            )
          : Container(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllContacts(),
          EmergencyContacts(),
        ],
      ),
    );
  }
}

class AllContacts extends StatelessWidget {
  const AllContacts({super.key});

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: HOME_BOX_BORDER,
      backgroundBlendMode: BlendMode.multiply,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 1),
        ),
      ],
    );

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: decoration,
                child: GetBuilder<PageContactDetailsController>(
                  builder: (controller) {
                    if (controller.isContactListLoading) {
                      return Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: processingIndicator(),
                      );
                    }

                    if (controller.listOfContacts.isEmpty) {
                      return Text(
                        'NO CONTACT FOUND',
                        style: TEXT_WATER_MARK,
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listOfContacts.length,
                          itemBuilder: (context, int index) {
                            String contactEmailAdd = '';
                            final int contactID =
                                controller.listOfContacts[index].id;
                            final String district =
                                controller.listOfContacts[index].districtLabel;
                            final String? email =
                                controller.listOfContacts[index].contactEmail;
                            final String category = controller
                                .listOfContacts[index].contactsCategoryLabel;
                            final String serviceProviderName =
                                controller.listOfContacts[index].name;
                            final String contactNo =
                                controller.listOfContacts[index].contactNumber;
                            final String railwayPoliceStation = controller
                                .listOfContacts[index].policeStationLabel;
                            final String railwayStation = controller
                                .listOfContacts[index].railwayStationLabel;
                            contactEmailAdd = email == null || email == ''
                                ? 'No email'
                                : email;

                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final call = Uri.parse('tel:$contactNo');
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              child: Card(
                                surfaceTintColor: Colors.white,
                                margin: const EdgeInsets.all(3.0),
                                borderOnForeground: false,
                                elevation: 4.0.sp,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15.sp,
                                  ),
                                ),
                                shadowColor: Colors.black,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.sp,
                                    left: 8.sp,
                                    right: 8.sp,
                                    bottom: 8.sp,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment : CrossAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      color: Colors.blue,
                                                      size: 20.sp,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          serviceProviderName,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            // flex: 2,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      contactNo,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .local_police_rounded,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      railwayPoliceStation,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.directions_railway,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      railwayStation,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.mail,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      contactEmailAdd,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1.5.sp,
                                        color: primaryColor,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.merge_type,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: 5.h,
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.card_membership,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      'ID : $contactID',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      district,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        GetBuilder<PageContactDetailsController>(
                          builder: (controller) {
                            if (controller.noMoreContacts) {
                              return const SizedBox();
                            }

                            return controller.isMoreContactLoading
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.sp),
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
                                        controller.loadMoreContacts();
                                      },
                                      child: Text(
                                        'Load more',
                                        style: TextStyle(fontSize: 12.sp,color: Colors.white,),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EmergencyContacts extends StatelessWidget {
  const EmergencyContacts({super.key});

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: FORGROUND_COLOR,
      borderRadius: HOME_BOX_BORDER,
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -5,
          offset: Offset(0, 5),
        ),
      ],
    );

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: decoration,
                child: GetBuilder<PageContactDetailsController>(
                  builder: (controller) {
                    if (controller.isEMRContactListLoading) {
                      return Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: processingIndicator(),
                      );
                    }

                    if (controller.listOfEmergencyContacts.isEmpty) {
                      return Text(
                        'NO CONTACT FOUND',
                        style: TEXT_WATER_MARK,
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listOfEmergencyContacts.length,
                          itemBuilder: (context, int index) {
                            String contactEmailAdd = '';
                            final int contactID =
                                controller.listOfEmergencyContacts[index].id;
                            final String district = controller
                                .listOfEmergencyContacts[index].districtLabel;
                            final String? email = controller
                                .listOfEmergencyContacts[index].contactEmail;
                            final String category = controller
                                .listOfEmergencyContacts[index]
                                .contactsCategoryLabel;
                            final String serviceProviderName =
                                controller.listOfEmergencyContacts[index].name;
                            final String contactNo = controller
                                .listOfEmergencyContacts[index].contactNumber;
                            final String railwayPoliceStation = controller
                                .listOfEmergencyContacts[index]
                                .policeStationLabel;
                            final String railwayStation = controller
                                .listOfEmergencyContacts[index]
                                .railwayStationLabel;
                            contactEmailAdd = email == null || email == ''
                                ? 'No email'
                                : email;

                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final call = Uri.parse('tel:$contactNo');
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.all(3.0),
                                borderOnForeground: false,
                                elevation: 4.0.sp,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15.sp,
                                  ),
                                ),
                                shadowColor: Colors.black,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.sp,
                                    left: 8.sp,
                                    right: 8.sp,
                                    bottom: 8.sp,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      color: Colors.blue,
                                                      size: 25.sp,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          serviceProviderName,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      contactNo,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .local_police_rounded,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      railwayPoliceStation,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.directions_railway,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      railwayStation,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.mail,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      contactEmailAdd,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1.5.sp,
                                        color: primaryColor,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.merge_type,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.card_membership,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      'ID : $contactID',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      district,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        GetBuilder<PageContactDetailsController>(
                          builder: (_) {
                            if (_.noMoreEMRContacts) {
                              return const SizedBox();
                            }

                            return _.isMoreEMRContactLoading
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.sp),
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
                                        _.loadMoreEMRContacts();
                                      },
                                      child: Text(
                                        'Load more',
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
