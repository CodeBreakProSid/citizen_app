import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';

import 'app/modules/firebase_service/forGroundLocalNotification.dart';
import 'app/routes/app_pages.dart';
import 'app/util/general_utils.dart';
import 'app/util/theme_data.dart';
import 'default_firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ForgroundLocalNotification.handleBackGroundMessage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ForgroundLocalNotification.getFcmToken();
  await initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        ScreenUtilInit(
          builder: (BuildContext context, child) => GetMaterialApp(
            title: 'Janamaithri',
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            theme: themeData,
            localizationsDelegates: const [
              FormBuilderLocalizations.delegate,
            ],
          ),
        ),
      );
    },
  );
}
