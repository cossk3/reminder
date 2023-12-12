import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/views/settings_alert.dart';
import 'package:expirationdate_reminder/views/settings_display.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  final _settingController = Get.find<SettingController>();
  final _refrigeratorController = Get.find<RefrigeratorController>();

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: mainColor.withAlpha(100),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
              child: const Text(
                '알림',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text('유통기한 알림'),
              subtitle: Obx(() => Text(
                    _settingController.getText(),
                    style: TextStyle(
                        color: _settingController.alertUse.value ? mainColor : Colors.black12),
                  )),
              trailing: Obx(() => Switch(
                activeColor: Colors.white,
                activeTrackColor: mainColor,
                inactiveThumbColor: mainColor,
                inactiveTrackColor: Colors.white,
                value: _settingController.alertUse.value,
                onChanged: (bool value) {
                  _settingController.toggle();

                  ///notification
                  notification.removeNotificationAll();
                  if (_settingController.alertUse.value) {
                    for (int i = 0; i < _refrigeratorController.fList.length; i++) {
                      notification.zonedNotification(_refrigeratorController.fList[i]);
                    }
                  }
                },
              )),
              onTap: () {
                Get.to(() => SettingsAlert());
              },
            ),
            Container(
              color: mainColor.withAlpha(100),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
              child: const Text(
                '화면설정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text('유통기한 표시'),
              trailing: Obx(() => Text(expirationMarkList[_settingController.displaySetting.value!], style: TextStyle(fontSize: 15.sp),)),
              onTap: () {
                Get.to(() => SettingsDisplay());
              },
            ),
          ],
        ),
      ),
    );
  }
}
