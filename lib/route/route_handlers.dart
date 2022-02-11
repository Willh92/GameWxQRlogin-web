import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qr_login/ui/game/game_page.dart';
import 'package:qr_login/ui/home/home_page.dart';

import '../bean/menu.dart';
import '../common.dart';

var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const HomePage(title: "扫码登录");
});

var gameRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? name = params["name"]?.first;
  Game? game;
  if (name != null) {
    game = gameList[name];
  }
  return GamePage(
    game: game,
  );
});
