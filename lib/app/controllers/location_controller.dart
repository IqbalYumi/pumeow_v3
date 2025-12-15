import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  // STATE
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'GPS tidak aktif');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Error',
          'Izin lokasi ditolak permanen, aktifkan di setting',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
