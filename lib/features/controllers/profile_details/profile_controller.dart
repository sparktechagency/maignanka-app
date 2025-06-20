import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/profile_details_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ProfileController extends GetxController {

  bool isLoading = false;

   ProfileDetailsModelData profileDetailsModelData = ProfileDetailsModelData();

  Future<void> profileDetailsGet(String userId) async {

    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.profileDetails(userId)
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      profileDetailsModelData = ProfileDetailsModelData.fromJson(responseBody['data'] ?? {});
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
}
