import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:flutter/material.dart';

class MYScafflod extends StatelessWidget {
  Color? color;
  Widget? title;
  Widget? leading;
  List<Widget>? actions;
  Widget child;
  Widget? floatingActionButton;
  EdgeInsetsGeometry? padding;

  MYScafflod({
    this.color,
    this.title,
    this.leading,
    this.actions,
    required this.child,
    this.floatingActionButton,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color ?? mainColor,
        title: title ?? Text("리마인더"),
        leading: leading,
        actions: actions,
      ),
      body: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
