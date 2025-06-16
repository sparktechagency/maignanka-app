import 'package:get/get.dart';

class AuthController extends GetxController{

  bool isRegisterLoading = false;

  Future<void> register()async{
    isRegisterLoading = true;
    update();



  }

}