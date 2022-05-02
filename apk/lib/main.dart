import 'package:apk/screens/root/root.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/codegen_loader.g.dart';
import 'package:apk/utils/ourTheme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('pl')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      // assetLoader: CodegenLoader,
      child: MyApp()
  ),);
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(),
        home: OurRoot(),
      ),
    );
  }
}
