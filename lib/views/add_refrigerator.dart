import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/db_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddRefrigerator extends StatelessWidget {
  final _refrigeratorController = Get.find<RefrigeratorController>();
  final TextEditingController _controller = TextEditingController();

  AddRefrigerator({super.key});

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      actions: [
        TextButton(
          child: Text(
            '등록',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () async {
            if (_controller.value.text.isNotEmpty) {
              await _refrigeratorController.addRefrigerator(
                  Refrigerator(name: _controller.value.text, favorites: _refrigeratorController.rList.isEmpty ? 1 : 0));

              Navigator.pop(context, true);
            }
          },
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '냉장고 이름을 입력해주세요',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
          ),
        ),
      ),
    );
  }
}
