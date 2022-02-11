import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../app/application.dart';
import '../../route/routes.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  _RootPageState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '扫码登录',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Application.router.generator,
      // onGenerateRoute: (settings) {
      //   final settingsUri = Uri.parse(settings.name!);
      //   switch (settingsUri.path) {
      //     case "/game":
      //       String? g = settingsUri.queryParameters["g"];
      //       if (g != null) {
      //         Game? game = gameList[g];
      //         if (game != null) {
      //           if (isWx()) {
      //             launch(
      //                 "https://open.weixin.qq.com/connect/app/qrconnect?appid=${game.appId!}&bundleid=${game.bundleId!}&scope=snsapi_base,snsapi_userinfo,snsapi_friend,snsapi_message&state=weixin",
      //                 forceSafariVC: false,
      //                 webOnlyWindowName: "_self");
      //             return null;
      //           }
      //           return MaterialPageRoute(
      //               builder: (context) => WebPage(
      //                 game: game,
      //               ),
      //               settings: settings);
      //         }
      //       }
      //       return null;
      //     default:
      //   }
      //   return MaterialPageRoute(
      //       builder: (context) => const MyHomePage(title: '扫码登录'),
      //       settings: settings);
      // },settings
    );
    //    print("initial route = ${app.initialRoute}");
  }
}
