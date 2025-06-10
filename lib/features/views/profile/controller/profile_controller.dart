import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/views/profile/models/my_profile_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<MyProfileData> _profileData = MyProfileData().obs;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var profileImage = Rx<File?>(null);

  MyProfileData get profileData => _profileData.value;

  @override
  void onInit() {
    super.onInit();
   // getMyProfile();
  }

  Future<void> getMyProfile() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrls.myProfile);
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        _profileData.value = MyProfileData.fromJson(responseBody['data']);
      } else {
        ToastMessageHelper.showToastMessage("Failed to fetch profile data");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }








  Future<void> editProfile(BuildContext context) async {
    try {
      isLoading.value = true;


      final bodyParams = {


      };

      List<MultipartBody>? multipartBody;
      if (profileImage.value != null) {
        multipartBody = [
          MultipartBody('image', profileImage.value!)
        ];
      }



      final response = await ApiClient.patchMultipartData(
          ApiUrls.updateProfile, {},
          multipartBody: multipartBody);
      final responseBody = response.body;

      final String? userName = responseBody['data']?['user']?['name'] ?? '';
      final String? userImage = responseBody['data']?['user']?['image'] ?? '';
      final String? bio = responseBody['data']?['user']?['boi'] ?? '';

      if (response.statusCode == 200 && responseBody['success'] == true) {
        await PrefsHelper.setString(AppConstants.name, userName);
        await PrefsHelper.setString(AppConstants.image, userImage);
        await PrefsHelper.setString(AppConstants.bio, bio);
        getMyProfile();
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? '');

      } else {
        ToastMessageHelper.showToastMessage("Failed to fetch profile data");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    profileImage = null.obs;
    super.dispose();
  }

}
