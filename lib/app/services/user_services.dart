import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/user.dart';
import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';

class UserServices extends GetxService 
{
  static final apiHelper  = ApiHelper();
  static final box        = GetStorage();
  User? user;

  //**************Initial fun call for take user details from memory************
  Future<UserServices> init() async {
    user = await getUser();

    return this;
  }

  //********************Get user details from internal memory*******************
  Future<User?> getUser() async {
    try {
      final jsonUser = await box.read('user');

      return jsonUser != null
          ? User.fromJson(jsonUser as Map<String, dynamic>)
          : null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }


  //********************Save user to internal memory****************************
  Future<void> saveUser(User? savableUser) async {
    await box.write('user', savableUser?.toJson());
    user = savableUser;
  }


  //********************Remove user from internal memory************************
  Future<void> removeUser() async {
    await box.remove('user');
    user = null;
  }


  //********************Get gender type from Memory/DB**************************  
  static Future<Map<String, dynamic>> getGenderTypes({bool isUpdate = true,}) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.GENDER_TYPE) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.GENDER);
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        await box.write(ApiConst.GENDER_TYPE, jsonData);
        
        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }
  
}
