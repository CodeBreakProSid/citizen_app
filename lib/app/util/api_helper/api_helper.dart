// ignore_for_file: avoid_final_parameters

import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'api_const.dart';

class ApiHelper extends GetConnect 
{
  static final ApiHelper _apiHelper = ApiHelper._internal();
  factory ApiHelper() => _apiHelper;
  ApiHelper._internal();
  final box = GetStorage();

  @override
  bool get allowAutoSignedCert => true;

  @override
  void onInit() 
  {
    allowAutoSignedCert = true;
    super.onInit();
  }

  //get API call support function
  Future<Map<String, dynamic>> getData(
    final String url, {
    final Map<String, String>? query,
    final String? accessToken,
  }) async 
  {
    final authToken = accessToken ?? '${ApiConst.TOKEN_TYPE} wrong_code';
    final response  = await get(
      url,
      query: query,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        'Accept': 'application/json',
        'Authorization': authToken,
      },
    );

    return makeJsonResponse(response);
  }

  //postSignup API call support function
  Future<Map<String, dynamic>> postSignup(
    final String url,
    final FormData formData,
  ) async 
  {
    final response = await post(
      url,
      formData,
      query: {},
      headers: {
        'Accept': 'application/json',
      },
    );

    return makeJsonResponse(response);
  }

  //post API call support function
  Future<Map<String, dynamic>> postData(
    final String url, {
    final dynamic formData,
    final Map<String, String>? query,
    final String? accessToken,
  }) async 
  {
    final authToken = accessToken ?? '${ApiConst.TOKEN_TYPE} wrong_code';
    final response  = await post(
      url,
      formData,
      query: query,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        'Accept': 'application/json',
        'Authorization': authToken,
      },
    );

    return makeJsonResponse(response);
  }

  //put API call support function
  Future<Map<String, dynamic>> putData(
    final String url, {
    final dynamic formData,
    final Map<String, dynamic>? query,
    final String? accessToken,
  }) async 
  {
    final authToken = accessToken ?? '';
    final response  = await put(
      url,
      formData,
      query: query,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        'Accept': 'application/json',
        'Authorization': authToken,
      },
    );

    return makeJsonResponse(response);
  }

  //delete API call support function
  Future<Map<String, dynamic>> deleteData(
    final String url, {
    final Map<String, dynamic>? query,
    final String? accessToken,
  }) async 
  {
    final authToken = accessToken ?? '';
    final response  = await delete(
      url,
      query: query,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        'Accept': 'application/json',
        'Authorization': authToken,
      },
    );

    return makeJsonResponse(response);
  }

  //API response maker support function
  Future<Map<String, dynamic>> makeJsonResponse(Response response) async 
  {
    return response.isOk
        ? {
            'success': true,
            'statusCode': response.statusCode,
            'data': response.body,
          }
        : {
            'success': false,
            'statusCode': response.statusCode,
            'error': response.body != null
                ? (response.body as Map<String, dynamic>)['detail'] ??
                    // ignore: avoid_dynamic_calls
                    (response.body as Map<String, dynamic>)['non_field_errors'][0] as String?//exceptional case when railmaithri api gives deleted/masked error.
                : 'Invalid response from the server',
          };
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) 
  {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
