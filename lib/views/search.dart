import 'package:expirationdate_reminder/ctrls/EtcFoodController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  final _etcFoodController = Get.find<EtcFoodController>();
  List<Category> suggestionList = [];

  @override
  Widget buildResults(BuildContext context) {
    return _drawGridView2(context, suggestionList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      for (int i = 0; i < categoryList.length; i++) {
        if (categoryList[i].lists?.isNotEmpty ?? false) {
          suggestionList.addAll(categoryList[i].lists!.where((element) => element.name.contains(query)));
        }
      }

      suggestionList = suggestionList.toSet().toList();
    } else {
      suggestionList.clear();
    }

    return _drawGridView2(context, suggestionList);
  }

  _drawGridView2(BuildContext context, List<Category> lists) {
    return Column(
      children: [
        lists.isNotEmpty
            ? SizedBox(
                height: 60.h * (lists.length / 6).ceil() + (6 * (lists.length / 6).ceil()),
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  itemCount: lists.length,
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
                          Image.asset(lists[index].imagePath),
                          Center(
                            child: FittedBox(
                              child: Text(
                                lists[index].name,
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
                        close(context, lists[index]);
                      },
                    );
                  },
                ),
              )
            : query.isNotEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    alignment: Alignment.center,
                    child: Text('\'$query\' 단어를 찾을 수 없습니다.'),
                  )
                : const SizedBox(),
        ListTile(
          tileColor: mainColor.withOpacity(.1),
          title: Text(
            '직접 입력하기',
            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            bool result = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('직접입력'),
                    content: Wrap(
                      children: [
                        TextField(
                          decoration: const InputDecoration(hintText: '음식 이름을 입력해주세요.'),
                          onChanged: (value) {
                            _etcFoodController.setFood(value);
                          },
                        ),
                        Container(
                          height: 20.h,
                        ),
                        for (int i = 0; i < (colors.length / 6).ceil(); i++)
                          Row(
                            children: [
                              for (int j = 0; j < 6; j++)
                                if (i * 6 + j < colors.length)
                                  Obx(() => InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
                                          child: Stack(
                                            alignment:Alignment.center,
                                            children: [
                                              Image.asset(
                                                colors[i * 6 + j],
                                                height: 30.h,
                                              ),
                                              _etcFoodController.color == colors[i * 6 + j] ? const Icon(Icons.check) : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _etcFoodController.setColor(colors[i * 6 + j]);
                                        },
                                      ))
                            ],
                          )
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            '확인',
                            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            _etcFoodController.clear();
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                          )),
                    ],
                  );
                });

            if (result) {
              close(context, true);
            }
          },
        )
      ],
    );
  }
}
