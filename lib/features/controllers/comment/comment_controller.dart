import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/features/models/comment_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class CommentController extends GetxController {

  bool isLoading = false;
  bool isLoadingCreate = false;
  int limit = 20;
  int page = 1;
  int totalPage = -1;


  List<CommentModelData> commentData = [];

  final TextEditingController commentController = TextEditingController();





  Future<void> commentGet(String postId,{bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      commentData.clear();
      page = 1;
      totalPage = -1;
    }

    isLoading = true;
    update();

    final response = await ApiClient.getData(
      ApiUrls.comment(postId,page,limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final post = data.map((json) => CommentModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      commentData.addAll(post);
      //Get.find<PostController>().postGet(i);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<void> createComment(String postId) async {

    isLoadingCreate = true;
    update();


    final bodyParams = {
      'comment' : commentController.text.trim(),
    };

    final response = await ApiClient.postData(
      ApiUrls.createComment(postId),bodyParams,
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      commentController.clear();
      commentGet(postId,isInitialLoad: true);
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingCreate = false;
    update();
  }


  Future<void> loadMore(String postId) async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await commentGet(postId);
    }
  }


  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
