import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:get/get.dart';

class EtcFoodController extends GetxController {
  final RxString _food = ''.obs;
  final RxString _color = ''.obs;

  RxString get food => _food;
  RxString get color => _color;

  @override
  void onInit() async {
    // TODO: implement onInit
    _color.value = colors.first;

    super.onInit();
  }

  setFood(String f) {
    _food.value = f;
    update();
  }

  setColor(String c) {
    _color.value = c;
    update();
  }

  clear() {
    _food.value = '';
    _color.value = colors.first;
  }
}