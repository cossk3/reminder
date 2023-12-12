import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:get/get.dart';

class AddFoodController extends GetxController {
  final _category = Rxn<Category>();

  Rxn<Category> get category => _category;

  RxInt _storageIndex = 0.obs;

  RxInt get storageIndex => _storageIndex;

  RxInt _count = 1.obs;

  RxInt get count => _count;

  late DateTime minDate = DateTime.now(), maxDate = DateTime(DateTime.now().year + 10);
  final Rx<DateTime> _date = DateTime.now().obs;
  Rx<DateTime> get date => _date;

  setCategory(Category c) {
    _category.value = c;
    update();
  }

  setStorageIndex(int index) {
    _storageIndex.value = index;
    update();
  }

  setCount(int cnt) {
    _count.value = cnt;
    update();
  }

  increaseCount() {
    if (_count < 1000) {
      _count.value++;
      update();
    }
  }

  decreaseCount() {
    if (_count > 0) {
      _count.value--;
      update();
    }
  }

  setDate(DateTime time) {
    _date.value = time;
    update();
  }

  clear() {
    _category.value = null;
    _storageIndex = 0.obs;
    _count = 1.obs;
    _date.value = DateTime.now();
  }
}
