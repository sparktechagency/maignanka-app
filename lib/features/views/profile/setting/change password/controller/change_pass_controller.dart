import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ChangePassController extends GetxController{

  final  oldPassTEController = TextEditingController();
  final  passTEController = TextEditingController();
  final  rePassTEController = TextEditingController();
  RxBool isLoading = false.obs;
  
  
  Future<void> changePass(BuildContext context)async{
    
    isLoading.value = true;

    final requestBody = {
      "oldPassword":oldPassTEController.text,
      "newPassword":passTEController.text,
      "confirmPassword":rePassTEController.text,
    };
    
    try {
      final response = await ApiClient.postData(ApiUrls.changePassword, requestBody);

      final responseBody = response.body;
      if(response.statusCode == 200 && responseBody['success'] == true){
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Success");
      }else{
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    }finally{
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    oldPassTEController.dispose();
    passTEController.dispose();
    rePassTEController.dispose();
    super.dispose();
  }
}