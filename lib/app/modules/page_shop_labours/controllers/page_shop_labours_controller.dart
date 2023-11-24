// ignore_for_file: use_build_context_synchronously, prefer_final_locals

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/shop_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import 'page_shop_labours_base_controller.dart';

class PageShopLaboursController extends PageShopLaboursBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  int? shopsCount = 0;
  String? next = '';
  List? tempListOfShops = [];
  static final box = GetStorage();
  Map<String, dynamic> tempEmployeeFormData = {};

  //******************************Initial load function*************************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        // final homeController = Get.find<HomeController>();

        // genderTypes = await box.read(ApiConst.GENDER_TYPE) == null
        //     ? await OtherServices.getGenders(isUpdate: true)
        //     : await OtherServices.getGenders();

        // stateList =
        //     homeController.stateList ?? await RailServices.getStateList();
        // staffPorterTypes = homeController.staffPorterTypes ??
        //     await RailServices.getStaffPorterCategoryType();
        // shopCategoryTypes = homeController.shopCategoryTypes ??
        //     await RailServices.getShopCategoryType();
        // railwayStaionList = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();

        genderTypes = await box.read(ApiConst.GENDER_TYPE) == null
            ? await OtherServices.getGenders(isUpdate: true)
            : await OtherServices.getGenders();
        stateList = await box.read(ApiConst.STATE_LIST) == null
            ? await RailServices.getStateList(isUpdate: true)
            : await RailServices.getStateList();
        staffPorterTypes = await box.read(ApiConst.STAFF_PORTER_TYPE) == null
            ? await RailServices.getStaffPorterCategoryType(isUpdate: true)
            : await RailServices.getStaffPorterCategoryType();
        shopCategoryTypes = await box.read(ApiConst.SHOP_CATEGORY_TYPE) == null
            ? await RailServices.getShopCategoryType(isUpdate: true)
            : await RailServices.getShopCategoryType();
        railwayStaionList = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();

        user = await UserServices().getUser();

        //Get user gender
        genderTypes.forEach(
          (key, value) {
            if (user?.genderType == value) {
              gender = value;

              return;
            }
          },
        );

        //await loadShopList();

        currentLocation = await getCurrentLocation();

        return true;
      }
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Load shop list********************************
  Future<void> loadShopList() async {
    try {
      shopListIsLoading = true;

      final String selectedSC = selectedShopCategoryType == null
          ? ''
          : '${selectedShopCategoryType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'shop_category': selectedSC,
        'railway_station': selectedRS,
      };

      const String apiURL = '';

      apiResponse = await RailServices.getShopList(
        queryParam,
        apiURL,
      );

      shopsCount = apiResponse['count'] as int;
      next = apiResponse['next'] as String?;
      tempListOfShops = apiResponse['results'] as List;
      initialListOfShops = tempListOfShops!
          .map(
            (e) => ShopDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfShops!.isNotEmpty) {
        shopList.clear();
        if (initialListOfShops.length > notificationToShow && next != null) {
          for (var i = 0; i < initialListOfShops.length; i++) {
            shopList.add(initialListOfShops[i]);
          }
          noMoreShops = false;
        } else {
          noMoreShops = true;
          shopList = initialListOfShops;
        }
      } else {
        shopList.clear();
      }

      shopListIsLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      shopListIsLoading = false;

      return;
    }
  }

  //******************************Load more shop list***************************
  Future<void> loadMoreShopList() async {
    try {
      isMoreShopsLoading = true;

      final String selectedSC = selectedShopCategoryType == null
          ? ''
          : '${selectedShopCategoryType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'shop_category': selectedSC,
        'railway_station': selectedRS,
      };
      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfShops!.clear();
        noMoreShops = true;
      } else {
        apiResponse = await RailServices.getShopList(
          queryParam,
          apiURL,
        );

        shopsCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfShops = apiResponse['results'] as List;
        moreListOfShops = tempListOfShops
            .map(
              (e) => ShopDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfShops!.isNotEmpty) {
        if (moreListOfShops.length > notificationToShow) {
          for (var i = 0; i < moreListOfShops.length; i++) {
            shopList.add(moreListOfShops[i]);
          }
          noMoreShops = false;
        } else {
          shopList.addAll(moreListOfShops);
          noMoreShops = true;
        }
      }

      isMoreShopsLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreShopsLoading = false;

      return;
    }
  }

  //******************************Reset filter**********************************
  Future<void> resetFilter() async {
    try {
      shopListIsLoading = true;

      const String selectedSC = '';
      const String selectedRS = '';

      final Map<String, String> queryParam = {
        'shop_category': selectedSC,
        'railway_station': selectedRS,
      };

      const String apiURL = '';

      apiResponse = await RailServices.getShopList(
        queryParam,
        apiURL,
      );

      shopsCount = apiResponse['count'] as int;
      next = apiResponse['next'] as String?;
      tempListOfShops = apiResponse['results'] as List;
      initialListOfShops = tempListOfShops!
          .map(
            (e) => ShopDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfShops!.isNotEmpty) {
        shopList.clear();
        if (initialListOfShops.length > notificationToShow && next != null) {
          for (var i = 0; i < initialListOfShops.length; i++) {
            shopList.add(initialListOfShops[i]);
          }
          noMoreShops = false;
        } else {
          noMoreShops = true;
          shopList = initialListOfShops;
        }
      } else {
        shopList.clear();
      }

      shopListIsLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      shopListIsLoading = false;

      return;
    }
  }

  //******************************Get location service**************************
  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!await Permission.location.isGranted) {
        return null;
      }
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  //******************************Add employee view handler*********************
  void addEmployee() {
    try {
      if (emplFormKey.currentState?.saveAndValidate() ?? false) {
        listOfEmployees.addIf(
          emplFormKey.currentState!.value != {} &&
              emplFormKey.currentState!.value['empName'] != null,
          emplFormKey.currentState!.value,
        );
        update();
        Navigator.pop(Get.context!);
      }
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************View employee view handler********************
  void viewEmployes(int index, BuildContext context) {
    try {
      showEmployeeUpdateView(
        context,
        () => updateEmploye(index),
        values: listOfEmployees[index],
      );
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //****************************Update employee view handler********************
  void updateEmploye(int index) {
    try {
      if ((emplFormKey.currentState?.saveAndValidate() ?? false) &&
          emplFormKey.currentState!.value['empName'] != null) {
        listOfEmployees[index] = emplFormKey.currentState!.value;
        update();
        Navigator.pop(Get.context!);
      }
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //****************************Delete employee view handler********************
  void deleteEmploye(int index) {
    try {
      listOfEmployees.removeAt(index);
      update();
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //****************************Create shop & employees*************************
  Future<void> saveShopsLabour() async {
    try {
      if (listOfEmployees.isEmpty) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Add atleast one employee or make owner as employee',
        );
      } else {
        isUploading = true;
        shopFormKey.currentState?.save();

        final int shopCategoryId =
            selectedShopCategoryType?.id ?? shopCategoryTypes.first.id;
        final String shopName =
            '${shopFormKey.currentState?.fields['shopName']?.value}';
        final String ownerName =
            '${shopFormKey.currentState?.fields['ownerName']?.value}';
        final String ownerAadhaarNumber =
            '${shopFormKey.currentState?.fields['aadhaarNo']?.value}';
        final String ownerMobileNumber =
            '${shopFormKey.currentState?.fields['mobileNo']?.value}';
        final String shopLicenseNo =
            '${shopFormKey.currentState?.fields['LicenseNo']?.value}';
        final int? railwayStationId =
            selectedRailwayStation?.id ?? railwayStaionList.first.id;
        final String platformNumber =
            '${shopFormKey.currentState?.fields['platformNo']?.value}';
        final double? latitude = currentLocation?.latitude;
        final double? longitude = currentLocation?.longitude;

        final Map<String, dynamic> formData = {
          'shop_category': shopCategoryId,
          'name': shopName,
          'data_from': ApiConst.API_CALL_FROM,
          'owner_name': ownerName,
          'licence_number': shopLicenseNo,
          'aadhar_number': ownerAadhaarNumber,
          'contact_number': ownerMobileNumber,
          'railway_station': railwayStationId,
          'platform_number': platformNumber,
          'latitude': latitude,
          'longitude': longitude,
          'utc_timestamp': '${DateTime.now()}',
          // 'utc_timestamp': DateTime.now(),
          'citizen_id': user?.citizenId,
        };

        Map<String, dynamic> tempFormData = Map.from(formData);

        for (final entry in tempFormData.entries) {
          if (entry.value.toString() == 'null' ||
              entry.value.toString() == '') {
            formData.remove(entry.key);
          }
        }

        await RailServices.createShop(
          FormData(formData),
        ).then((value) async {
          if (value != null) {
            showSnackBar(
              type: SnackbarType.success,
              message: 'Shop created successfully',
            );
            final int? shopId = value.id;

            for (int i = 0; i < listOfEmployees.length; i++) {
              final Map<String, dynamic> empFormData = {
                'shop': shopId,
                'name': listOfEmployees[i]['empName'],
                'gender': GenderTypeConst.GENDER_TYPE[
                    int.parse(listOfEmployees[i]['genderType'] as String) - 1],
                'mobile_number': listOfEmployees[i]['mobileNumber'],
                'aadhar_number': listOfEmployees[i]['aadhaarNumber'],
                'address': listOfEmployees[i]['empAddress'],
                'native_police_station': listOfEmployees[i]['nativePS'],
                'native_state': listOfEmployees[i]['nativeStateId'],
                'utc_timestamp': DateTime.now(),
              };

              tempEmployeeFormData = Map.from(empFormData);

              for (final entry in tempEmployeeFormData.entries) {
                if (entry.value.toString() == 'null' ||
                    entry.value.toString() == '') {
                  empFormData.remove(entry.key);
                }
              }
              tempEmployeeFormData.clear();

              await RailServices.createLabour(
                FormData(empFormData),
              ).then((value) {
                if (value != null) {
                  showSnackBar(
                    type: SnackbarType.success,
                    message: 'Employee ${value.name} created successfully',
                  );
                }
              });
            }

            Get.offAllNamed(Routes.HOME);
          }
        });

        isUploading = false;
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      isUploading = false;
    }
  }

  //******************************Add employee form view************************
  void showEmployeeView(
    BuildContext context,
    void Function()? fun, {
    Map<String, dynamic>? values,
  }) {
    late final List<DropdownMenuItem<String>> stateName = [];
    for (final element in stateList) {
      stateName.add(
        DropdownMenuItem<String>(
          value: '${element.id}',
          child: Text(
            element.name,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    late final List<DropdownMenuItem<String>> genderType = [];

    for (final element in genderTypes.entries) {
      genderType.add(
        DropdownMenuItem<String>(
          value: '${element.value}',
          child: Text(
            element.key,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    showAnimatedDialog(
      AlertDialog(
        alignment: Alignment.center,
        contentPadding: EdgeInsets.zero,
        scrollable: true,
        content: Container(
          width: Get.width * 0.85,
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FormBuilder(
            key: emplFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50.sp,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25.sp)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Add Employee',
                            textAlign: TextAlign.center,
                            style: SUB_HEADER_STYLE,
                          ),
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
                        SizedBox(
                          width: 20.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Column(
                      children: [
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'empName',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Name',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Employee name required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderDropdown<String>(
                          name: 'genderType',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Gender',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          items: genderType,
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          name: 'mobileNumber',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Mobile No',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (!RegExp(
                              r'(^(?:[+0]9)?[0-9]{10}$)',
                            ).hasMatch(value)) {
                              return 'Please enter valid mobile number';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          name: 'aadhaarNumber',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Aadhaar No',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value != '') {
                              if (!RegExp(
                                r'^[1-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$',
                              ).hasMatch(value)) {
                                return 'Please enter proper Aadhaar No';
                              } else if (int.tryParse(value)!.isNegative) {
                                return 'Negative number not allowed';
                              }
                              // else if (value[0] != '2') {
                              //   return 'Aadhaar starts with digit 2';
                              // }
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'empAddress',
                          maxLines: 3,
                          maxLength: 150,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            helperText: '(It accept max 150 characters)',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderDropdown<String>(
                          name: 'nativeStateId',
                          borderRadius: CIRCULAR_BORDER,
                          decoration: InputDecoration(
                            labelText: 'State',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                          ),
                          items: stateName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Native state required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'nativePS',
                          decoration: InputDecoration(
                            labelText: 'Native Police Station',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Native police station required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          height: 35.sp,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: fun,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: Text(
                              (values != null) ? 'Update' : 'Add',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.sp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      context,
    );
  }

  //******************************Update employee data form view****************
  void showEmployeeUpdateView(
    BuildContext context,
    void Function()? fun, {
    Map<String, dynamic>? values,
  }) {
    late final List<DropdownMenuItem<String>> stateName = [];
    for (final element in stateList) {
      stateName.add(
        DropdownMenuItem<String>(
          value: '${element.id}',
          child: Text(
            element.name,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    late final List<DropdownMenuItem<String>> genderType = [];

    for (final element in genderTypes.entries) {
      genderType.add(
        DropdownMenuItem<String>(
          value: '${element.value}',
          child: Text(
            element.key,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    showAnimatedDialog(
      AlertDialog(
        alignment: Alignment.center,
        contentPadding: EdgeInsets.zero,
        scrollable: true,
        content: Container(
          width: Get.width * 0.85,
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FormBuilder(
            key: emplFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50.sp,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 50.sp),
                        Expanded(
                          child: Text(
                            'Edit Employee',
                            textAlign: TextAlign.center,
                            style: SUB_HEADER_STYLE,
                          ),
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
                        SizedBox(
                          width: 20.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Column(
                      children: [
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'empName',
                          initialValue: values?['empName'].toString(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Name',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Employee name required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderDropdown<String>(
                          name: 'genderType',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Gender',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          items: genderType,
                          initialValue: '${values?.values.elementAt(1)}',
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          name: 'mobileNumber',
                          initialValue: values?['mobileNumber'].toString(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Mobile No',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (!RegExp(
                              r'(^(?:[+0]9)?[0-9]{10}$)',
                            ).hasMatch(value)) {
                              return 'Please enter valid mobile number';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          name: 'aadhaarNumber',
                          initialValue: values?['aadhaarNumber'].toString(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            labelText: 'Aadhaar No',
                            labelStyle: HINT_TEXT_LABEL,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value != '') {
                              if (!RegExp(
                                r'^[1-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$',
                              ).hasMatch(value)) {
                                return 'Please enter proper Aadhaar No';
                              } else if (int.tryParse(value)!.isNegative) {
                                return 'Negative number not allowed';
                              }
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'empAddress',
                          initialValue: values?['empAddress'].toString(),
                          minLines: 3,
                          maxLines: 150,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                            helperText: '(It accept max 150 characters)',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderDropdown<String>(
                          name: 'nativeStateId',
                          borderRadius: CIRCULAR_BORDER,
                          decoration: InputDecoration(
                            labelText: 'State',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                          ),
                          items: stateName,
                          initialValue: '${values?.values.elementAt(5)}',
                          // hint: const Text('Select state'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Native state required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 8.sp),
                        FormBuilderTextField(
                          name: 'nativePS',
                          initialValue: values?['nativePS'].toString(),
                          decoration: InputDecoration(
                            labelText: 'Native Police Station',
                            labelStyle: HINT_TEXT_LABEL,
                            border: OutlineInputBorder(
                              borderRadius: HINT_BOARDER_STYLE,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Native police station required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 16.sp),
                        SizedBox(
                          height: 35.sp,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: fun,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              (values != null) ? 'Update' : 'Add',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.sp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      context,
    );
  }
}
