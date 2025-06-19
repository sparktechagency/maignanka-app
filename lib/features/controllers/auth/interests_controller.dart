import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class InterestsController extends GetxController {

  bool isLoading = false;

  final List<String> selectedInterests = [];





  void onInterestTap(String interest) {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
        } else {
          ToastMessageHelper.showToastMessage(
            "You can select up to 5 interests.",
          );
        }
      }
      update();

  }


  Future<void> interests() async {
    isLoading = true;
    update();

    var bodyParams = {
      "interest": List<String>.from(selectedInterests),
    };

    final response = await ApiClient.postData(
      ApiUrls.interest,
      bodyParams,
    );

    final responseBody = response.body;
    if (response.statusCode == 201) {
      Get.toNamed(AppRoutes.enableLocationScreen);
    } else {
      ToastMessageHelper.showToastMessage(responseBody?['message'] ?? "");
    }

    isLoading = false;
    update();
  }

}
