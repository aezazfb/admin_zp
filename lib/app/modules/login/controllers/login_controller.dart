import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  dynamic dataFromLastScreen = Get.arguments;

  final count = 0.obs;
  @override
  void onInit() {
    print("Title: ${dataFromLastScreen.notification?.title}");
    print("Body: ${dataFromLastScreen.notification?.body}");
    print("theData: ${dataFromLastScreen.data}");


    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
