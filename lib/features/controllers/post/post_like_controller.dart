import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class PostLikeController extends GetxController {
  final Map<String, bool> postLikeMap = {};

  bool isLiked(String postId) => postLikeMap[postId] ?? false;

  void setInitialLike(String postId, bool status) {
    postLikeMap[postId] = status;
    update();
  }

  Future<bool> likeButtonAction(bool currentLiked, String postId) async {
    postLikeMap[postId] = !currentLiked;
    update();

    final response = await ApiClient.postData(ApiUrls.like(postId), {});

    final responseBody = response.body;
    if (response.statusCode == 200) {
    } else {
      postLikeMap[postId] = currentLiked;
      update();

      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Failed");
    }

    return !currentLiked;
  }
}
