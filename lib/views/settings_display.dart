import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDisplay extends StatelessWidget {
  final _settingController = Get.find<SettingController>();

  SettingsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      child: Column(
        children: [
          for (int i = 0; i < expirationMarkList.length; i++)
            Obx(() => ListTile(
                  title: Text(expirationMarkList[i]),
                  trailing: _settingController.displaySetting.value == i ? const Icon(Icons.check) : SizedBox(),
                  onTap: () {
                    _settingController.setDisplaySettings(i);
                  },
                )),
        ],
      ),
    );
  }
}
