import 'package:arpon_agent/activity/PhoneLogInActivity.dart';
import 'package:arpon_agent/activity/UserInfoPrivetActivity.dart';
import 'package:arpon_agent/activity/UserInfoPublicActivity.dart';
import 'package:arpon_agent/data/my_colors.dart';
import 'package:arpon_agent/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'activity/HomeActivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('bn')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      useOnlyLangCode: true,
      child: MyAppNew(),
    ),
  );
}

class MyAppNew extends StatefulWidget {
  @override
  _MyAppNewState createState() => _MyAppNewState();
}

class _MyAppNewState extends State<MyAppNew> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    configOneSignel();
    if (auth.currentUser != null) {
      readData();
    } else {
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PhoneLogInActivity()));
      });
    }
  }

  void configOneSignel() {
    OneSignal.shared.setAppId(kAppId);
    OneSignal.shared.pauseInAppMessages(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: MyColors.veryLightWhit,
      systemNavigationBarIconBrightness: Brightness.light,

      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'poppins'),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello world!'),
            ],
          ),
        ),
      ),
    );
  }

  void readData() {
    firestore
        .collection('UserAgentSecretInformation')
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        firestore
            .collection('UserAgent')
            .doc(auth.currentUser!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot2) {
          if (documentSnapshot2.exists) {
            Future.delayed(Duration(milliseconds: 1000)).then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeActivity()));
            });
          } else {
            Future.delayed(Duration(milliseconds: 1000)).then((value) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserInfoPublicActivity()));
            });
          }
        });
      } else {
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserInfoPrivetActivity()));
        });
      }
    });
  }
}
