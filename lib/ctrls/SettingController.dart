import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class SettingController extends GetxController {
  GetStorage box = GetStorage();

  late AlertSetting alertSetting;

  final RxBool _alertUse = true.obs;

  RxBool get alertUse => _alertUse;
  final _alertTime = Rxn<DateTime>();

  Rxn<DateTime> get alertTime => _alertTime;

  final _displaySetting = RxnInt();

  RxnInt get displaySetting => _displaySetting;

  /// alert
  final pAlert = 'ALERT';
  final pUse = 'ALERT_USE';
  final pTime = 'ALERT_TIME';

  /// display
  final pExpirationMark = 'EXPIRATION_MARK';

  @override
  void onInit() async {
    // TODO: implement onInit

    alertSetting = await getAlertSettings();
    _alertUse.value = alertSetting.use;
    _alertTime.value = alertSetting.time;

    int setting = await getDisplaySettings();
    _displaySetting.value = setting;

    super.onInit();
  }

  toggle() => _alertUse.value = _alertUse.value ? false : true;

  setAlertUse(bool use) {
    _alertUse.value = use;
    update();

    box.write(pUse, _alertUse.value);
    alertSetting.use = _alertUse.value;
  }

  setAlertTime(DateTime time) {
    _alertTime.value = time;
    update();

    box.write(pTime, _alertTime.value);
    alertSetting.time = _alertTime.value;
  }

  getExpirationMark(int day, DateTime date) {
    if (_displaySetting.value == 0) {
      return day >= 0 ? 'D-${day.abs()}' : 'D+${day.abs()}';
    }

    if (_displaySetting.value == 1) {
      return DateFormat('yy.MM.dd').format(date!);
    }

    return '';
  }

  Future getAlertSettings() async {
    bool use = box.read(pUse) ?? true;

    DateTime time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
    int? intTime = box.read(pTime);
    if (intTime != null) {
      time = DateTime.fromMillisecondsSinceEpoch(intTime);
    }

    return AlertSetting(use: use, time: time);
  }

  Future getDisplaySettings() async {
    return box.read(pExpirationMark) ?? 0;
  }

  setDisplaySettings(int i) {
    _displaySetting.value = i;
    update();

    box.write(pExpirationMark, _displaySetting.value);
  }

  getText() {
    List<String> text = [];

    text.add(DateFormat("aaa HH:mm").format(_alertTime.value!));
    text.add('>');

    return text.join(" ");
  }
}
