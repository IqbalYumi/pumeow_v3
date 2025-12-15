import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;

  void addNotification(Map<String, dynamic> data) {
    notifications.add(data);
  }
}
