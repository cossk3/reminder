import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsAlert extends StatelessWidget {
  final _settingController = Get.find<SettingController>();
  final _refrigeratorController = Get.find<RefrigeratorController>();

  DateTime? _selectTime;

  SettingsAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      actions: [
        TextButton(
          onPressed: () async {
            if (_selectTime == null) return;

            _settingController.setAlertTime(_selectTime!);

            ///notification
            for (int i = 0; i < _refrigeratorController.fList.length; i++) {
              notification.zonedNotification(_refrigeratorController.fList[i]);
            }

            Navigator.pop(context);
          },
          child: Text(
            '저장',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
      child: Container(
        padding: EdgeInsets.only(top: 30.h),
        height: 150.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: _settingController.alertTime.value,
          onDateTimeChanged: (DateTime value) {
            _selectTime = value;
          },
        ),
      ),
    );
  }
}
