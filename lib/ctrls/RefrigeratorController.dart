import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/db_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:get/get.dart';

class RefrigeratorController extends GetxController {
  final RxList _rList = [].obs;

  RxList get rList => _rList;

  final Refrigerator _addRefrigerator = Refrigerator(id: 9999, name: '새 냉장고 생성', favorites: 0);
  late Rx<Refrigerator> _refrigerator;

  Rx<Refrigerator> get refrigerator => _refrigerator;

  final RxList _fList = [].obs;
  RxList get fList => _fList;

  final RxList _fColdList = [].obs;
  RxList get fColdList => _fColdList;

  final RxList _fFrozenList = [].obs;
  RxList get fFrozenList => _fFrozenList;

  final RxList _fRoomList = [].obs;
  RxList get fRoomList => _fRoomList;

  @override
  void onInit() async {
    // TODO: implement onInit
    _refrigerator = _addRefrigerator.obs;
    await getRefrigeratorList();

    super.onInit();
  }

  initRefrigeratorList(List<Refrigerator> list) {
    _rList.clear();
    _rList.addAll(list);
    _rList.insert(_rList.length, _addRefrigerator);

    update();
  }

  getRefrigeratorList() async {
    final rlist = await DBUtils.instance.selectRefrigerator();
    print("[SQL DB] *** rList : ${rlist.toString()}");

    if (rlist.length > 0) {
      initRefrigeratorList(rlist);
      initRefrigerator();

      await getFoodList();
    }
  }

  addRefrigerator(Refrigerator r) async {
    await DBUtils.instance.addRefrigerator(r);
    await getRefrigeratorList();
  }

  int getFavoritesId() => _rList.firstWhere((element) => element.favorites == 1).id!;

  int getFavoritesIndex() => _rList.indexWhere((element) => element.favorites == 1);

  int indexOf(Refrigerator r) => _rList.indexOf(r);

  initRefrigerator() {
    if (_rList.isEmpty) return;

    _refrigerator.value = _rList.firstWhere((element) => element.favorites == 1);

    update();
  }

  setSelectedRefrigerator(Refrigerator r) {
    _refrigerator.value = r;
    update();
  }

  setFavoriteRefrigerator(Refrigerator r) async {
    Refrigerator ar = Refrigerator(id: r.id, name: r.name, favorites: 1);
    await DBUtils.instance.updateRefrigerator(ar);

    Refrigerator br = Refrigerator(id: _refrigerator.value.id, name: _refrigerator.value.name, favorites: 0);
    await DBUtils.instance.updateRefrigerator(br);
  }

  isAddRefrigerator(int id) => id == _addRefrigerator.id;


  getFoodList() async {
    final flist = await DBUtils.instance.findFoodById(_refrigerator.value.id!);

    _fList.clear();
    _fList.addAll(flist);

    _fColdList.clear();
    _fFrozenList.clear();
    _fRoomList.clear();
    _fColdList.addAll(_fList.where((element) => element.storage == storageList[0]).toList());
    _fFrozenList.addAll(_fList.where((element) => element.storage == storageList[1]).toList());
    _fRoomList.addAll(_fList.where((element) => element.storage == storageList[2]).toList());

    update();
    print("[SQL DB] *** fList : ${fList.toString()}");
  }
}
