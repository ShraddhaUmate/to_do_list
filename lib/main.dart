// import 'dart:async';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:to_do_list/size_config.dart';
// import 'Home/home_page.dart';
// import 'core/app_preferences.dart';
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp>  {
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//         builder: (BuildContext context, Widget? child) {
//           final MediaQueryData data = MediaQuery.of(context);
//           return MediaQuery(
//             data: data.copyWith(
//                 textScaleFactor:
//                 data.textScaleFactor > 1.0 ? 1.1 : data.textScaleFactor),
//             child: child!,
//           );
//         },
//         debugShowCheckedModeBanner: false,
//         title: 'Todo App',
//         home:  MyHomePage(),
//         routes: <String, WidgetBuilder>{
//           '/homePageActivity': (BuildContext context) => const HomePage()
//         });
//   }
//
// }
//
// class MyHomePage extends StatefulWidget {
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
//
//   // Here we are using Animation Controller to show our Splash in Animation //
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     startTimer();
//     getDeviceID();
//     getDeviceType();
//     getAppVersion();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//
//     _animationController.forward();
//
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: ScaleTransition(
//             scale: _scaleAnimation,
//             child: Container(
//               height: SizeConfig.screenHeight * 0.28,
//               width: SizeConfig.screenWidth * 0.55,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     offset: Offset(0, 8),
//                     blurRadius: 20,
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Text(
//                   '📝 ToDo App',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.2,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black26,
//                         offset: Offset(1, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//   /* Timer */
//   startTimer() async {
//     Timer(const Duration(seconds: 5), navigateToHomePage);
//   }
//
//   void navigateToHomePage() async {
//     Navigator.of(context).pushReplacementNamed('/homePageActivity');
//   }
//
//   /*Function for get Device Type is IOS or Android */
//
//   getDeviceType() {
//     if (Platform.isAndroid) {
//       AppPreferences.setDeviceType("2");
//     } else if (Platform.isIOS) {
//       AppPreferences.setDeviceType("1");
//     } else if (Platform.isMacOS) {
//       AppPreferences.setDeviceType("3"); // Use a different value for macOS
//     }
//   }
//
//
//   void getDeviceID() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//
//     if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       AppPreferences.setDeviceId(iosInfo.identifierForVendor!);
//     } else if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       AppPreferences.setDeviceId(androidInfo.id ?? "unknown_android_id");
//     } else if (Platform.isMacOS) {
//       MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
//       AppPreferences.setDeviceId(macOsInfo.systemGUID!);
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
//
//   /* Set app Version */
//   getAppVersion() {
//     PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//       String version = packageInfo.version;
//       print("vejrjrf  $version");
//       AppPreferences.setAppVersion(version);
//     });
//   }
//
//
// }
//
//

import 'package:flutter/material.dart';
import 'Home/home_page.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

