import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

import '../data/ticket_component_group.dart';
import '../data/ticket_component_group_details.dart';
import '../data/ticket_details.dart';
import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';
import '../util/global_widgets.dart';

class TicketServices 
{
  static final apiHelper  = ApiHelper();
  static final box        = GetStorage();


  //***********************Get Ticket componet group from DB********************
  static Future<List<TicketComponentGroup>> getTicketComponentGroup(
                        int ticketId,
                        int fromComponentId,
                        int limit,) async {
    try {
      final apiResponse = await apiHelper.getData(
                        ApiUrls.COMPONENT_GROUP_LIST,
                        query       : {
                                      'ticket_id'         : '$ticketId',
                                      'from_component_id' : '$fromComponentId',
                                      'limit'             : '$limit',
                                      },
                        accessToken : box.read(ApiConst.Key),
                      );

      if (apiResponse['success'] as bool) 
      {
        final jsonData  = apiResponse['data'] as List;

        return jsonData
            .map(
              (e) => TicketComponentGroup.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //***********************Get Ticket componet details from DB******************
  static Future<TicketComponentGroupDetails?> getTicketComponentGroupDetails(
                int componentGroupId,) async {
    try {
      final apiResponse = await apiHelper.getData(
                ApiUrls.COMPONENT_GROUP_DETAILS,
                query       : {
                              'component_id': '$componentGroupId',
                              },
                accessToken : box.read(ApiConst.Key),
              );

      if (apiResponse['success'] as bool) {
        return TicketComponentGroupDetails.fromJson(
          apiResponse['data'] as Map<String, dynamic>,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Get Ticket types from Memory/DB**********************
  static Future<Map<String, dynamic>> getTicketTypes({
                          bool isUpdate = false,
                        }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.TICKET_TYPE) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.TICKET_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        await box.write(ApiConst.TICKET_TYPE, jsonData);

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Create new janamaithri ticket************************
  static Future<TicketDetails?> createNewTicket(
                        String ticketTypeId,
                        int stationId,) async {
    try {
      final apiResponse = await apiHelper.postData(
                        ApiUrls.CREATE_NEW_TICKET,
                        formData      : FormData({
                                                  'station_id': '$stationId',
                                                  'ticket_type': ticketTypeId,
                                                }),
                        accessToken   : box.read(ApiConst.Key),
                      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return TicketDetails.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Create new component group***************************
  static Future<TicketComponentGroup?> createNewComponentGroup(
                        FormData formData,) async {
    try {
      final apiResponse = await apiHelper.postData(
                        ApiUrls.ADD_NEW_COMPONENT_GROUP,
                        accessToken : box.read(ApiConst.Key),
                        formData    : formData,
                      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return TicketComponentGroup.fromJson(jsonData);
      } else {
        showSnackBar(
          type    : SnackbarType.error,
          message : apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }
}
