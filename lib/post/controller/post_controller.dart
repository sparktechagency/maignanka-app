import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/post/models/post_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class PostController extends GetxController {
  RxBool isLoading = false.obs;
  RxString type = 'all'.obs;
  RxString date = ''.obs;
  RxString communityId = ''.obs;


  RxInt page = 1.obs;
  var totalPage = (-1);
  var currentPage = (-1);
  var totalResult = (-1);

  final ScrollController scrollController = ScrollController();

  final RxList<PostData> postDataList = <PostData>[].obs;





  Future<void> getPost() async {


    if(page.value == 1){
      postDataList.clear();
      isLoading(true);
    }

    try {
      final response = await ApiClient.getData(
        ApiUrls.post(communityId.value,type.value,'${page.value}'),
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
        totalPage = int.tryParse(responseBody['pagination']['totalPage'].toString()) ?? 0;
        currentPage = int.tryParse(responseBody['pagination']['currentPage'].toString()) ?? 0;
        totalResult = int.tryParse(responseBody['pagination']['totalItem'].toString()) ?? 0;


        final List data = responseBody['data'];
         final postData = data.map((json) => PostData.fromJson(json)).toList();
           postDataList.addAll(postData);

      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void loadMore() {
    print("==========================================total page ${totalPage} page No: ${page.value} == total result ${totalResult}");
    if (totalPage > page.value) {
      page.value += 1;
      getPost();
      print("**********************print here");
    }
    print("**********************print here**************");
  }



  void onChangeType(String newType) {
    type.value = newType;
    page.value = 1;
    getPost();
  }
}
