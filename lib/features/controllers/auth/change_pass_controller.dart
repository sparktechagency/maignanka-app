import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ChangePassController extends GetxController{

  final  oldPassTEController = TextEditingController();
  final  passTEController = TextEditingController();
  final  rePassTEController = TextEditingController();
  bool isLoading = false;
  
  
  Future<void> changePass()async{
    
    isLoading = true;
    update();

    final requestBody = {
      "oldPassword":oldPassTEController.text,
      "newPassword":passTEController.text,
    };

    final response = await ApiClient.postData(ApiUrls.changePassword, requestBody);

      final responseBody = response.body;
      if(response.statusCode == 200){
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Success");
        Get.back();
      }else{
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "failed.");
      }
      isLoading = false;
      update();
  }

  @override
  void dispose() {
    oldPassTEController.dispose();
    passTEController.dispose();
    rePassTEController.dispose();
    super.dispose();
  }
}