import 'package:expirationdate_reminder/ctrls/AddFoodController.dart';
import 'package:expirationdate_reminder/ctrls/EtcFoodController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/views/search.dart';
import 'package:expirationdate_reminder/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddFoodCategory extends StatelessWidget {
  final _categoryController = Get.find<AddFoodController>();
  final _etcFoodController = Get.find<EtcFoodController>();

  AddFoodCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return MYScafflod(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요.',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                ),
                onTap: () async {
                  final result = await showSearch(context: context, delegate: Search(), useRootNavigator: true);

                  if (result ?? false) {
                    _categoryController
                        .setCategory(Category(imagePath: _etcFoodController.color.value, name: _etcFoodController.food.value));
                    _etcFoodController.clear();

                    Navigator.pop(context);
                  }
                },
              ),
            ),
            30.verticalSpace,
            SizedBox(
              height: 60.h * (categoryList.length / 6).ceil() + (6 * (categoryList.length / 6).ceil()),
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Stack(
                      children: [
                        Image.asset(categoryList[index].imagePath),
                        Center(
                          child: FittedBox(
                            child: Text(
                              categoryList[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                backgroundColor: Colors.white.withAlpha(80),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      _categoryController.setCategory(categoryList[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            for (int i = 0; i < categoryList.length; i++) _drawGridView(context, i),
          ],
        ),
      ),
    );
  }

  _drawGridView(BuildContext context, int i) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
          width: double.infinity,
          color: mainColor.withAlpha(150),
          child: Text(
            categoryList[i].name,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 60.h * (categoryList[i].lists!.length / 6).ceil() + (6 * (categoryList[i].lists!.length / 6).ceil()),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryList[i].lists!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1 / 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Stack(
                  children: [
                    Image.asset(categoryList[i].lists![index].imagePath),
                    Center(
                      child: FittedBox(
                        child: Text(
                          categoryList[i].lists![index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp, backgroundColor: Colors.white.withAlpha(50)),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  _categoryController.setCategory(categoryList[i].lists![index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
