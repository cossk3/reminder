import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/db_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:get/get.dart';

class DeleteController extends GetxController {
  RxBool _delete = false.obs;
  RxBool get delete => _delete;

  final RxList _lists = [].obs;
  RxList get lists => _lists;

  changeMode() {
    _delete.value = !(_delete.value);
    update();
  }

  addOrRemove(Food food) {
    if (_lists.contains(food)) {
      _lists.remove(food);
    } else {
      _lists.add(food);
    }

    update();
  }

  contains(Food food){
    return _lists.contains(food);
  }

  remove() async {
    if (_lists.isNotEmpty) {
      List ids = _lists.map((e) => e.id!).toList();
      _lists.clear();
      await DBUtils.instance.removeFoods(ids);

      update();
    }
  }
}