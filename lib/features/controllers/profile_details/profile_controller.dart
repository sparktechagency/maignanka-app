import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/models/my_profile_model_data.dart';
import 'package:maignanka_app/features/models/profile_details_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  bool isLoadingProfileImage = false;
  bool isLoadingProfileName = false;
  bool isLoadingMyProfile = false;
  String userId = '';
  File? profileImage;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  ProfileDetailsModelData profileDetailsModelData = ProfileDetailsModelData();
  MyProfileModelData myProfileModelData = MyProfileModelData();

  void userBasicInfo() async {
    userId = await PrefsHelper.getString(AppConstants.userId);
    update();

    debugPrint('UseId get ==========> $userId');
  }



  void selectedImage(BuildContext context){
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (file){
        profileImage = File(file.path);
        update();
        editProfileImage();
      },
    );

  }



  Future<void> profileDetailsGet(String userId) async {
    isLoading = true;
    update();

    final response = await ApiClient.getData(ApiUrls.profileDetails(userId));

    final responseBody = response.body;

    if (response.statusCode == 200) {
      profileDetailsModelData = ProfileDetailsModelData.fromJson(
        responseBody['data'] ?? {},
      );
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }



  Future<void> myProfileGet() async {
    isLoadingMyProfile = true;
    update();

    final response = await ApiClient.getData(ApiUrls.myProfile);

    final responseBody = response.body;

    if (response.statusCode == 200) {
      myProfileModelData = MyProfileModelData.fromJson(
        responseBody['data'] ?? {},
      );
      await PrefsHelper.setString(
        AppConstants.userId,
        responseBody['data']?['_id'],
      );
      userBasicInfo();
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingMyProfile = false;
    update();
  }




  Future<void> editProfileImage() async {
    isLoadingProfileImage = true;
    update();



    List<MultipartBody>? multipartBody;
    if (profileImage != null) {
      multipartBody = [MultipartBody('image', profileImage ?? File(''))];
    }

    final response = await ApiClient.postMultipartData(
      ApiUrls.updateProfile,
      {},
      multipartBody: multipartBody,
    );
    final responseBody = response.body;

    if (response.statusCode == 200) {
      myProfileGet();
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? '');
    } else {
      ToastMessageHelper.showToastMessage("Failed to fetch profile data");
    }
    isLoadingProfileImage = false;
    update();

  }



  Future<void> editProfileName() async {
    isLoadingProfileName = true;
    update();


    final response = await ApiClient.patch(ApiUrls.profiles, {
      'name': '${firstnameController.text.trim()} ${lastnameController.text.trim()}',
    });
    final responseBody = response.body;

    if (response.statusCode == 200) {
      myProfileGet();
      Get.back();
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? '');
    } else {
      ToastMessageHelper.showToastMessage("Failed to fetch profile data");
    }
    isLoadingProfileName = false;
    update();
  }
}
