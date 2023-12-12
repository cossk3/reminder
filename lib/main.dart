import 'package:expirationdate_reminder/ctrls/AddFoodController.dart';
import 'package:expirationdate_reminder/ctrls/DeleteController.dart';
import 'package:expirationdate_reminder/ctrls/EtcFoodController.dart';
import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:expirationdate_reminder/views/reminder_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ko', 'KO'),
      Locale('en', 'US'),
    ],
    locale: const Locale('ko'),
    theme: ThemeData(
      useMaterial3: true,
      primaryColor: mainColor,
      colorScheme: const ColorScheme.light().copyWith(primary: mainColor),
      fontFamily: 'IBMPlexSansKR',
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: mainColor,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    Get.put(DeleteController());
    Get.put(SettingController());
    Get.put(RefrigeratorController());
    Get.put(AddFoodController());
    Get.put(EtcFoodController());

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      builder: (_, child) {
        return child!;
      },
      child: const ReminderMain(),
    );
  }
}
