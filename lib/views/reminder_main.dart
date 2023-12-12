import 'package:expirationdate_reminder/ctrls/DeleteController.dart';
import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/views/add_food.dart';
import 'package:expirationdate_reminder/views/add_refrigerator.dart';
import 'package:expirationdate_reminder/views/settings.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReminderMain extends StatefulWidget {
  const ReminderMain({super.key});

  @override
  State<ReminderMain> createState() => _ReminderMainState();
}

class _ReminderMainState extends State<ReminderMain> {
  final _deleteController = Get.find<DeleteController>();
  final _settingController = Get.find<SettingController>();
  final _refrigeratorController = Get.find<RefrigeratorController>();

  @override
  void initState() {
    // TODO: implement initState
    notification.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MYScafflod(
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Get.to(() => Settings());
        },
      ),
      actions: [
        IconButton(
          onPressed: () async {
            if (_refrigeratorController.rList.isEmpty || _refrigeratorController.fList.isEmpty) return;

            if (_deleteController.delete.value) {
              await _deleteController.remove();
              await _refrigeratorController.getFoodList();
            }
            _deleteController.changeMode();
          },
          icon: Obx(() => _deleteController.delete.value ? const Icon(Icons.check) : const Icon(Icons.delete_forever)),
        )
      ],
      floatingActionButton: FittedBox(
        child: FloatingActionButton.large(
          onPressed: () {
            Get.to(
              () => _refrigeratorController.rList.isEmpty
                  ? AddRefrigerator()
                  : const AddFood(
                      edit: false,
                    ),
            );
          },
          backgroundColor: mainColor,
          shape: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Obx(() => _refrigeratorController.rList.isEmpty
                ? Image.asset(
                    'assets/images/icon_refrigerator.png',
                  )
                : const Icon(Icons.add)),
          ),
        ),
      ),
      child: Column(
        children: [
          Obx(() => _refrigeratorController.rList.isNotEmpty
              ? DropdownButton(
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  value: _refrigeratorController.indexOf(_refrigeratorController.refrigerator.value),
                  items: _refrigeratorController.rList
                      .map(
                        (e) => DropdownMenuItem(
                          value: _refrigeratorController.indexOf(e),
                          child: _refrigeratorController.isAddRefrigerator(e.id!)
                              ? TextButton(
                                  onPressed: () {
                                    Get.to(() => AddRefrigerator());
                                  },
                                  child: Text(
                                    e.name,
                                    style: TextStyle(color: mainColor),
                                  ))
                              : Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (int? value) async {
                    Refrigerator r = _refrigeratorController.rList[value!];
                    if (_refrigeratorController.isAddRefrigerator(r.id!)) {
                      Get.to(AddRefrigerator());
                    } else {
                      _refrigeratorController.setSelectedRefrigerator(r);
                      _refrigeratorController.getFoodList();
                    }
                  },
                )
              : const SizedBox()),
          Obx(() => _refrigeratorController.rList.isEmpty
              ? Expanded(
                  child: Container(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                    child: Text(
                      '나만의 냉장고를\n만들어보세요.',
                      style: TextStyle(fontSize: 40.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
              : const SizedBox()),
          Expanded(child: Obx(() => _refrigeratorController.rList.isNotEmpty ? _getFoodGridView(0) : const SizedBox())),
          Expanded(child: Obx(() => _refrigeratorController.rList.isNotEmpty ? _getFoodGridView(1) : const SizedBox())),
          Expanded(child: Obx(() => _refrigeratorController.rList.isNotEmpty ? _getFoodGridView(2) : const SizedBox())),
        ],
      ),
    );
  }

  _getFoodGridView(int index) {
    List list = index == 0
        ? _refrigeratorController.fColdList
        : index == 1
            ? _refrigeratorController.fFrozenList
            : _refrigeratorController.fRoomList;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.w),
          width: double.infinity,
          color: mainColor.withAlpha(150),
          child: Text(
            storageList[index],
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: list.length,
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1 / 1.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext context, int index) {
              DateTime now = DateTime.now();
              DateTime expiration = DateTime.fromMillisecondsSinceEpoch(list[index].expiration);
              int day = expiration.difference(now).inDays;

              if (day == 0) {
                if (expiration.day != now.day) day = 1;
              }

              return InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 50.h,
                          child: Image.asset(list[index].path),
                        ),
                        FittedBox(
                          child: Text(
                            list[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              backgroundColor: Colors.white.withAlpha(80),
                            ),
                          ),
                        ),
                        Obx(() => _deleteController.delete.value
                            ? InkWell(
                                child: Container(
                                  color: Colors.white.withAlpha(200),
                                  child: Icon(
                                    Icons.delete_forever_outlined,
                                    color: _deleteController.contains(list[index]) ? Colors.red : Colors.black,
                                    size: 50.w,
                                  ),
                                ),
                                onTap: () {
                                  _deleteController.addOrRemove(list[index]);
                                },
                              )
                            : const SizedBox()),
                      ],
                    ),
                    Obx(
                      () => FittedBox(
                        child: Text(
                          _settingController.getExpirationMark(day, DateTime.fromMillisecondsSinceEpoch(list[index].expiration)),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: day >= 0 ? Colors.black : Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Get.to(() => AddFood(
                        food: list[index],
                        edit: true,
                      ));
                },
              );
            },
          ),
        )
      ],
    );
  }
}
