import 'package:expirationdate_reminder/ctrls/AddFoodController.dart';
import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/db_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/views/add_food_category.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddFood extends StatefulWidget {
  final Food? food;
  final bool edit;

  const AddFood({super.key, this.food, required this.edit});

  @override
  State<StatefulWidget> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final _refrigeratorController = Get.find<RefrigeratorController>();
  final _addFoodController = Get.find<AddFoodController>();

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.edit) {
      _addFoodController.setCategory(Category(imagePath: widget.food!.path, name: widget.food!.name));
      _addFoodController.setStorageIndex(storageList.indexOf(widget.food!.storage));
      _addFoodController.setCount(widget.food!.count);
      _addFoodController.setDate(DateTime.fromMillisecondsSinceEpoch(widget.food!.expiration));
      textEditingController = TextEditingController(text: widget.food!.memo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      actions: [
        TextButton(
          child: Text(
            widget.edit ? '수정' : '등록',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () async {
            if (widget.edit) {
              Food food = Food(
                id: widget.food!.id,
                rId: widget.food!.rId,
                path: widget.food!.path,
                name: widget.food!.name,
                storage: storageList[_addFoodController.storageIndex.value],
                count: _addFoodController.count.value,
                expiration: _addFoodController.date.value.millisecondsSinceEpoch,
                memo: textEditingController.value.text,
              );

              await DBUtils.instance.updateFood(food);
              await _refrigeratorController.getFoodList();

              ///notification
              notification.zonedNotification(food);

              if (!mounted) return;
              Navigator.pop(context);
            } else {
              if (_addFoodController.category.value != null) {
                Food food = Food(
                  rId: _refrigeratorController.refrigerator.value.id!,
                  path: _addFoodController.category.value!.imagePath,
                  name: _addFoodController.category.value!.name,
                  storage: storageList[_addFoodController.storageIndex.value],
                  count: _addFoodController.count.value,
                  expiration: _addFoodController.date.value.millisecondsSinceEpoch,
                  memo: textEditingController.value.text,
                );

                final int id = await DBUtils.instance.addFood(food);
                await _refrigeratorController.getFoodList();

                ///notification
                food.id = id;
                notification.zonedNotification(food);

                if (!mounted) return;
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(
              height: 100.0.h,
              child: FittedBox(
                child: InkWell(
                  onTap: () {
                    if (widget.edit) return;

                    Get.to(() => AddFoodCategory());
                  },
                  child: Obx(
                    () => CircleAvatar(
                      backgroundColor: _addFoodController.category.value != null ? Colors.transparent : mainColor,
                      child: _addFoodController.category.value != null
                          ? Stack(
                              children: [
                                Image.asset(_addFoodController.category.value!.imagePath),
                                Center(
                                  child: FittedBox(
                                    child: Text(
                                      _addFoodController.category.value!.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.sp,
                                        backgroundColor: Colors.white.withAlpha(80),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('보관장소'),
                Row(
                  children: [
                    for (int i = 0; i < storageList.length; i++)
                      Obx(() => OutlinedButton(
                            onPressed: () {
                              _addFoodController.setStorageIndex(i);
                            },
                            style: _addFoodController.storageIndex.value == i
                                ? OutlinedButton.styleFrom(backgroundColor: mainColor, foregroundColor: Colors.white)
                                : OutlinedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.black),
                            child: Text(storageList[i]),
                          )),
                  ],
                )
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('개수'),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _addFoodController.decreaseCount();
                      },
                      child: const Text('-'),
                    ),
                    Obx(() => Text(' ${_addFoodController.count.value} ')),
                    OutlinedButton(
                      onPressed: () {
                        _addFoodController.increaseCount();
                      },
                      child: const Text('+'),
                    ),
                  ],
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('유통기한'),
                Row(
                  children: [
                    Obx(() => Text(DateFormat("yyyy년 MM월 dd일").format(_addFoodController.date.value))),
                    10.horizontalSpace,
                    OutlinedButton(
                      onPressed: () {
                        _showDatePicker();
                      },
                      child: const Text(
                        '선택',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
            10.verticalSpace,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('메모'),
              ],
            ),
            10.verticalSpace,
            SizedBox(
              height: 100.h,
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLength: 300,
                maxLines: 10,
                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: '메모를 입력하세요.',
                  border: const OutlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: mainColor, width: 3)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showDatePicker() {
    showDialog(
      context: context,
      builder: (_) {
        DateTime? selectDateTime, expirationDateTime;
        expirationDateTime = _addFoodController.minDate;
        if (widget.edit) {
          expirationDateTime = DateTime.fromMillisecondsSinceEpoch(widget.food!.expiration);
        }

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          content: Wrap(
            children: [
              SizedBox(
                height: 150.h,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate:
                      _addFoodController.minDate.isBefore(expirationDateTime) ? _addFoodController.minDate : expirationDateTime,
                  maximumDate: _addFoodController.maxDate,
                  initialDateTime: expirationDateTime,
                  onDateTimeChanged: (DateTime value) {
                    selectDateTime = value;
                  },
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      child: Text("취소", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Text("선택", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _addFoodController.setDate(selectDateTime!);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _addFoodController.clear();
    super.dispose();
  }
}
