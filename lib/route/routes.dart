import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qr_login/common.dart';
import 'package:qr_login/route/route_handlers.dart';

import '../app/application.dart';

abstract class Routes {
  static String home = "/";
  static String game = "/game";
  static String identity = "/identity";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const NotFoundPage();
    });
    router.define(home,
        handler: homeHandler, transitionType: TransitionType.inFromRight);
    router.define(game,
        handler: gameRouteHandler,
        transitionType:
            isWx() ? TransitionType.none : TransitionType.inFromRight);
    router.define(identity,
        handler: identityHandler, transitionType: TransitionType.inFromRight);
  }
}

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Application.router.navigateTo(context, Routes.home,
          clearStack: true, transition: TransitionType.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const Text("页面不存在"));
  }
}
